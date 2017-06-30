<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <%--font--%>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Orbitron">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=VT323">


    <script src="../../resources/js/jquery-3.2.1.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <title>Baseball Game</title>

    <style>

        .btn.id, .btn.lvl {
            padding: 6px 0px;
        }

        button#replay.focus, button#replay:focus {
            color: #333;
            background-color: white;
            border-color: #8c8c8c;
        }

        .board {
            background: rgba(255,255,255, 0.7);
            border-radius: 35px;
            padding: 15px 15px 28px 15px;
            position: relative;
            z-index: 9999;
            text-align: center;
        }

        .title {
            height: 233px;
            margin-top: 89px;
            z-index: 9999;
            position: relative;
            text-align: center;
            font-family: 'Orbitron', sans-serif;
        }

        .title h1 {
            padding-top: 109px
        }

        .number {
            margin: auto;
            display: inline-flex;
        }

        div#msg, div#msg2 {
            margin-top: 18px;
            text-align: center;
            font-family: 'VT323', monospace;
            font-size: 20px;
        }

        input {
            width: 50px;
            height: 50px;
            padding: 5px;
            text-align: center;
            font-size: 40px;
            margin-right: 20px;
        }

        input#num3 {
            margin-right: 0px;
        }
        /*숫자 입력칸의 화살표를 삭제*/
        input::-webkit-outer-spin-button, input::-webkit-inner-spin-button {
            -webkit-appearance: none !important;
            margin: 0;
        }

        div#ans1, div#ans2, div#ans3 {
            width: 52px;
            height: 52px;
            padding: 5px;
            text-align: center;
            font-size: 41px;
            margin-right: 20px;
            font-family: Arial;

        }

        div#ans3 {
            margin-right: 0px;
        }

        .progress {
            width: 150px;
            margin-bottom: 0px;
        }

        .progress-bar {
            background-color: dodgerblue;
        }

        .id {
            height: 42px;
        }

        .btn-link {
            color: black;
        }

        .dropdown, .lvl, .exp {
            display: inline-block;
            margin-right: 10px;
        }

        .lvl {
            font-family: 'VT323', monospace;
            font-size: 20px;
        }

        table#header {
            margin-right: 0px;
            margin-left: auto;
        }

        div#min {
            /*top: -20px;*/
            position: relative;
            background-color: red;
            width: 0;
        }

        a#lvl, a#lvl:hover {
            color: black;
        }

        /*반응형에 맞게 마진 조절*/
        @media all and (max-width:670px){
            .title {
                margin-top: 0px;
            }
        }
    </style>

    <script>

        var rnd_val = [];   //랜덤 숫자 3개를 담을 배열
        var value;          //3자리 랜덤 숫자

        var point = ${authInfo.point};
        var minus = 0;

        var minPoint;
        var newPoint;
        var oldPoint;

        var level = ${authInfo.level};

        window.onload = function(){
//            var pro = document.getElementById("pro");
            //progress bar 퍼센테이지 표시
//            $(pro).text(point + "%");
            //초기화
            rnd_val = [];
            //페이지가 로드되면 입력이 활성화된다.
            var num1 = document.getElementById("num1");
            num1.focus();

            var idx;
            var rnd;
            //서로 다른 랜덤 숫자 3개를 추출한다.
            for(var i=0; i<3; i++){
                do{
                    rnd = Math.floor(Math.random() * (9-1+1) + 1);
                    idx = rnd_val.indexOf(rnd); 	// rnd_val 안에 중복되는 값이 있는지 확인
                }while(idx != -1); 					// 중복되는 값이 있으면 재수행
                rnd_val.push(rnd); 				// 중복되는 값이 없으면 rnd_val에 추가
            }
            //3자리 숫자를 브라우저의 콘솔에 출력해준다.
            value = parseInt("" + rnd_val[0] + rnd_val[1] + rnd_val[2]);
            console.log(value);
        };
        //사용자가 입력한 값 3개를 비교한다.
        function set_number(){
            var num1 = document.getElementById("num1");
            var num2 = document.getElementById("num2");
            var num3 = document.getElementById("num3");
            var msg = document.getElementById("msg");
            var board = document.getElementById("board");
            var result = document.getElementById("result");
            var ans1 = document.getElementById("ans1");
            var ans2 = document.getElementById("ans2");
            var ans3 = document.getElementById("ans3");
            var msg2 = document.getElementById("msg2");
            var replay = document.getElementById("replay");
            var header = document.getElementById("header");
            var min = document.getElementById("min");
            var pro = document.getElementById("pro");
            var lvl = document.getElementById("lvl");

            var usr_num = []; //사용자가 입력한 숫자 3개를 담을 배열
            var number; //3자리 사용자가 입력한 숫자

            //3개 숫자를 히스토리에 출력한다.
            number = parseInt("" + num1.value + num2.value + num3.value);
            msg.innerHTML += number + " : ";
            //사용자 숫자를 배열에 넣어준다.
            usr_num.push(parseInt(num1.value));
            usr_num.push(parseInt(num2.value));
            usr_num.push(parseInt(num3.value));
            //Strike와 Ball 초기화
            var strk = 0;
            var bll = 0;
            //Strike Ball 여부 확인
            for(var i=0; i<3; i++){
                for(var k=0; k<3; k++){
                    if(usr_num[i] == rnd_val[k]){
                        if(i == k){
                            strk++;
                        }else {
                            bll++;
                        }
                    }
                }
            }
            //Out 계산
            var out = 3 - (strk + bll);
            //줄어든 점수 계산
            minus = bll*(-1) + out*(-2);
            //현재 점수 계산
            point += parseInt(minus);
            //Strike, Ball, Out의 개수를 log에 출력한다.
            msg.innerHTML += strk + " Strike " + bll + " Ball " + (3 - (strk+bll)) + " Out, ";
            //숫자가 불일치할 경우 게임은 계속된다.
            if(number !== value) {

                $(min).css("background-color", "red");
                $(min).css("transition", "width .3s ease");
                $(pro).css("transition", "width .3s ease");

                //점수가 음수일 경우
                if (point < 0) {
                    //이전 점수 계산
                    oldPoint = point - minus;
                    //레벨 down 후 줄어든 점수 계산
                    minPoint = point * (-1);
                    //point 새로 계산
                    point += 100;
                    // 레벨 down
                    level--;

                    //pro: 0으로 줄어든다.
                    //min: 줄어든 만큼 표시
                    $(min).css("width", oldPoint + "%");
//                    $(min).text("-" + oldPoint);
                    $(pro).css("width", "0");
                    //min : 0으로 줄어든다.
                    setTimeout(function () {
                        $(min).css("width", "0");
                    }, 200);
                    //pro: 100% 상태
                    //min: X
                    setTimeout(function () {
//                        $(pro).text("100%");
                        $(pro).css("transition", "none");
                        $(pro).css("width", "100%");
                    }, 400);
                    //pro: point 만큼 줄어든다.
                    //min: 줄어든 만큼 표시
                    setTimeout(function () {
//                        $(pro).text(point + "%");
                        $(pro).css("transition", "width .3s ease");
                        $(pro).css("width", point + "%");
//                        $(min).text("-" + minPoint);
                        $(min).css("width", minPoint + "%");
                    }, 500);
                    //min: 0으로 줄어든다.
                    setTimeout(function(){
                        $(min).css("width", "0");

                        // header에 레벨 반영
                        $(lvl).css("color", "red");
                        lvl.innerHTML = "Lv. " + level;
                        $(lvl).fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
                        setTimeout(function(){
                            $(lvl).css("color", "black");
                        }, 800);

                    }, 700);
                //점수가 양수일 경우
                } else {
                    //pro: point만큼 줄어든다.
                    //min: 줄어든만큼 bar 생성
//                    $(pro).text(point + "%");
                    $(pro).css("width", point + "%");
//                    $(min).text(minus);
                    $(min).css("width", minus * (-1) + "%");
                    //min: 0으로 줄어든다.
                    setTimeout(function () {
                        $(min).css("width", "0");
                        $(min).text("");
                    }, 200);
                }
                //입력된 숫자가 작은지 큰지 비교해서 알려준다.
                if(number < value){
                    msg.innerHTML += "too small<br/>";
                } else if(number > value){
                    msg.innerHTML += "too big<br/>";
                }

            //숫자가 일치할 경우 게임이 끝난다.
            }else{
                //게임 종료 창을 보여준다.
                board.style.display = 'none';
                result.style.display = 'block';
                //정답을 표시한다.
                ans1.innerHTML = rnd_val[0];
                ans2.innerHTML = rnd_val[1];
                ans3.innerHTML = rnd_val[2];
                //다시하기에 포커스를 맞춰준다.
                replay.focus();
                //최종 점수를 계산한다.
                newPoint = Math.round(parseFloat(parseInt(point) * 1.6));
                oldPoint = point;

                $(min).css("transition", "width .6s ease");
                $(pro).css("transition", "width .6s ease");

                $(min).css("background-color", "chartreuse");
//                $(min).css("color", "black");

                //점수가 100 이상이면 레벨 업
                if(newPoint >= 100) {
                    newPoint -= 100;
                    minPoint = 100 - oldPoint;
                    level++;

                    msg2.innerHTML = "3 Strikes! <br>" + "Level up to " + level + "! ";
                    //min: 추가된 점수만큼 생성
                    $(min).css("width", minPoint + "%");
//                    $(min).text("+" + minPoint);
                    //pro: 100%
                    //min: 0
                    setTimeout(function(){
                        $(min).css("width", "0");
//                        $(min).text("");
                        $(pro).css("width", "100%");
//                        $(pro).text("100%");
                    }, 600);
                    //pro: 0
                    setTimeout(function () {
                        $(pro).css("transition", "none");
                        $(pro).css("width", "0");
                    }, 700);
                    //min: 점수만큼 생성
                    setTimeout(function () {
                        $(min).css("width", newPoint + "%");
//                        $(min).text("+" + newPoint);
                    }, 800);
                    //pro: 점수만큼 생성
                    //min: 0
                    setTimeout(function () {
                        $(min).css("width", "0");
//                        $(min).text("");
                        $(pro).css("transition", "width .6s ease");
                        $(pro).css("width", newPoint + "%");
//                        $(pro).text(newPoint + "%");

                        $(lvl).css("color", "blue");
                        lvl.innerHTML = "Lv. " + level;
                        $(lvl).fadeOut(200).fadeIn(200).fadeOut(200).fadeIn(200);
                        setTimeout(function(){
                            $(lvl).css("color", "black");
                        }, 1600);
                    }, 1400);


                //레벨에 변동이 없으면
                }else{
                    minPoint = newPoint - oldPoint;
                    msg2.innerHTML = "3 Strikes!";

//                    $(min).text("+" + minPoint);
                    $(min).css("width", minPoint + "%");

                    setTimeout(function(){
                        $(min).css("width", "0");
//                        $(min).text("");
                        $(pro).css("width", newPoint + "%");
//                        $(pro).text(newPoint + "%");
                    },600);

                }
                //db와 session에 점수를 저장한다.
                var pntLvl = {};
                pntLvl["newPoint"] = newPoint;
                pntLvl["newLevel"] = level;

                $.ajax({
                    type : "POST",
                    contentType : "application/json",
                    url : "/baseball",
                    data : JSON.stringify(pntLvl),
                    dataType : 'json'
                });

            }
            //입력창 clear
            num1.value = "";
            num2.value = "";
            num3.value = "";
        }

        function replay(){
            var num1 = document.getElementById("num1");
//            location.reload();

            //log 초기화
            msg.innerHTML = "";
            //point 재설정
            point = newPoint;
            //게임창으로 전환
            board.style.display = 'block';
            result.style.display = 'none';
            //입력창 포커스
            num1.focus();

            //console 초기화
            console.clear();

            //랜덤 숫자 재생성
            set_rnd();


        }

        function set_rnd(){

            rnd_val = [];

            var idx;
            var rnd;
            //서로 다른 랜덤 숫자 3개를 추출한다.
            for(var i=0; i<3; i++){
                do{
                    rnd = Math.floor(Math.random() * (9-1+1) + 1);
                    idx = rnd_val.indexOf(rnd); 	// rnd_val 안에 중복되는 값이 있는지 확인
                }while(idx != -1); 					// 중복되는 값이 있으면 재수행
                rnd_val.push(rnd); 				// 중복되는 값이 없으면 rnd_val에 추가
            }
            //3자리 숫자를 브라우저의 콘솔에 출력해준다.
            value = parseInt("" + rnd_val[0] + rnd_val[1] + rnd_val[2]);
            console.log(value);

        }

    </script>

</head>
<body>

<div class="body"></div>
    <%--헤더--%>
    <table id="header">

        <%--로그인 이름--%>
        <td class="dropdown">
            <button class="id btn btn-link dropdown-toggle" type="button" data-toggle="dropdown">
                ${authInfo.name}
            </button>
            <ul class="dropdown-menu">
                <li><a href="<c:url value="/edit/changePassword" />">[비밀번호 변경]</a></li>
                <li><a href="<c:url value="/logout" />">[로그아웃]</a></li>
            </ul>
        </td>
        <%--끝 - 로그인 이름--%>

        <%--레벨정보--%>
        <td>
            <button class="lvl btn btn-link" type="button">
                <a id="lvl" href="<c:url value="/rank" />">Lv. ${authInfo.level}</a>
            </button>
        </td>
        <%--끝 - 레벨정보--%>

        <%--경험치 정보--%>
        <td class="exp">
            <div class="progress">
                <div id="pro" class="progress-bar" style="width:${authInfo.point}%"></div>
                <div id="min" class="progress-bar"></div>
            </div>
        </td>
        <%--끝 - 경험치 정보--%>

    </table>
    <%--끝 - 헤더--%>

    <!-- 제목 -->
    <div class="title">
        <h1>Baseball Number Game</h1>
    </div>
    <!-- 끝 - 제목 -->

    <!-- 내용(숫자 입력칸, 결과) -->
    <div class="board" id="board">

        <!-- 숫자 입력 -->
        <div class="number">

            <!-- 첫번째 숫자 -->
            <input type="number" id="num1"
                   onkeyup="document.getElementById('num2').focus();">
            <!-- 키가 눌리면 다음 입력창이 활성화된다. -->

            <!-- 두번째 숫자 -->
            <input type="number" id="num2"
                   onkeyup="document.getElementById('num3').focus();"/>
            <!-- 키가 눌리면 다음 입력창이 활성화된다. -->

            <!-- 세번째 숫자 -->
            <input type="number" id="num3"
                   onkeyup="document.getElementById('num1').focus();setTimeout(set_number,100);">
            <!-- 키가 눌리면 다음 입력창이 활성화된다. && 함수를 호출한다. -->

        </div>
        <!-- 끝 - 숫자 입력 -->

        <!-- 결과 출력 -->
        <div id="msg"></div>
        <!-- 끝 - 결과 출력 -->

    </div>
    <!-- 끝 - 내용 -->

    <%--게임종료--%>
    <div class="board" id="result" style="display:none">

        <%--정답--%>
        <div class="number">
            <div id="ans1"></div>
            <div id="ans2"></div>
            <div id="ans3"></div>
        </div>
        <%--끝 - 정답--%>

        <%--메시지--%>
        <div id="msg2"></div><br>
        <%--끝 - 메시지--%>

        <%--다시하기 버튼--%>
        <button id="replay" onclick="replay()" class="btn btn-default">replay</button>
        <%--끝 - 다시하기 버튼--%>

    </div>
    <%--끝 - 게임종료--%>

</body>
</html>
