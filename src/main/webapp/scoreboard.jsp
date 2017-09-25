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
    <style>
        .row_winner{
            background-color: green;
        }
        .row_winner:hover{
            background-color: darkgreen !important;
        }
    </style>
    <script>
    "use strict";

        let scoreboard;

    $(document).ready(function(){
        let uuid = "<%= request.getParameter("uuid") %>";
        let url = "rest/quizes/quiz/" + uuid;


        console.log(url);

        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                let maxKey = null;

                // Which person got the highest score again?
                for(let key in data.scoreboard){
                    if(!maxKey || data.scoreboard[key] > data.scoreboard[maxKey]){
                        maxKey = key;
                    }
                }

                $(".quiz-name").html(data.name);
                $("#info").html("The quiz is over. " + maxKey + " won!!!");

                // Print the highscore table.
                for(let key in data.scoreboard){
                    let style = "";
                    if(key == maxKey)
                        style = ' class="row_winner"';

                    $("#tbody").append("<tr" + style + "><td>"+ key +"</td><td>"+ data.scoreboard[key] +"</td></tr>");
                }

            }
        });

    });

    </script>
</head>
<body>

<div class="container" >
    <div id="frontpage">
        <div class="card card-body bg-light">
            <h1 class="card-title quiz-name"></h1>
            <span id="info"></span>
        </div>
        <table class="table table-responsive table-hover" id="tbl">
            <thead>
                <th>Nickname</th>
                <th>Points</th>
            </thead>
            <tbody id="tbody">

            </tbody>
        </table>
        <a href="index.html" class="btn btn-primary">Back</a>
    </div>
</div>
</body>
</html>