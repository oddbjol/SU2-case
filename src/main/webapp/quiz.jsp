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
            background-color: green !important;
        }
        .inactive_question{
            //display: none;
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

    var quiz;
    var current_question = -1; // current question is "quiz not started"
    var score = 0;

    // -1 if quiz hasn't started, -2 if it's over, otherwise index of right question.
    function getActiveQuestion(){
        var now = Math.floor(new Date().getTime()/1000); //seconds since 1970
        var time_spent = now - quiz.startTime;

        if(time_spent < 0){ // Still waiting for quiz to start...
            return -1;
        }
        else if(time_spent >= quiz.duration_seconds){    // The quiz is already over!
            return -2;
        }
        // The quiz should be active.
        var time_counter = 0;
        for(var i = 0; i < quiz.questions.length; i++){
            time_counter += quiz.questions[i].duration_seconds;
            if(time_counter > time_spent)   // This means the user is currently answering questions[i]. index = i.
                return i;
        }

        return -2; // Shouldn't happen, but just in case we get here we can conclude that quiz is over

    }

    function updateTitle(){

        if(current_question < 0) // Only check if we're on an active question
            return;

        var pointInTimeNextQuestion = quiz.startTime;
        for(var i = 0; i <= current_question; i++)
            pointInTimeNextQuestion += +quiz.questions[i].duration_seconds;

        var now = Math.floor(new Date().getTime()/1000);
        var timeLeft = pointInTimeNextQuestion - now;

        $(".active_question").first().find(".question_seconds_left").html("(" + timeLeft + " / " + quiz.questions[current_question].duration_seconds + " seconds left)");
    }

    // Check if user chose right answer
    function rightAnswer(){
      if(current_question < 0)
        return false;   // Not a valid question.

    var correctAnswerIndex = quiz.questions[current_question].right_answer;
    var currentAnswerIndex = $(".active_question").first().find(".btn.active").find(".radio").val()


    console.log("you selected " + currentAnswerIndex + " correct is: " + correctAnswerIndex);
    return (currentAnswerIndex == correctAnswerIndex);

    }

    $(document).ready(function(){
        var uuid = "<%= request.getParameter("uuid") %>";
        var url = "rest/quizes/quiz/" + uuid;
        $.getJSON(url, null, function(data){
            quiz = data;

            $("#quiz_name").html(quiz.name);
            $("#quiz_duration").html(quiz.duration_seconds);
            $("#nickname").html("<%= request.getParameter("nickname") %>");

            for( var i = 0; i < quiz.questions.length; i++) {
                var question = quiz.questions[i];

                var question_box = $(".question_template").first().clone(true,true);
                question_box.removeClass("question_template");
                question_box.addClass("question");

                question_box.find(".card-title").html("Question " + (i+1) + " of " + quiz.questions.length);
                question_box.find(".question_text").html(question.question);

                for(var j = 0; j < question.answers.length; j++){
                    var answer = question.answers[j];

                    var answer_box = $(".answer_template").first().clone(true,true);
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

        setInterval(function(){
            var now = Math.floor(new Date().getTime()/1000); // seconds since 1970
            var starts_in = quiz.startTime - now;   // seconds until quiz starts. if negative, quiz has started.
            $("#starts_in").html(starts_in);
            $("#max_score").html(quiz.questions.length);

            updateTitle();

            var newActiveQuestion = getActiveQuestion();
            if(newActiveQuestion != current_question){  // We are jumping to next question

                if(current_question >= 0){ // Don't bother scoring questions that don't exist
                    if(rightAnswer())
                        score++;
                }

                current_question = newActiveQuestion;

                $("#score").html(score);

                if(newActiveQuestion == -2){    // quiz is over!!!!

                    $(".question").addClass("inactive_question").removeClass("active_question");
                    alert("thanks for playing");
                    return;
                }

                $(".question:eq("  + current_question + ")").addClass("active_question").removeClass("inactive_question");
                $(".question").not(':eq(' + current_question + ')').addClass("inactive_question").removeClass("active_question");



    }

            console.log();
        }, 1000);

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
        Quiz will last this long: <div id="quiz_duration"></div> seconds
        Quiz starts in: <div id="starts_in"></div>
        Your name is: <div id="nickname"></div>
        Score: <span id="score"></span> of <span id="max_score"></span>
    </div>



</div>
</body>
</html>