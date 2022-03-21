<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>memberJoinForm</title>
<link rel="stylesheet" type="text/css" href="<c:url value='css/board.css'/>"/>
<script src="<c:url value="/script/board.js"/>"></script>
</head>
<body>
	<div id="wrap" align="center">
		<h1>사용자 등록</h1>
		<form name="frm" method="post" action="memberJoin">
			<table>
				<tr>
					<th>아이디</th>
					<td>
						<input type="text" name="userid" value="${dto.userid }" size="20">*
						<input type="button" value="중복체크" onClick="idCheck();">
						<input type="hidden" name="re_id" value="${re_id }">
					</td>
				</tr>
				<tr>
					<th>암호</th>
					<td><input type="password" name="pwd" size="20">*</td>
				</tr>
				<tr>
					<th>확인</th>
					<td><input type="password" name="pwd_check" size="20">*</td>
				</tr>
				<tr>
					<th>이름</th>
					<td><input type="text" name="name" value="${dto.name }" size="20">*</td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td><input type="text" name="phone" value="${dto.phone }" size="20">*</td>
				</tr>
				<tr>
					<th>이메일</th>
					<td><input type="text" name="email" value="${dto.email}" size="20"></td>
				</tr>
			</table><br><br>
<!-- 			<input type="submit" value="등록" onClick="return joinCheck();"> -->
			<input type="submit" value="등록">
			<input type="reset" value="다시 작성">
			<input type="button" value="로그인 페이지로 go" onClick="location.href='/'">
			${message }
		</form>
	</div>
</body>
</html>