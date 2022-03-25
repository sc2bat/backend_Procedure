<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="/css/shopping.css" rel="stylesheet">  
<script src="/script/member.js"></script>
</head>
<body>
<div id="wrap">
	<h1>ID 중복확인</h1>
	<form method="post" action="idCheckForm">
		User ID :  <input type="text" name="userid" value="${userid}" >
		<input type="submit" value="검색" class="submit"><br><br><br>	
		<div>
			<c:if test="${result == 1}">
				<script type="text/javascript">opener.document.joinForm.userid.value="";</script>
				${userid}는 이미 사용중인 아이디입니다.
			</c:if>
			<c:if test="${result == -1}">
				${userid}는 사용 가능한 ID입니다.    
				<input type="button" value="사용" class="cancel" onclick="idok('${userid}');">
			</c:if>
		</div>
	</form>
</div>

</body>
</html>