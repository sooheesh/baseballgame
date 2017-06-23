<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<html>
<head>
    <title>랭킹</title>

    <style>
        .rank-table {
            border-collapse: collapse;
        }

        .top-rank {
            border: 1px solid black;
        }

        .my-rank {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <table class="rank-table">
        <thead>
            <tr>
                <th>순위</th><th>이름</th><th>레벨</th>
            </tr>
        </thead>

        <tbody class="top-rank">
        <c:forEach var="mem" items="${rankMembers}" varStatus="status">
                <c:if test="${status.index < 3}">
                    <c:if test="${authInfo.name == mem.name}">
                        <tr class="my-rank">
                            <td>${mem.rank}</td>
                            <td>${mem.name}</td>
                            <td>${mem.level}</td>
                        </tr>
                    </c:if>
                    <c:if test="${authInfo.name != mem.name}">
                        <tr>
                            <td>${mem.rank}</td>
                            <td>${mem.name}</td>
                            <td>${mem.level}</td>
                        </tr>
                    </c:if>
                </c:if>
        </c:forEach>
        </tbody>
        <tbody>
        <c:forEach var="mem" items="${rankMembers}" varStatus="status">

            <c:if test="${status.index >= 3}">
                <tr>
                    <td>${mem.rank}</td>
                    <td>${mem.name}</td>
                    <td>${mem.level}</td>
                </tr>

                <c:if test="${authInfo.name == mem.name}">
                    <tr class="my-rank">
                        <td>${mem.rank}</td>
                        <td>${mem.name}</td>
                        <td>${mem.level}</td>
                    </tr>
                </c:if>

            </c:if>

        </c:forEach>
        </tbody>
    </table>
</body>
</html>
