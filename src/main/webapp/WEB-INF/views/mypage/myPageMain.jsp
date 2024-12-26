<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script>
function fn_cancel_order(orderId){
	var answer=confirm("주문을 취소하시겠습니까?");
	if(answer==true){
		var formObj=document.createElement("form");
		var i_orderId=document.createElement("input");
		i_orderId.name="orderId";
		i_orderId.value=orderId;
		formObj.appendChild(i_orderId);
		document.body.appendChild(formObj); 
		formObj.method="post";
		formObj.action="${contextPath}/mypage/cancelMyOrder.do";
		formObj.submit();	
	}
}

function fn_delete_order(order_id){
	var answer=confirm("주문을 삭제하시겠습니까?");
	if(answer==true){
		var formObj=document.createElement("form");
		var i_order_id=document.createElement("input");
		i_order_id.name="order_id";
		i_order_id.value=order_id;
		formObj.appendChild(i_order_id);
		document.body.appendChild(formObj); 
		formObj.method="post";
		formObj.action="${contextPath}/mypage/deleteMyOrder.do";
		formObj.submit();	
	}
}

function submitPost(orderId) {
    // 폼 객체 생성
    var form = document.createElement("form");
    form.method = "POST";
    form.action = "${contextPath}/mypage/myOrderDetail.do";

    // 파라미터 추가
    var input = document.createElement("input");
    input.type = "hidden";
    input.name = "order_id";
    input.value = orderId;

    form.appendChild(input);
    document.body.appendChild(form);

    // 폼 제출
    form.submit();

    // 폼 제거
    document.body.removeChild(form);
}
</script>

<c:choose>
    <c:when test="${message == 'cancel_order'}">
        <script>
        window.onload = function() {
            alert("주문을 취소했습니다.");
        }
        </script>
    </c:when>
    <c:when test="${message == 'delete_order'}">
        <script>
        window.onload = function() {
            alert("주문을 삭제했습니다.");
        }
        </script>
    </c:when>
    <c:otherwise>
        <!-- 다른 메시지에 대한 처리 필요시 여기에 작성 -->
    </c:otherwise>
</c:choose>

</head>
<body>
<h1>최근주문내역</h1>
<table class="list_view">
	<tbody align="center">
		<tr style="background:#33ff00">
			<td>주문번호</td>
			<td>주문일자</td>
			<td>주문상품</td>
			<td>수량</td>
			<td>배송상태</td>
			<td>주문취소</td>
		</tr>
		<c:choose>
			<c:when test="${empty myOrderList}">
				<tr>
					<td colspan=6 class="fixed"><strong>주문한 상품이 없습니다.</strong></td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach var="item" items="${myOrderList}" varStatus="i">
					<c:choose>
						<c:when test="${pre_order_id != item.orderId}">
							<c:choose>
								<c:when test="${item.deliveryState=='delivery_prepared'}">
									<tr bgcolor="lightgreen">
								</c:when>
								<c:when test="${item.deliveryState=='finished_delivering'}">
									<tr bgcolor="lightgray">
								</c:when>
								<c:otherwise>
									<tr bgcolor="orange">
								</c:otherwise>
							</c:choose> 
							<td>
								<a href="javascript:void(0);" onclick="submitPost('${item.orderId}')">
								    <span>${item.orderId}</span>
								</a>
							</td>
							<fmt:parseDate value="${item.orderDate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate" />
							<td>
							    <span>
							        <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd" />
							    </span>
							</td>
							<td align="left" width="250px">
								<c:set var="bookCount" value="0" />
							    <c:set var="firstBookTitle" value="" />
							    <c:forEach var="item2" items="${myOrderList}" varStatus="j">
							        <c:if test="${item.orderId == item2.orderId}">
							            <c:choose>
							                <c:when test="${bookCount == 0}">
							                    <c:set var="firstBookTitle" value="${item2.goodsTitle}" />
							                </c:when>
							            </c:choose>
							            <c:set var="bookCount" value="${bookCount + 1}" />
							        </c:if>
							    </c:forEach>
							    <strong>
							        <span>${firstBookTitle}</span><br>
							        <c:if test="${bookCount > 1}">
							            <span> 외 ${bookCount - 1}개</span>
							        </c:if>
							    </strong>
							</td>
							<td>
								<c:set var="totalQty" value="0" />
							    <c:forEach var="item2" items="${myOrderList}" varStatus="j">
							        <c:if test="${item.orderId == item2.orderId}">
							            <c:set var="totalQty" value="${totalQty + item2.orderGoodsQty}" />
							        </c:if>
							    </c:forEach>
							    <span>${totalQty}개</span>
							</td>
							<td>
								<c:choose>
									<c:when test="${item.deliveryState=='delivery_prepared'}">배송준비중</c:when>
									<c:when test="${item.deliveryState=='delivering'}">배송중</c:when>
									<c:when test="${item.deliveryState=='finished_delivering'}">배송완료</c:when>
									<c:when test="${item.deliveryState=='cancel_order'}">주문취소</c:when>
									<c:when test="${item.deliveryState=='returning_goods'}">반품완료</c:when>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${item.deliveryState=='delivery_prepared'}">
										<input type="button" onClick="fn_cancel_order('${item.orderId}')" value="주문취소"/>
									</c:when>
									<c:when test="${item.deliveryState=='cancel_order'}">
										<input type="button" onClick="fn_delete_order('${item.orderId}')" value="주문삭제"/>
									</c:when>
									<c:otherwise>
										<!-- No button -->
									</c:otherwise>
								</c:choose>
							</td> 
							</tr>
							<c:set var="pre_order_id" value="${item.orderId}"/>
						 </c:when>
					</c:choose>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>

<%-- 
<br><br><br>
<h1>계좌내역
	<a href="#"><img src="${contextPath}/resources/image/btn_more_see.jpg"></a>
</h1>
<table border=0 width=100% cellpadding=10 cellspacing=10>
	<tr>
		<td>예치금 &nbsp;&nbsp;<strong>10000원</strong></td>
		<td>쇼핑머니 &nbsp;&nbsp;<strong>9000원</strong></td>
	</tr>
	<tr>
		<td>쿠폰 &nbsp;&nbsp;<strong>6000원</strong></td>
		<td>포인트 &nbsp;&nbsp;<strong>2000원</strong></td>
	</tr>
	<tr>
		<td>상품권 &nbsp;&nbsp;<strong>4000원</strong></td>
		<td>디지털머니 &nbsp;&nbsp;<strong>9000원</strong></td>
	</tr>
</table> --%>

<br><br><br>
<h1>나의 정보
	<a href="#"><img src="${contextPath}/resources/image/btn_more_see.jpg"></a>
</h1>
<table border=0 width=100% cellpadding=10 cellspacing=10>
	<tr>
		<td>이메일:</td>
		<td><strong>${memberInfo.email1}@${memberInfo.email2}</strong></td>
	</tr>
	<tr>
		<td>전화번호</td>
		<td><strong>${memberInfo.hp1}-${memberInfo.hp2}-${memberInfo.hp3}</strong></td>
	</tr>
	<tr>
		<td>주소</td>
		<td>
			도로명: &nbsp;&nbsp;<strong>${memberInfo.roadAddress}</strong><br>
			지번: &nbsp;&nbsp;<strong>${memberInfo.jibunAddress}</strong>
		</td>
	</tr>
</table>
</body>
</html>
