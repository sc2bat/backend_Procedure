<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="../include/headerfooter/header.jsp" %>
<%@ include file="../include/sub01/sub_image.html" %>
<%@ include file="../include/sub01/sub_menu.html" %>

<article>
<h2>Edit Profile</h2>
<!-- 회원가입 폼과 같이 주소검색시 결과를 받기위해 폼이름을  updateForm 아 아니고 joinForm 으로 합니다-->
<form method="post" name="joinForm" action="memberUpdate">
	<fieldset>
		<legend>Basic Info</legend>
		<!-- id 는 수정 대상이 아니면서, submit 할때 전송될 대상이므로, input type="text" 로 하되  readonly 로 설정해서 수정을 금지시킵니다 -->
		<label>User ID</label><input type="text" name="userid" value="${loginUser.USERID}" readonly><br>
		<label>Password</label><input type="password"  name="pwd"><br> 
        <label>Retype Password</label>	<input type="password"  name="pwdCheck"><br> 
        <label>Name</label><input type="text" name="name"  value="${loginUser.NAME}"><br> 
        <label>E-Mail</label><input type="text" name="email" value="${loginUser.EMAIL}"><br>
	    <label>Phone Number</label><input  type="text" name="phone"  value="${loginUser.phone}"><br>
	</fieldset>
	<fieldset>
		<legend>Optional</legend>
	    <label>Zip Code</label><input type="text" name="zip_num" size="10" value="${loginUser.ZIP_NUM}">      
	    	<input type="button" value="주소 찾기" class="dup" onclick="post_zip()"><br>
	    <label>Address</label><input type="text" name="address"   size="50" value="${loginUser.ADDRESS}"><br>
	    <label>&nbsp;</label>	<input type="text" name="address2"   size="25" value="${loginUser.ADDRESS2}"><br>
	</fieldset><div class="clear"></div>
	<div id="buttons"><input type="button" value="정보수정" class="submit" onclick="go_update();"> 
		<input type="reset" value="취소" class="cancel"></div>
</form>
</article>


<%@ include file="../include/headerfooter/footer.jsp" %>