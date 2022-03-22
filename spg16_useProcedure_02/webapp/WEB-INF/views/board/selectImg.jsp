<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectImg</title>
<link rel="stylesheet" href="/css/board.css" type="text/css">
<script type="text/javascript" src="/script/board.js"></script>
</head>
<body>
	<div id="wrap" align="center" style="width:300px;">
		<form name="frm" method="post" action="fileUpload" enctype="multipart/form-data">
			<h1>select file</h1>
			<input type="file" name="uploadImage" onChange="selectedImage();">
<!-- 			<input type="submit" value="file uploading"> -->
		</form>
	</div>
</body>
</html>