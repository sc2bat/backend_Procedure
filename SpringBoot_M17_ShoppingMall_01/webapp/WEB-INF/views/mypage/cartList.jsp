<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/headerfooter/header.jsp" %>
<%@ include file="../include/sub03/sub_img.html" %>
<%@ include file="../include/sub03/sub_menu.jsp" %>

<article>
<h2> Cart List </h2>
<form name="formm" method="post">
	<c:choose>
		<c:when test="${cartList.size() == 0}">
			<h3 style="color: red;text-align: center;">장바구니가 비었습니다.</h3> 
		</c:when>
		<c:otherwise>
			<table id="cartList">
				<tr><th>상품명</th><th>수 량</th><th>가 격</th><th>주문일</th><th>삭 제</th></tr>
					<c:forEach items="${cartList}" var="cartVO">
						<tr><td><a href="productDetail?pseq=${cartVO.PSEQ}" target="_blank" >
							<h3> ${cartVO.PNAME} </h3></a></td><td> ${cartVO.QUANTITY} </td>
						<td><fmt:formatNumber value="${cartVO.PRICE2*cartVO.QUANTITY}"	type="currency"/></td>
						<td><fmt:formatDate value="${cartVO.INDATE}" type="date" /></td>
						<td><input type="checkbox" name="cseq" value="${cartVO.CSEQ}"></td></tr>
					</c:forEach>
				<tr><th colspan="2"> 총 액 </th><th colspan="2">
       				<fmt:formatNumber value="${totalPrice}" type="currency" /></th>
       				<th><a href="#" onClick="go_cart_delete();"><h3>삭제하기</h3></a></th></tr> 
			</table>
		</c:otherwise>
	</c:choose>
<div id="buttons" style="float: right">
    <input type="button" value="계속 쇼핑" class="cancel" onclick="location.href='/'">    
    <c:if test= "${cartList.size() != 0}">
   		<input type="button" value="주문하기"  class="submit" onclick="go_order_insert();">
    </c:if>
</div>
</form>
</article>


<%@ include file="../include/headerfooter/footer.jsp" %>