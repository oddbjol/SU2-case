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
    <script src="js/quiz.js"></script>
</head>
<body>

<div class="container" >
    <div id="frontpage">
    <script>
        var uuid = "<%= request.getParameter("uuid") %>";
        var url = "http://localhost:8080/case/rest/quizes/quiz/" + uuid;
        var quiz = $.getJSON(url, null, function(data){
            console.log(data);
        });

    </script>

    </div>
</div>
</body>
</html>