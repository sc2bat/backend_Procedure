<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/headerfooter/header.jsp" %>
<%@ include file="../include/sub02/sub_img.html" %>
<%@ include file="../include/sub02/sub_menu.html" %>

<article>
<div id="itemdetail"  style="float:left;">
<h1>Item</h1>
<form  method="post" name="formm" >
	<fieldset>	<legend> Item detail Info</legend>
		<span style="float: left; margin-right:20px;">
			<img  src="/product_images/${productVO.IMAGE}" style="border-radius:20px;"/></span>              
       	<h2> ${productVO.NAME} </h2>  
		<label>가 격 : </label><p> ${productVO.PRICE2} 원</p>  
       	<label>수 량 : </label><input  type="text" name="quantity" size="2" value="1"><br>
       	<label>제품설명 : </label><label>${productVO.CONTENT}</label><br>
       	<input  type="hidden" name="pseq"	 value="${productVO.PSEQ}"><br>
	</fieldset>
	<div class="clear"></div>
	<div id="buttons">
		<input type="button" value="장바구니에 담기" class="submit" onclick="go_cart();">
		<input type="button" value="즉시 구매" class="submit" onclick="go_order()"> 
		<input type="reset"  value="취소" 	class="cancel">
	</div>
</form>
</div>
</article>

<%@ include file="../include/headerfooter/footer.jsp" %>