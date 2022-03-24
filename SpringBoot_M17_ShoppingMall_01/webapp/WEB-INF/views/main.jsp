<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/headerfooter/header.jsp" %>

<div id="main_img">
	<img src="/images/main_img.jpg"  style="border-radius:20px 20px 20px 20px; border:2px solid white;"> 
</div>

<!-- 신상품 -->
<h2>New Item</h2>   
<div id="bestProduct">
	<c:forEach items="${newProductList}"  var = "productVO" >
		<div id="item"> <!-- 상품 한개 , 한칸 -->
			<a href="productDetail?pseq=${productVO.PSEQ}">
				<img src="/product_images/${productVO.IMAGE}" />
				<h3> ${productVO.NAME} - <fmt:formatNumber value="${productVO.PRICE2}" type="currency" /></h3>
			</a>
		</div>
	</c:forEach>
</div>

<!-- 베스트 상품 -->
<h2>Best Item</h2>   
<div id="bestProduct">
	<c:forEach items="${bestProductList}"  var = "productVO" >
		<div id="item"> <!-- 상품 한개 , 한칸 -->
			<a href="productDetail?pseq=${productVO.PSEQ}">
				<img src="/product_images/${productVO.IMAGE}" />
				<h3> ${productVO.NAME} - <fmt:formatNumber value="${productVO.PRICE2}" type="currency" /></h3>
			</a>
		</div>
	</c:forEach>
</div>
<div class="clear"></div>

<%@ include file="/WEB-INF/views/include/headerfooter/footer.jsp" %>