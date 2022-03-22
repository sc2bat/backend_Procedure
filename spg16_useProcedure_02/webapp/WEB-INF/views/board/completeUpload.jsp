<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<script type="text/javascript">
	opener.frm.imgfilename.value='${uploadImage}';
	opener.document.getElementById('image').innerHTML='${uploadImage}';
	opener.document.getElementById('previewImg').setAttribute('src', '/upload/' + '${uploadImage}');
	opener.document.getElementById('previewImg').style.display='inline';
	self.close();
</script>
</head>
<body>

</body>
</html>