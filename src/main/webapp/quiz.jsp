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

    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="http://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script>

    var quiz;

    $(document).ready(function(){
        var uuid = "<%= request.getParameter("uuid") %>";
        var url = "rest/quizes/quiz/" + uuid;
        $.getJSON(url, null, function(data){
            quiz = data;

            $("#quiz_name").html(quiz.name);
            $("#quiz_duration").html(quiz.duration_seconds);
            $("#nickname").html("<%= request.getParameter("nickname") %>");

            var duration_seconds = data.duration_seconds;
            console.log(quiz_name + " " + duration_seconds);
        });

        setInterval(function(){
            var now = Math.floor(new Date().getTime()/1000); // seconds since 1970
            var starts_in = quiz.startTime - now;   // seconds until quiz starts. if negative, quiz has started.
            $("#starts_in").html(starts_in);
        }, 1000);

    });


    </script>
</head>
<body>

<div class="container" >
    <div id="frontpage card card-body bg-light">
        <h1 class="card-title" id="quiz_name"></h1>
        Quiz will last this long: <div id="quiz_duration"></div> seconds
        Quiz starts in: <div id="starts_in"></div>
        Your name is: <div id="nickname"></div>
    </div>

</div>
</body>
</html>