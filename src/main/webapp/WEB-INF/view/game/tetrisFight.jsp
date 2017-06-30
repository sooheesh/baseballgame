<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page session="true"%>
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

<!-- 로그인한 상태일 경우와 비로그인 상태일 경우의 chat_id설정 -->
<c:if test="${(authInfo.name ne '') and !(empty authInfo.name)}">
    <input type="hidden" value='${authInfo.name}' id='chat_id' />
</c:if>
<c:if test="${(authInfo.name eq '') or (empty authInfo.name)}">
    <input type="hidden" value='익명<%=session.getId().substring(0,4)%>' id='chat_id' />
</c:if>


<div class="tetris-fight-tables">
    <table class="tetris-table2">
        <tbody>
        <c:forEach var = "i" begin = "1" end = "22">
            <tr>
                <c:forEach var="k" begin="0" end="9">
                    <td class="2td${i}${k}"></td>
                </c:forEach>
            </tr>
        </c:forEach>
        </tbody>
    </table>

<div style="width:100px;display:inline-table"></div>

    <table class="tetris-table1">
        <tbody>
        <c:forEach var = "i" begin = "1" end = "22">
            <tr>
                <c:forEach var="k" begin="0" end="9">
                    <td class="1td${i}${k}"></td>
                </c:forEach>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<div id="key"></div>
</body>
</html>



<a class="chat">[Waiting For Other Player...]</a>

<!--     채팅창 -->
<div id="_chatbox" style="display: none">
    <fieldset>
        <div id="messageWindow"></div>
        <br /> <input id="inputMessage" type="text" onkeyup="enterkey()" />
        <input type="submit" value="send" onclick="send()" />
    </fieldset>
</div>

</body>

<script type="text/javascript">

    var textarea = document.getElementById("messageWindow");
    var webSocket = new WebSocket('ws://sooheesong.com:8080/game/chat');
    var inputMessage = document.getElementById('inputMessage');
    webSocket.onerror = function(event) {
        onError(event)
    };
    webSocket.onopen = function(event) {
        onOpen(event)
    };
    webSocket.onmessage = function(event) {
        onMessage(event)
    };
    function onMessage(event) {
        var message = event.data.split("|");
        var sender = message[0];
        var content = message[1];
        if (content == "") {

        } else {
            if (content.match("/")) {
                if (content.match(("/" + $("#chat_id").val()))) {
                    var temp = content.replace("/" + $("#chat_id").val(), "(귓속말) :").split(":");
                    if (temp[1].trim() == "") {
                    } else {
                        $("#messageWindow").html($("#messageWindow").html() + "<p class='whisper'>"
                            + sender + content.replace("/" + $("#chat_id").val(), "(귓속말) :") + "</p>");
                    }
                } else {
                }
            } else {
                if (content.match("!")) {
                    $("#messageWindow").html($("#messageWindow").html()
                        + "<p class='chat_content'><b class='impress'>" + sender + " : " + content + "</b></p>");
                } else {
                    $("#messageWindow").html($("#messageWindow").html()
                        + "<p class='chat_content'>" + sender + " : " + content + "</p>");
                }
            }
        }
    }
    function onOpen(event) {
        $("#messageWindow").html("<p class='chat_content'>채팅에 참여하였습니다.</p>");
    }
    function onError(event) {
        alert(event.data);
    }
    function send() {
        if (inputMessage.value == "") {
        } else {
            $("#messageWindow").html($("#messageWindow").html()
                + "<p class='chat_content'>" + $("#chat_id").val() + "(나): " + inputMessage.value + "</p>");
        }
        webSocket.send($("#chat_id").val() + "|" + inputMessage.value);
        inputMessage.value = "";
    }
    //     엔터키를 통해 send함
    function enterkey() {
        if (window.event.keyCode == 13) {
            send();
        }
    }
    //     채팅이 많아져 스크롤바가 넘어가더라도 자동적으로 스크롤바가 내려가게함
    window.setInterval(function() {
        var elem = document.getElementById('messageWindow');
        elem.scrollTop = elem.scrollHeight;
    }, 0);
</script>
</html>
