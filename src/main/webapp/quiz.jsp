    <!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="http://cdn.datatables.net/1.10.9/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="css/style.css" />
    <style>
        .question_template, .answer_template{
            display: none;
        }
        .active_question{
            'background-color: green !important;
        }
        .inactive_question{
            display: none;
        }
        [type='radio']{
            display: none;
        }
        .btn-primary.active{
            background-color: green;
        }
    </style>

    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="http://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script>
    "use strict";
    let quiz;
    let current_question = -1; // current question is "quiz not started"
    let score = 0;
    let uuid;
    let nick;

    function Quiz(newQuiz){
        this.name = newQuiz.name;
        this.uuid = newQuiz.uuid;
        this.duration_seconds = newQuiz.duration_seconds;
        this.startTime = newQuiz.startTime;
        this.scoreboard = newQuiz.scoreboard;
        this.chat = newQuiz.chat;
        this.questions = newQuiz.questions;

        // Is the quiz currently running?
        this.running = function(){
            let time_spent = this.timeSinceStart();

            return !(time_spent < 0 || time_spent >= this.duration_seconds);
        };

        // Seconds since quiz started. Negative value means quiz hasn't started.
        this.timeSinceStart = function(){
            return now() - quiz.startTime;
        };

        // Seconds until quiz ends. Negative value means quiz has ended.
        this.timeUntilEnd = function(){
            return (this.startTime + this.duration_seconds) - now();
        };

        // Seconds until quiz starts. Negative value means quiz has started.
        this.timeUntilStart = function(){
            return this.startTime - now();
        };

        this.hasStarted = function(){
            return (this.timeUntilStart() < 0);
        };

        this.hasEnded = function(){
            return (this.timeUntilEnd() < 0);
        };

        this.timeLeftInCurrentQuestion = function(){

            let pointInTimeNextQuestion = quiz.startTime;
            for(let i = 0; i <= this.indexOfQuestion(current_question); i++)
                pointInTimeNextQuestion += +quiz.questions[i].duration_seconds;

            return pointInTimeNextQuestion - now();
        };

        // Returns which index (if any) a given question object is at in our question array
        this.indexOfQuestion = function(question){
            for(let i = 0; i < this.questions.length; i++){
                if(question === this.questions[i])
                    return i;
            }
            return -1;
        };

        // Which question is currently being answered? This might be null if quiz is not running.
        this.getActiveQuestion = function(){
            if(!this.running())
                return null;

            let time_spent = this.timeSinceStart();

            let time_counter = 0;
            for(let i = 0; i < this.questions.length; i++){
                time_counter += this.questions[i].duration_seconds;
                if(time_counter > time_spent)   // This means the user is currently answering questions[i]. index = i.
                    return this.questions[i];
            }

            throw "This should not happen. getActiveQuestion() failed to find active question while quiz is running!";
        };

    }

        // seconds since 1970
        function now(){
            return Math.floor(new Date().getTime()/1000);
        }

    // Check if user has chosen the right answer for the current question
    function rightAnswer(question){
        if(question == null)
            return;

        let correctAnswerIndex = question.right_answer;

        let currentAnswerIndex = $(".active_question").first().find(".btn.active").find(".radio").val();

        console.log(currentAnswerIndex + " " + correctAnswerIndex);

        if(!currentAnswerIndex || !correctAnswerIndex) // these should both have values, or the comparison is meaningless
            return false;

        return (currentAnswerIndex == correctAnswerIndex);

    }

    function updateSecondsLeft(){

        if(!quiz.running()) // Only check if we're on an active question
            return;

        $(".active_question").first().find(".question_seconds_left").html("(" + quiz.timeLeftInCurrentQuestion() + " / " + current_question.duration_seconds + " seconds left)");
    }



    // Adds 1 to current score if right answer is selected, and sends score to server.
    // Updates user's score on website
    function checkAndUpdateScore(question){
        // Only bother checking for valid questions
        if(question != null){

            if(rightAnswer(question)){
                score++;

                 $.ajax({
                    url: 'rest/quizes/quiz/' + uuid + '/setScore/' + nick,
                    type: 'POST',
                    data:  JSON.stringify(score),
                    contentType: 'application/json'
                });

                //TODO: play chime
            }
            else{
                //TODO: play annoying honking sound
            }
        }

        $("#score").html(score);
    }

    function reloadChat(){

        $.getJSON("rest/quizes/quiz/"+quiz.uuid+"/chat", null, function(data){
            let messages = ""   ;
            for(let message of data){
                messages += message + "<br>";
            }
            $("#chat").html(messages);

        });
    }

    //Executes once a second
    function Tick(){

        reloadChat();

        //console.log("seconds since start: " + quiz.timeSinceStart() +  " seconds until start: " + quiz.timeUntilStart() + " running: " + quiz.running() + " time until end: " + quiz.timeUntilEnd());

        let newActiveQuestion = quiz.getActiveQuestion();

        if(!quiz.hasStarted())                             // if quiz has NOT started
            $("#starts_in").html(quiz.timeUntilStart());
        else if(quiz.hasEnded())                        // if quiz has ended
            $("#starts_in").html("quiz is already over!");
        else                                                    // otherwise, quiz is ongoing
            $("#starts_in").html("quiz has started!");


        // If quiz hasn't started yet, we don't need to do anything else in this tick.
        if(!quiz.hasStarted())
            return;

        updateSecondsLeft();

        if(newActiveQuestion !== current_question){  // We are jumping to next question

            checkAndUpdateScore(current_question); //calculate user's score and send it to server.

            current_question = newActiveQuestion;

            if(current_question == null){    // quiz is over!!!!
                console.log("Checking score one last time " + quiz.indexOfQuestion(quiz.getActiveQuestion));
                checkAndUpdateScore(); // Add/save the final score before we shut down the whole quiz. This line should probably be refactored.
                console.log("We just finished checking score one last time " + quiz.indexOfQuestion(quiz.getActiveQuestion));
                endQuiz();
                return;
            }

            $(".question:eq("  + quiz.indexOfQuestion(current_question) + ")").addClass("active_question").removeClass("inactive_question");
            $(".question").not(':eq(' + quiz.indexOfQuestion(current_question) + ')').addClass("inactive_question").removeClass("active_question");
        }
    }

    function endQuiz(){
        $(".question").addClass("inactive_question").removeClass("active_question");
        alert("thanks for playing");

    }

    $(document).ready(function(){
        uuid = "<%= request.getParameter("uuid") %>";
        nick = "<%= request.getParameter("nickname") %>";
        let url = "rest/quizes/quiz/" + uuid;

        $.ajax({
            url: url + '/join',
            type: 'POST',
            data: nick,
            contentType: 'text/plain;',
            success: function(result) {
                score = +result;
            }
        });

        $.getJSON(url, null, function(data){
            quiz = new Quiz(data); // Encapsulate the data into a Quiz object that has constructor, helper functions, etc.

            $("#quiz_name").html(quiz.name);
            $("#quiz_duration").html(quiz.duration_seconds);
            $("#nickname").html("<%= request.getParameter("nickname") %>");
            $("#max_score").html(quiz.questions.length);

            for( let i = 0; i < quiz.questions.length; i++) {
                let question = quiz.questions[i];

                let question_box = $(".question_template").first().clone(true,true);
                question_box.removeClass("question_template");
                question_box.addClass("question");

                question_box.find(".card-title").html("Question " + (i+1) + " of " + quiz.questions.length);
                question_box.find(".question_text").html(question.question);
                if(question.picture_url){    // Set the picture if the question has one.
                    question_box.find(".question_picture").attr("src",question.picture_url);
                    question_box.find(".question_picture_link").attr("href",question.picture_url);
                }

                for(let j = 0; j < question.answers.length; j++){
                    let answer = question.answers[j];

                    let answer_box = $(".answer_template").first().clone(true,true);
                    answer_box.removeClass("answer_template");
                    answer_box.addClass("answer");

                    answer_box.find(".radio").after(answer);
                    answer_box.find(".radio").attr("name","answer_"+i+"_"+j);
                    answer_box.find(".radio").val(j);

                    question_box.find(".answer_box").append(answer_box);
                }
                $(".frontpage").append(question_box);
            }
        });

        $("#chat_input").keyup(function(event){
            if(event.keyCode == 13){
                let message = "&lt;" + nick + "&gt;: " + $("#chat_input").val();
                $("#chat_input").val("");

                let url = "rest/quizes/quiz/" + quiz.uuid + "/chat";

                $.ajax({
                    url: url,
                    type: 'POST',
                    data: message,
                    contentType: 'text/plain;',
                    success: function(result) {
                    }
                });
            }
        });

        setInterval(Tick, 1000);

    });


    </script>
</head>
<body>


<div class="full-width answer_template">
    <label class="btn btn-primary">
        <input type="radio" name="options" id="option1" class="radio">
    </label>
</div>

<div class="card card-body bg-light question_template inactive_question">
    <h2 class="card-title">Question 1/10</h2>
    <span class="question_seconds_left"></span>
    <div class="question_text">
    </div>
    <a class="question_picture_link">
        <img class="question_picture img-responsive"></img>
    </a>

    <div class="btn-group btn-group-vertical answer_box" data-toggle="buttons">

    </div>
</div>


<div class="container" >
    <div class="frontpage card card-body bg-light">
    <h1 class="card-title" id="quiz_name"></h1>
        <div class="row">
            <div class="col-sm-5">
                Quiz will last for this many seconds:
            </div>
            <div class="col-sm-7" id="quiz_duration"></div>
        </div>
        <div class="row">
            <div class="col-sm-5">
                Quiz starts in this many seconds:
            </div>
            <div class="col-sm-7" id="starts_in"></div>
        </div>
        <div class="row">
            <div class="col-sm-5">
                Your nickname:
            </div>
            <div class="col-sm-7" id="nickname"></div>
        </div>
        <div class="row">
            <div class="col-sm-5">
                Your score:
            </div>
            <div class="col-sm-7">
                <span id="score">0</span> out of <span id="max_score"></span>
            </div>
        </div>
    </div>
    <div class="card card-body bg-light">
        <h2 class="card-title">Chat</h2>
        <div id="chat">
        </div>

        <input type="text" id="chat_input">
    </div>
    <a href="index.html" class="btn btn-primary">Back</a>


</div>
</body>
</html>