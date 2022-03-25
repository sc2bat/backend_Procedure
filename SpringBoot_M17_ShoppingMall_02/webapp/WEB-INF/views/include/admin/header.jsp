<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/admin/css/admin.css">
<script src="/admin/script/product.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function(){
		$('#myButton').click(function(){
			var formselect = $("#fileupForm")[0]; // 지정된 폼을 변수에 저장
			var formdata = new FormData(formselect); // 전송용 폼객에 다시 저장
			
			//ajax : 웹페이지 새로고침이 필요없는 request(요청)
			$.ajax({
				url:"<%=request.getContextPath()%>/fileup",
				type:"POST",
				enctype:"multipart/form-data",
				async:false,
				data:formdata,
				timeout:10000,
				contentType:false,
				processData:false,
				success:function(data){
					if(data.STATUS == 1){
						// 동적으로 DIV 태그 달아주기
						$("#filename").empty();
						$("#filename").append("<div>"+data.FILENAME+"</div>");
					}
				}
			});
		});
	});
</script>
</head>
<body>

<div id="wrap">
	<header>			
		<div id="logo">
			<img style="width:800px" src="/admin/images/bar_01.gif"><img src="/admin/images/text.gif">
		</div>	
		<input class="btn" type="button" value="logout" style="float: right;" onClick="location.href='adminLogout'">			
	</header>
	<div class="clear"></div>