<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <%--<script src="<c:url value="/resources/js/jquery-3.2.1.min.js"/>"></script>--%>
    <%--font--%>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Orbitron">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=VT323">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="<c:url value="/resources/css/style.css"/>"/>

    <title>Tetris</title>



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

    <table class="tetris-table">
        <tbody>
            <c:forEach var = "i" begin = "1" end = "22">
                <tr>
                    <c:forEach var="k" begin="0" end="9">
                        <td class="td${i}${k}"></td>
                    </c:forEach>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div id="key"></div>
</body>
</html>

<script>
    var idx, rotate, block = [];
    var h_loc, v_loc;
    var up, bottom, left, right;

    var obstacle = false;

    var godown, downtime = 500;

    var tdcss;
    var i, k;

    var black = [];
    var full = [];

    var x, y;

    var min = [], max = [];

    var line = 0, cnt = 0;
    var point = ${authInfo.point}, level = ${authInfo.level};
    var newPoint, oldPoint, minPoint;
    var color;

    //블럭 종류별로 생성
    var blocks = [];

    blocks[0] = [
        [10, 11, 12, 13],
        [11, 21, 31, 41],
        [10, 11, 12, 13],
        [12, 22, 32, 42]
    ];
    blocks[1] = [
        [10, 11, 20, 21],
        [10, 11, 20, 21],
        [10, 11, 20, 21],
        [10, 11, 20, 21]
    ];
    blocks[2] = [
        [11, 20, 21, 22],
        [11, 20, 21, 31],
        [10, 11, 12, 21],
        [11, 21, 22, 31]
    ];
    blocks[3] = [
        [11, 12, 20, 21],
        [10, 20, 21, 31],
        [11, 12, 20, 21],
        [11, 21, 22, 32]
    ];
    blocks[4] = [
        [10, 11, 21, 22],
        [11, 20, 21, 30],
        [10, 11, 21, 22],
        [12, 21, 22, 31]
    ];
    blocks[5] = [
        [10, 20, 21, 22],
        [11, 21, 30, 31],
        [10, 11, 12, 22],
        [11, 12, 21, 31]
    ];
    blocks[6] = [
        [12, 20, 21, 22],
        [10, 11, 21, 31],
        [10, 11, 12, 20],
        [11, 21, 31, 32]
    ];

    var qnt = [
        "rgb(0, 221, 179)",
        "rgb(246, 145, 67)",
        "rgb(255, 200, 56)",
        "rgb(250, 87, 123)",
        "rgb(5, 187, 21)",
        "rgb(55, 191, 230)",
        "rgb(123, 227, 93)"
    ];
    //rgb(232, 232, 232)

    //테이블 인식 생성
    for(i = 0; i < 23; i++){
        black.push([]);
        full.push(0);
        for (k = 0; k < 10; k++) {
            black[i].push(null);                            //[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        }
    }
    console.table([black]);
    console.log(JSON.stringify(full));

    //key
    var key = document.getElementById("key");
    var stop = false;
    //입력받는다
    document.addEventListener("keydown", function(event) {
        console.log(event);
        key.innerHTML = event.code;

        switch(event.code) {
            case "ArrowLeft":
                if(stop == false)
                    go_left();
                break;
            case "ArrowRight":
                if(stop == false)
                    go_right();
                break;
            case "Escape":
                if(stop == false) {
                    stop_block();
                } else {
                    block_down(downtime);
                }
                stop = !stop;
                break;
            case "Space":
                if(block == ""){
                    create_block();
                }else if(stop == true){
                    block_down();
                    stop = !stop;
                }else if(stop == false){
                    // 블럭을 맨 밑으로
                    spacebar();
                }
                break;
            case "ArrowDown":
                go_down();
                break;
            case "ArrowUp":
                rotate_left();
                break;

            case "KeyC":
                row_clean();
                break;
        }

    });

    function create_block(){
        h_loc = 3;
        //만약 black 맨 위 3456 쯤 자리가 1이면 게임 끝

        // 0~6 랜덤 숫자 생성 (최대, 최소값 포함: Math.floor(Math.random() * (max - min + 1)) + min;)
        idx = Math.floor(Math.random() * (6 + 1));

        console.log("color: " + color);

        // rotate 상태: 0번째
        rotate = 0;

        //블럭을 생성
        block = blocks[idx][rotate].slice(0);
        //블럭을 중앙에 위치
        for(i = 0; i < block.length; i++){
            block[i] += h_loc;
        }
        for (i = 0; i < block.length; i++) {
            y = Math.floor((block[i] / 10));
            x = block[i] % 10;
            //블럭에 블럭이 이미 있으면
            if (black[y][x] !== null) {
                obstacle = true;
                break;
            } else {
                obstacle = false;
            }
        }
        if(obstacle == false){
            //화면에 블럭 표시
            color_block();
            console.log("idx: " + idx);
            console.log("block : " + JSON.stringify(block));
            console.log("blocks : " + JSON.stringify(blocks));
            block_edge();

            if(line < 4){
                downtime = 1000;
            }else if(line < 8){
                downtime = 700;
            }else if(line < 12){
                downtime = 500;
            }else if(line < 16){
                downtime = 400;
            }else{
                downtime = 300;
            }
            block_down(downtime);

        }else{
           //게임종료

        }



    }

    function block_down(downtime){
        godown = setInterval(go_down, downtime);
    }

    function stop_block(){
        clearInterval(godown);
    }

    function spacebar(){
        stop_block();
        block_down(5);
    }

    function go_down() {
        if (bottom !== 22) {
            //이동하려는 칸이 채워져있는지 확인(block이 1이면 채워져 있는 것)
            for (i = 0; i < block.length; i++) {
                y = Math.floor((block[i] / 10));
                x = block[i] % 10;
                //블럭의 아래
                console.log("y: " + y);
                console.log("x: " + x);
                console.log("black["+(y+1)+"]["+x+"]: " + black[y+1][x]);
                if (black[y+1][x] !== null) {
                    obstacle = true;
                    break;
                } else {
                    obstacle = false;
                }
            }
            if (obstacle === false) {
                clear_block();
                //부품 하나씩 아래로 보내줘야함.
                for (i = 0; i < block.length; i++) {
                    block[i] += 10;
                }
                up++;
                bottom++;
                //화면에 블럭 표시
                color_block();
            } else {
                //현재블럭 정지
                clearInterval(godown);
                //black에 저장
                for (i = 0; i < block.length; i++) {
                    y = Math.floor((block[i] / 10));
                    x = block[i] % 10;
                    black[y][x] = idx;

                }
                console.log(JSON.stringify(black));
                //화면에 블럭 표시
                color_block();
                //줄이 모두 채워졌으면 삭제
                row_clean();
                //새로운 블럭 생성
                create_block();
            }
        }else{
            //현재블럭 정지
            clearInterval(godown);
            //black에 저장
            for (i = 0; i < block.length; i++) {
                y = Math.floor((block[i] / 10));
                x = block[i] % 10;
                black[y][x] = idx;

            }
            console.log(JSON.stringify(black));
            //화면에 블럭 표시
            color_block();
            //줄이 모두 채워졌으면 삭제
            row_clean();
            //새로운 블럭 생성
            create_block();
        }
    }

    function go_left() {
        if (left !== 0) {
            for (i = 0; i < block.length; i++) {
                y = Math.floor((block[i] / 10));
                x = block[i] % 10;
                if (black[y][x - 1] !== null) {
                    obstacle = true;
                    break;
                } else {
                    obstacle = false;
                }
            }
            if (obstacle === false) {
                clear_block();
                //부품 하나씩 왼쪽으로 보내줘야함.
                for (i = 0; i < block.length; i++) {
                    block[i] -= 1;
                }
                left--;
                right--;
                h_loc--;
                //화면에 블럭 표시
                color_block();
            }
        }
    }

    function go_right(){
        if(right !== 9){
            for (i = 0; i < block.length; i++) {
                y = Math.floor((block[i] / 10));
                x = block[i] % 10;
                if (black[y][x+1] !== null) {
                    obstacle = true;
                    break;
                } else {
                    obstacle = false;
                }
            }
            if (obstacle === false) {
                clear_block();
                //부품 하나씩 오른쪽으로 보내줘야함.
                for (i = 0; i < block.length; i++) {
                    block[i]++;
                }
                left++;
                right++;
                h_loc++;
                //화면에 블럭 표시
                color_block();
            }
        }
    }

    //rotate를 기준으로 생성되고 rotate 됐을 때
    function block_edge(){

        y = [];
        x = [];
        for(i = 0; i < block.length; i++){
            y.push(Math.floor((block[i]/10)));
            x.push(block[i] % 10);
        }

        up = Math.min.apply(null, y);
        bottom = Math.max.apply(null, y);
        left = Math.min.apply(null, x);
        right = Math.max.apply(null, x);

        console.log("top: " + up);
        console.log("bottom: " + bottom);
        console.log("left: " + left);
        console.log("right: " + right);
    }

    function rotate_left() {
        v_loc = up - 1;
        //현상태 파악 및 회전할 블럭 선택
        if (rotate !== 3) {
            rotate++;
        } else if (rotate = 3) {
            rotate = 0;
        }
        //현재 블럭 해제
        clear_block();
        //회전
        block = blocks[idx][rotate].slice(0);

        console.log("block: " + block);
        //위치조정
        //x위치 조정
        x = []; y = [];
        for(i = 0; i < block.length; i++) {
            y.push(Math.floor((block[i] / 10)) + v_loc);
            x.push(block[i] % 10 + h_loc);
        }
        console.log("x : " + x);
        min = Math.max.apply(null, y);
        max = Math.max.apply(null, x);
        console.log("max : " + max);
        //오른쪽으로 9보다 넘어갔을 때
        console.log("black["+up+"]["+max+"] : " + black[up][max]);
        console.log("black["+up+"]["+max+"] === 1: " + Boolean(black[up][max] !== null));
        if (max > 9) {
            h_loc -= max - 9;
        //오른쪽에 블럭이 있을 때
        }
        if(min > 22){
            v_loc -= min - 22;
        }
        for (i = 0; i < block.length; i++) {
            block[i] += h_loc + v_loc * 10;
        }
        block_edge();
        // 오른쪽 혹은 아래에 블럭이 있을 때
        console.log("block: " + block);

        //블럭 표시
        color_block();
    }

    function clear_block(){
        for(i = 0; i < block.length; i++){
            tdcss = "td.td" + block[i];
            $(tdcss).css("background-color", "rgb(240, 240, 240)");
        }
    }

    function row_clean(){
        //삭제할 행들을 찾아낸다
        for(y = 0; y < 23; y++) {
            for (x = 0; x < 10; x++) {
                if (black[y][x] === null) {
                    full[y] = 0;
                    break;
                }else{
                    full[y] = 1;
                }
            }
        }
        console.log("full: " + full);
        for(y = 22; y > 0; y--) {
            if(full[y] === 1){
                for(x = 0; x < 10; x++){
                    tdcss = "td.td" + y + x;
                    $(tdcss).css("background-color", "rgb(240, 240, 240)");
                }
            }
        }

        setTimeout(function(){

            for(y = 22; y > 0; y--) {
                if(full[y] === 1){
                    for(x = 0; x < 10; x++){
                        tdcss = "td.td" + y + x;
                        color = qnt[black[y][x]];
                        $(tdcss).css("background-color", color);
                    }
                }
            }

        }, 100);

        setTimeout(function(){
            console.log("full: " + full);
            for(y = 22; y > 0; y--) {
                if(full[y] === 1) {
                    for (x = 0; x < 10; x++) {
                        tdcss = "td.td" + y + x;
                        $(tdcss).css("background-color", "rgb(240, 240, 240)");
                    }
                }
            }

        }, 200);

        setTimeout(function(){

            console.log("cnt: "+cnt);
            for(i = 22; i >= 0; i--) {
                console.log(full[i]);
                if(full[i] === 1){
                    cnt++;
                    line++;
                    full[i] = 0;
                }else if(cnt !== 0){
                    //없어진 줄만큼 밑으로
                    for(y = i; y >= 0; y--){
                        for(x = 0; x < 10; x++){
                            black[y+cnt][x] = black[y][x];
                            tdcss = "td.td" + (y+cnt) + x;
                            if(black[y+cnt][x] === null) {
                                color = "rgb(240, 240, 240)";
                            }else{
                                color = qnt[black[y+cnt][x]];
                            }
                            $(tdcss).css("background-color", color);
                        }
                    }
                    point_line();
                    i += cnt;
                    cnt = 0;
                }
            }

        }, 300);

    }

    function color_block() {
        color = qnt[idx];
        for (i = 0; i < block.length; i++) {
            tdcss = "td.td" + block[i];
            $(tdcss).css("background-color", color);
        }
    }


    function point_line(){
        var header = document.getElementById("header");
        var min = document.getElementById("min");
        var pro = document.getElementById("pro");
        var lvl = document.getElementById("lvl");

        //연습모드
        //없앤 line을 센다
        //line * 10만큼 점수가 오른다.
        //100을 넘어가면 레벨이 오른다.

        //대결모드
        //이겼는지 졌는지 확인
        //이겼으면 없앤 줄만큼 점수가 오른다.
        //졌으면 이긴 사람이 얻은 점수만큼 줄어든다.

            //최종 점수를 계산한다.
            newPoint = cnt * 10 + point;
            oldPoint = point;

            $(min).css("transition", "width .6s ease");
            $(pro).css("transition", "width .6s ease");

            $(min).css("background-color", "rgb(123, 227, 93)");

            //점수가 100 이상이면 레벨 업
            if(newPoint >= 100) {
                newPoint -= 100;
                minPoint = 100 - oldPoint;
                level++;
                //min: 추가된 점수만큼 생성
                $(min).css("width", minPoint + "%");
                //pro: 100%
                //min: 0
                setTimeout(function(){
                    $(min).css("width", "0");
                    $(pro).css("width", "100%");
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
                    $(pro).css("transition", "width .6s ease");
                    $(pro).css("width", newPoint + "%");
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
                $(min).css("width", minPoint + "%");
                setTimeout(function(){
                    $(min).css("width", "0");
                    $(pro).css("width", newPoint + "%");
                },600);

            }
            point = newPoint;
            //db와 session에 점수를 저장한다.
            var pntLvl = {};
            pntLvl["newPoint"] = newPoint;
            pntLvl["newLevel"] = level;

            $.ajax({
                type : "POST",
                contentType : "application/json",
                url : "/tetris",
                data : JSON.stringify(pntLvl),
                dataType : 'json'
            });

        }
</script>
