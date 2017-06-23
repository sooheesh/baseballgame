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

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Orbitron">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=VT323">

    <script
            src="https://code.jquery.com/jquery-3.2.1.min.js"
            integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
            crossorigin="anonymous"></script>

    <title>Main</title>
</head>

<body>
<c:if test="${empty authInfo}">
    <p>환영합니다.</p>
    <p>
        <a href="<c:url value="/register/step1" />">[회원 가입하기]</a>
    	<a href="<c:url value="/login" />">[로그인]</a>
    </p>
</c:if>
    
<c:if test="${! empty authInfo}">
    <p>${authInfo.name}님, 환영합니다.</p>
    <p>
        <a href="<c:url value="/baseball"/>">[Baseball Game]</a>
    	<a href="<c:url value="/edit/changePassword" />">[비밀번호 변경]</a>
    	<a href="<c:url value="/logout" />">[로그아웃]</a>
    </p>

</c:if>



<%--<a href="<c:url value="/test" />">test로 이동</a>--%>

<!-- 로그인한 상태일 경우와 비로그인 상태일 경우의 chat_id설정 -->
<c:if test="${(authInfo.name ne '') and !(empty authInfo.name)}">
    <input type="hidden" value='${authInfo.name}' id='chat_id' />
</c:if>
<c:if test="${(authInfo.name eq '') or (empty authInfo.name)}">
    <input type="hidden" value='익명<%=session.getId().substring(0,4)%>' id='chat_id' />
</c:if>
<!--     채팅창 -->
<div id="_chatbox" style="display: none">
    <fieldset>
        <div id="messageWindow"></div>
        <br /> <input id="inputMessage" type="text" onkeyup="enterkey()" />
        <input type="submit" value="send" onclick="send()" />
    </fieldset>
</div>

<a class="chat">[Chat]</a>

</body>
<!-- 말풍선아이콘 클릭시 채팅창 열고 닫기 -->
<script>

    $(".chat").on({
        "click" : function() {
            if ($(this).css("display", "block")) {
                $(this).css("display", "none");
                $("#_chatbox").css("display", "block");
            } else if ($(this).css("display", "none")) {
                $(this).css("display", "block");
                $("#_chatbox").css("display", "none");
            }
        }
    });
</script>

<script type="text/javascript">

    var textarea = document.getElementById("messageWindow");
    var webSocket = new WebSocket('ws://70.12.110.160:8080/chat');
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


</body>
</html>