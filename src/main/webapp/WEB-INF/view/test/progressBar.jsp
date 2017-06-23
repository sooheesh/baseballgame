<%--
  Created by IntelliJ IDEA.
  User: student
  Date: 2017-06-20
  Time: 오후 5:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Progress Bar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script>
        var value = 0;
        // 오래 걸리는 작업을 만들기 애매하기 때문에
        // 타이머로 만들어본다.
        function start(){
            setTimeout(pro1, 500);
        }
        function pro1(){
            value = value + 10;
            if(value > 100){
                value = 100;
            }
            $("#msg").text("다운중 : " + value + "%");
            $("#pro").css("width", value + "%");
            $("#pro").text(value + "%");
            // value 값이 100보다 작으면..
            if(value < 100){
                setTimeout(pro1, 500);
            } else {
                setTimeout(pro2, 500);
            }
        }
        function pro2(){
            // 빗살 무늬를 표시한다.
            $("#pro").addClass("progress-bar-striped");
            // 움직이게 한다.
            $("#pro").addClass("active");
            $("#msg").text("설지중....");

            setTimeout(pro3, 2000);
        }
        function pro3(){
            // 빗살 부분을 멈추게 한다.
            $("#pro").removeClass("active");
            $("#msg").text("작업 완료");
        }
    </script>
</head>
<body>
<div class="container">
    <div class="progress">
        <!-- aria-valuenow : 현재값 -->
        <!-- aria-valuemin : 최소값 -->
        <!-- aria-valuemax : 최대값 -->
        <div class="progress-bar" role="progressbar"
             aria-valuenow="70" aria-valuemin="0"
             aria-valuemax="100" style="width:70%">
            70%
        </div>
    </div>
    <div style="margin-top:20px"></div>
    <div class="progress">
        <!-- 색상 : progress-bar-success -->
        <!-- progress-bar-info, progress-bar-warning -->
        <!-- progress-bar-danger -->
        <div class="progress-bar progress-bar-success" role="progressbar"
             aria-valuenow="70" aria-valuemin="0"
             aria-valuemax="100" style="width:70%">
            70%(success)
        </div>
    </div>
    <div style="margin-top:20px"></div>
    <div class="progress">
        <!-- 빗살 무늬 표시 : progress-bar-striped -->
        <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar"
             aria-valuenow="70" aria-valuemin="0"
             aria-valuemax="100" style="width:70%">
            70%(success)
        </div>
    </div>
    <div style="margin-top:20px"></div>
    <div class="progress">
        <!-- 빗살 무늬 움직이기 : active -->
        <div class="progress-bar progress-bar-success progress-bar-striped active" role="progressbar"
             aria-valuenow="70" aria-valuemin="0"
             aria-valuemax="100" style="width:70%">
            70%(success)
        </div>
    </div>
    <!-- ProgressBar 예제 -->
    <div style="margin-top:20px"></div>
    <div class="progress">
        <div class="progress-bar" style="width:0%" id="pro">

        </div>
    </div>
    <div id="msg"></div>
    <button type="button" onclick="start()" class="btn btn-primary">
        ProgressBat 시작
    </button>
</div>
</body>
</html>









