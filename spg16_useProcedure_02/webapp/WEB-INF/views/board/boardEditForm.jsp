<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardEditForm</title>
<link rel="stylesheet" type="text/css" href="/css/board.css" />
<script src="/script/board.js"></script>
</head>
<body>
<div id="wrap" align="center">
	<h1>게시글 수정</h1>
	<form name="frm" method="post" action="boardUpdate">
		<input type="hidden" name="num" value="${dto.num }">
		<table>
			<tr>
				<th>작성자</th>
				<td>${loginUser.USERID }
					<input type="hidden" value="${loginUser.USERID }" size="12" name="userid">
				</td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="pass" size="12">* 필수(게시물 수정 삭제시 필요합니다)</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" name="email" value="${dto.email }" size="12"></td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name="title" value="${dto.title }" size="12"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea cols="70" rows="15" name="content">${dto.content}</textarea></td>
			</tr>
			<tr>
				<th>이미지</th>
				<td>
					<c:choose>
						<c:when test="${empty dto.imgfilename }">
							<img src="/upload/noname.jpg" height="80" width="80"><br>
						</c:when>
						<c:otherwise>
							<img src="/upload/${dto.imgfilename }" height="80" width="80">
						</c:otherwise>
					</c:choose>
				<div id="image"></div>
				<input type="hidden" name="imgfilename">
				<img src="" id="previewImg" width="150" style="display:none;">
				<input type="button" value="파일선택" onClick="selectImg();">
				<input type="hidden" name="oldfilename" value="${dto.imgfilename }">
				</td>
			</tr>
		</table><br>
<!-- 		<input type="submit" value="수정" onClick="return boardCheck();"> -->
		${message }
		<input type="submit" value="수정">
		<input type="button" value="목록" onClick="location.href='main'">
	</form>
</div>
</body>
</html>