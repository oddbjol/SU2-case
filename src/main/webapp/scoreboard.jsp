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
        tr{
            cursor: pointer;
        }
        .template_row{
            display: none;
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
                for(let key in data.scoreboard)
                    $("#tbody").append("<tr><td>"+ key +"</td><td>"+ data.scoreboard[key] +"</td></tr>");
            }
        });

    });

    </script>
</head>
<body>

<tr class="template_row" id="template_row">
    <td class="nick"></td>
    <td class="points"></td>
</tr>

<div class="container" >
    <div id="frontpage">
        <table class="table table-responsive table-hover" id="tbl">
            <thead>
                <th>Nickname</th>
                <th>Points</th>
            </thead>
            <tbody id="tbody">

            </tbody>
        </table>
    </div>
</div>
</body>
</html>