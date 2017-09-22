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
    "use strict"
    let quiz;
    let current_question = -1; // current question is "quiz not started"
    let score = 0;

    // -1 if quiz hasn't started, -2 if it's over, otherwise index of right question.
    function getActiveQuestion(){
        let now = Math.floor(new Date().getTime()/1000); //seconds since 1970
        let time_spent = now - quiz.startTime;

        if(time_spent < 0){ // Still waiting for quiz to start...
            return -1;
        }
        else if(time_spent >= quiz.duration_seconds){    // The quiz is already over!
            return -2;
        }
        // The quiz should be active.
        let time_counter = 0;
        for(let i = 0; i < quiz.questions.length; i++){
            time_counter += quiz.questions[i].duration_seconds;
            if(time_counter > time_spent)   // This means the user is currently answering questions[i]. index = i.
                return i;
        }

        return -2; // Shouldn't happen, but just in case we get here we can conclude that quiz is over

    }

    function updateTitle(){

        if(current_question < 0) // Only check if we're on an active question
            return;

        let pointInTimeNextQuestion = quiz.startTime;
        for(let i = 0; i <= current_question; i++)
            pointInTimeNextQuestion += +quiz.questions[i].duration_seconds;

        let now = Math.floor(new Date().getTime()/1000);
        let timeLeft = pointInTimeNextQuestion - now;

        $(".active_question").first().find(".question_seconds_left").html("(" + timeLeft + " / " + quiz.questions[current_question].duration_seconds + " seconds left)");
    }

    // Check if user has chosen the right answer for the current question
    function rightAnswer(){
      if(current_question < 0)
        return false;   // Not a valid question.

    let correctAnswerIndex = quiz.questions[current_question].right_answer;
    let currentAnswerIndex = $(".active_question").first().find(".btn.active").find(".radio").val()


    console.log("you selected " + currentAnswerIndex + " correct is: " + correctAnswerIndex);
    return (currentAnswerIndex == correctAnswerIndex);

    }

    // Adds 1 to current score if right answer is selected, and sends score to server.
    // Updates user's score on website
    // TODO: Send score to server
    function checkAndUpdateScore(){

        // We won't bother checking if the quiz hasn't started or has ended
        if(current_question >= 0){
            if(rightAnswer()){
                score++;
                //TODO: play chime
            }
            else{
                //TODO: play annoying honking sound
            }
        }

        $("#score").html(score);
    }

    function Tick(){
        let now = Math.floor(new Date().getTime()/1000);    // seconds since 1970
        let starts_in = quiz.startTime - now;               // seconds until quiz starts. if negative, quiz has started.

        // if quiz has NOT started
        if(starts_in > 0)
            $("#starts_in").html(starts_in);
        else
            $("#starts_in").html("quiz has started!");

        let newActiveQuestion = getActiveQuestion();

        // If quiz hasn't started yet, we don't need to do anything else in this tick.
        if(newActiveQuestion < 0)
            return;

        updateTitle();

        if(newActiveQuestion != current_question){  // We are jumping to next question

            checkAndUpdateScore();

            current_question = newActiveQuestion;

            if(newActiveQuestion == -2){    // quiz is over!!!!
                $(".question").addClass("inactive_question").removeClass("active_question");
                alert("thanks for playing");
                return;
            }

            $(".question:eq("  + current_question + ")").addClass("active_question").removeClass("inactive_question");
            $(".question").not(':eq(' + current_question + ')').addClass("inactive_question").removeClass("active_question");
        }
    }

    $(document).ready(function(){
        let uuid = "<%= request.getParameter("uuid") %>";
        let url = "rest/quizes/quiz/" + uuid;
        $.getJSON(url, null, function(data){
            quiz = data;

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
        BLAH BLAH BLAH QUESTIONSBLAH BLAH BLAH QUESTIONSBLAH BLAH BLAH QUESTIONSBLAH BLAH BLAH QUESTIONSBLAH BLAH BLAH QUESTIONSBLAH BLAH BLAH QUESTIONSBLAH BLAH BLAH QUESTIONS
    </div>
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



</div>
</body>
</html>