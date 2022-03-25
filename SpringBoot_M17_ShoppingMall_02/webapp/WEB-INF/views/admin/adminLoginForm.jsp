<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/admin/css/admin.css">
<script src="/admin/script/admin.js"></script>
</head>
<body>

<div id="wrap">
<header>
	<div id="logo">
		<a href="admin">
			<img src="/admin/images/bar_01.gif" style="float:left;">	
			<img src="/admin/images/text.gif">
		</a>
	</div>
</header>
<div class="clear"></div>
<article>
<div id="loginform">
	<form name="frm" method="post" action="adminLogin">
		<table>
			<tr><td>아 이 디</td><td><input type="text" name="id" size="10" value="admin"></td></tr>
			<tr><td>비밀번호</td><td><input type="password" name="pwd" size="10" value="admin"></td></tr>
			<tr align="center" ><td  colspan="2">	
				<input class="btn" type="submit" value="로그인">
				<br><br><h4 style="color:red">${message}</h4></td></tr>
		</table>
	</form>
</div>
</article>
</div>

</body>
</html>