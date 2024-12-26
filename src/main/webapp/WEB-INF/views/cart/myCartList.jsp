<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="isLogOn" value="${sessionScope.isLogOn}" />
<c:set var="myCartList" value="${sessionScope.cartMap.myCartList}" />
<c:set var="myGoodsList" value="${sessionScope.cartMap.myGoodsList}" />


<%-- 장바구니테이블에 추가된 상품의 총 개수를 저장할 변수 선언  --%>
<c:set var="totalGoodsNum" value="0" />
<%-- 장바구니테이블에 추가된 상품의 총 배송비를 저장할 변수 선언 --%>
<c:set var="totalDeliveryPrice" value="0" />
<%-- 장바구니테이블에 추가된 상품의 총 할인 금액을 저장할 변수 선언 --%>
<c:set var="totalDiscountedPrice" value="0" />
<%-- 장바구니테이블에 추가된 상품의 총 주문 금액을 저장할 변수 선언 --%>
<c:set var="totalGoodsPrice" value="0" />

<head>
<script type="text/javascript">

//수량 입력후 [변경] 버튼을 클릭했을때 호출되는 함수 
//상품번호, 상품가격, 장바구니 목록에서 체크한 상품의 행 위치 index
function modify_cart_qty(goods_id,bookPrice,index){
	 
   //주문 수량을 입력하는 <input>태그들이 cart_goods_qty배열에 저장되어 있으므로 개수 알아내오기 
   var length=document.frm_order_all_cart.cart_goods_qty.length;
   var _cart_goods_qty=0;
   
   //장바구니 목록에 주문할 상품이 여러개 인경우 (주문 수량을 입력하는 <input>태그가 여러개인 경우)
	if(length>1){ 
		_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty[index].value;		
	}else{
		_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty.value;
	}
		
	var cart_goods_qty=Number(_cart_goods_qty);
	
   if(cart_goods_qty >= 1){

	   //입력한 주문 수량 정보를 DB에 수정 하기 위해 요청!
		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/cart/modifyCartQty.do",
			data : { 
				//상품 번호 
				goods_id:goods_id,
				//상품번호에 해당하는 상품의 수량 
				cart_goods_qty:cart_goods_qty
			},
			
			success : function(data, textStatus) {
				//alert(data);
				if(data.trim()=='modify_success'){
					alert("수량을 변경했습니다!!");	
					location.reload();
				}else{
					alert("다시 시도해 주세요!!");	
				}
			},
			error : function(data, textStatus) {
				alert("수량을 변경하는 도중 에러가 발생했습니다."+data);
			}
		}); //end ajax	
   } else {
	   alert("수량은 1개 이상이어야 합니다. 다시 입력해 주세요.");
   }

}

function delete_cart_goods(cart_id){
	var cart_id=Number(cart_id);
	var formObj=document.createElement("form");
	var i_cart = document.createElement("input");
	i_cart.name="cart_id";
	i_cart.value=cart_id;
	
	formObj.appendChild(i_cart);
    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="${contextPath}/cart/removeCartGoods.do";
    formObj.submit();
}

function fn_order_each_goods(goods_id) {
    // 로그인 여부 확인
    var isLogOn = '${isLogOn}'; 
    if (isLogOn === "false" || isLogOn === '') {
        alert("로그인 후 주문이 가능합니다!!!");
       	return;
    }

    // 선택된 수량 확인
    var order_goods_qty = document.getElementById("cart_goods_qty_" + goods_id).value;
    if (!order_goods_qty || isNaN(order_goods_qty) || order_goods_qty <= 0) {
        alert("유효한 수량을 입력해 주세요.");
        return; // 함수 실행 종료
    }

    // 폼 생성 및 데이터 추가
    var contextPath = '${contextPath}';
    var formObj = document.createElement("form");
    formObj.method = "post";
    formObj.action = contextPath + "/order/orderEachGoods.do";

    // 폼 데이터 배열
    var formData = [
        { name: "goodsId", value: goods_id },
        { name: "orderGoodsQty", value: order_goods_qty }
    ];

    console.log(goods_id);
    console.log(order_goods_qty);
    
    // 폼에 데이터 추가
    formData.forEach(function(item) {
        var input = document.createElement("input");
        input.type = "hidden";
        input.name = item.name;
        input.value = item.value;
        formObj.appendChild(input);
    });

    // 폼 제출
    document.body.appendChild(formObj);
    formObj.submit();
    setTimeout(function() {
        document.body.removeChild(formObj);
    }, 0);
}

//장바구니 목록 화면의 주문하기 이미지를 클릭했을때.... 호출되는 함수
function fn_order_all_cart_goods(){
	var objForm=document.frm_order_all_cart;
	var cart_goods_qty=objForm.cart_goods_qty;
	var length=document.getElementById("h_totalGoodsNum").value;  
	
	 // 숨겨진 필드 생성용 배열
    var hiddenFields = [];

    if (length > 1) {
        for (var i = 0; i < length; i++) {
            var order_goods_id = cart_goods_qty[i].getAttribute("data-goods-id");
            var order_goods_qty = cart_goods_qty[i].value;

            // 숨겨진 필드 추가
            var hiddenField = document.createElement("input");
            hiddenField.type = "hidden";
            hiddenField.name = "cart_goods_qty2"; // 서버에서 배열로 수신
            hiddenField.value = order_goods_id + ":" + order_goods_qty; // '상품번호:수량' 형식
            hiddenFields.push(hiddenField);
            
        }
    } else {
        var order_goods_id = cart_goods_qty.getAttribute("data-goods-id");
        var order_goods_qty = cart_goods_qty.value;
        
        var hiddenField = document.createElement("input");
        hiddenField.type = "hidden";
        hiddenField.name = "cart_goods_qty2"; // 서버에서 배열로 수신
        hiddenField.value = order_goods_id + ":" + order_goods_qty; // '상품번호:수량' 형식
        hiddenFields.push(hiddenField);
    }

    // 숨겨진 필드 추가
    hiddenFields.forEach(function (field) {
        objForm.appendChild(field);
    });
		
    console.log(hiddenFields);
 	objForm.method="post";
 	objForm.action="${contextPath}/order/orderAllCartGoods.do"; 
 	objForm.submit();
}
</script>
</head>
<body>
	<table class="list_view">
		<tbody align=center>
			<tr style="background: #33ff00">
				<td colspan=2 class="fixed">상품명</td>
				<td>정가</td>
				<td>판매가</td>
				<td>수량</td>
				<td>배송비</td>
				<td>합계</td>
				<td>주문</td>
			</tr>
			<c:choose>
			    <c:when test="${empty myCartList}">
			        <tr>
			            <td colspan=9 class="fixed"><strong>장바구니에 상품이 없습니다.</strong></td>
			        </tr>
			    </c:when>
			    <c:otherwise>
			        <form name="frm_order_all_cart" method="post" action="${contextPath}/order/orderAllCartGoods.do">
			            <c:forEach var="item" items="${myGoodsList}" varStatus="cnt">
			                <tr>
			                    <c:set var="cart_goods_qty" value="${myCartList[cnt.count-1].cart_goods_qty}" />
			                    <c:set var="cart_id" value="${myCartList[cnt.count-1].cart_id}" />
			                    
			                   
			                    <td class="goods_image">
			                        <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
			                            <img width="75" alt="" src="${item.goods_fileName}" />
			                        </a>
			                    </td>
			                    <td width="200px">
			                        <h2>
			                            <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">${item.goods_title}</a>
			                        </h2>
			                    </td>
			                    <td class="price"><span>${item.goods_price}원</span></td>
			                    <td>
			                        <strong>
			                            <fmt:formatNumber value="${item.goods_price * (100 - item.goods_sales_price) / 100}" 
			                                              type="number" var="discounted_price" />
			                            ${discounted_price}원
			                        </strong><br>
			                        <strong>
			                        	(${item.goods_sales_price}% 할인)
			                        </strong>
			                    </td>
			                    <td>
			                        <input type="hidden" id="cart_goods_qty_${item.goods_id}" name="cart_goods_qty_${item.goods_id}" size="3" value="${cart_goods_qty}" data-goods-id="${item.goods_id}">
			                        <input type="text" id="cart_goods_qty" name="cart_goods_qty" size="3" value="${cart_goods_qty}" data-goods-id="${item.goods_id}">
			                        <a href="javascript:modify_cart_qty(${item.goods_id}, ${item.goods_sales_price}, ${cnt.count-1});">
			                            <img width="25" alt="" src="${contextPath}/resources/image/btn_modify_qty.jpg">
			                        </a>
			                    </td>
			                    <td><strong>${item.goods_delivery_price}원</strong></td>
			                    <td>
			                        <strong id="total_sales_price">
			                            <fmt:formatNumber value="${((item.goods_price * (100 - item.goods_sales_price) / 100) * cart_goods_qty) + item.goods_delivery_price}" 
			                                              type="number" var="total_sales_price" />
			                            ${total_sales_price}원
			                        </strong>
			                    </td>
			                    <td>
			                        <a href="javascript:fn_order_each_goods('${item.goods_id}');">
			                            <img width="75" alt="" src="${contextPath}/resources/image/btn_order.jpg">
			                        </a>
			                        <br>
			                        <a href="javascript:delete_cart_goods('${cart_id}');">
			                            <img width="75" alt="" src="${contextPath}/resources/image/btn_delete.jpg">
			                        </a>
			                    </td>
			                </tr>
			                <!-- 누적 합산 -->
			                <c:set var="totalGoodsNum" value="${totalGoodsNum + 1}" />
			                <c:set var="totalGoodsPrice" value="${totalGoodsPrice + (item.goods_price * cart_goods_qty)}" />
			                <c:set var="totalCartGoodsQty" value="${totalCartGoodsQty + cart_goods_qty}" />
			                <c:set var="totalDiscountedPrice" value="${totalDiscountedPrice + ((item.goods_price - (item.goods_price * (100 - item.goods_sales_price) / 100)) * cart_goods_qty)}" />
			                <c:set var="totalDeliveryPrice" value="${totalDeliveryPrice + item.goods_delivery_price}" />
			            </c:forEach>
			        </form>
			    </c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<br><br>

	<table width=80% class="list_view" style="background: #cacaff">
		<tbody>
			<tr align=center class="fixed">
				<td class="fixed">책 종류 수</td>
				<td>구매할 총 상품수</td>
				<td>총 상품금액</td>
				<td></td>
				<td>총 배송비</td>
				<td></td>
				<td>총 할인 금액</td>
				<td></td>
				<td>최종 결제금액</td>
			</tr>
			<tr cellpadding=40 align=center>
				<td>
					<p id="p_totalGoodsNum">${totalGoodsNum}개</p> <input
					id="h_totalGoodsNum" type="hidden" value="${totalGoodsNum}" />
				</td>
				<td id="">
					<p id="p_totalGoodsQty">${totalCartGoodsQty}개</p> <input
					id="h_totalGoodsQty" type="hidden" value="${totalCartGoodsQty}" />
				</td>

				<td>
					<p id="p_totalGoodsPrice">
						<fmt:formatNumber value="${totalGoodsPrice}" type="number"
							var="total_goods_price" />
						${total_goods_price}원
					</p> <input id="h_totalGoodsPrice" type="hidden"
					value="${totalGoodsPrice}" />
				</td>
				<td><img width="25" alt=""
					src="${contextPath}/resources/image/plus.jpg"></td>
				<td>
					<p id="p_totalDeliveryPrice">${totalDeliveryPrice }원</p> <input
					id="h_totalDeliveryPrice" type="hidden"
					value="${totalDeliveryPrice}" />
				</td>
				<td><img width="25" alt=""
					src="${contextPath}/resources/image/minus.jpg"></td>
				<td><fmt:formatNumber value="${totalDiscountedPrice}"
						type="number" var="totalDiscountedPrice2" />
					<p id="p_totalSalesPrice">${totalDiscountedPrice2}원</p> <input
					id="h_totalSalesPrice" type="hidden" value="${totalSalesPrice2}" />
				</td>
				<td><img width="25" alt=""
					src="${contextPath}/resources/image/equal.jpg"></td>
				<td>
					<p id="p_final_totalPrice">
						<fmt:formatNumber value="${totalGoodsPrice+totalDeliveryPrice-totalDiscountedPrice}" type="number" var="total_price" />
						${total_price}원
					</p> 
					<input id="h_final_totalPrice" type="hidden" value="${totalGoodsPrice+totalDeliveryPrice}" />
				</td>
			</tr>
		</tbody>
	</table>
	<br><br> 
		<a href="javascript:fn_order_all_cart_goods()"> 
		<img width="75" alt="" src="${contextPath}/resources/image/btn_order_final.jpg"> <!-- 주문하기 -->
		</a> 
		<a href="${contextPath}/main/main.do"> <img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
			<!-- 쇼핑 계속하기 -->
		</a>
		
</body>
