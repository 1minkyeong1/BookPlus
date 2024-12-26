<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" 	isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<c:set var="goods"  value="${goodsMap.goodsVO}"  />
 <%
     //치환 변수 선언합니다.
      pageContext.setAttribute("crcn", "\r\n"); //개행문자
    //pageContext.setAttribute("crcn" , "\n"); //Ajax로 변경 시 개행 문자 
      pageContext.setAttribute("br", "<br/>"); //br 태그
%>  
<html>
<head>
	<style>
		#layer {
			z-index: 2;
			position: absolute;
			top: 0px;
			left: 0px;
			width: 100%;
		}
		#popup {
			z-index: 3;
			position: fixed;
			text-align: center;
			left: 50%;
			top: 45%;
			width: 300px;
			height: 200px;
			background-color: #ccffff;
			border: 3px solid #87cb42;
		}
		#close {
			z-index: 4;
			float: right;
		}
	</style>
<script type="text/javascript">

    //장바구니 버튼을 클릭하면 호출되는 함수
	function add_cart(goods_id) {

		// 선택된 수량 확인
	    var order_goods_qty = document.getElementById("order_goods_qty").value;
		
		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
		
			//Ajax를 이용해 장바구니에 추가할 상품 번호를 전송 하여 장바구니에 상품 추가 요청을 합니다. 
			url : "${contextPath}/cart/addGoodsInCart.do",
			data : { 
					goods_id:goods_id,
					order_goods_qty: order_goods_qty
			},
			success : function(data, textStatus) {
// 						장바구니테이블에 추가할 상품이 이미 존재하면? "already_existed" 메세지를 받고
// 						존재하지 않으면? 장바구니 테이블에 새 상품을 추가INSERT하고 나서?
// 						'add_success'메세지를  위 data매개변수로 받는다.
				//alert(data);
			//	$('#message').append(data);
				if(data.trim()=='add_success'){ //장바구니 테이블에 새상품을 추가하고 메세지를 받으면?
					
					alert("장바구니에 담았습니다.");
				
				}else if(data.trim()=='already_existed'){//장바구니 테이블에 
														 //사이트 이용자가 추가할 상품이 이미 저장되어 있으면?
					
					alert("이미 카트에 등록된 상품입니다.");	
				}
				
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");
			}
		}); //end ajax	
	}


//구매하기 버튼을 누르면 호출되는 함수로 현재보고 있는 도서상품의 번호, 제목, 정가가격, 도서이미지명을 매개변수로 받아서 처리   
// 구매하기 버튼에 대한 함수 수정
/* function fn_order_each_goods(goods_id, goods_title, discounted_price, fileName) {
    // 로그인 여부 확인
    var isLogOn = document.getElementById("isLogOn").value; 
    if (isLogOn === "false" || isLogOn === '') {
        alert("로그인 후 주문이 가능합니다!!!");
    }

    // 선택된 수량 확인
    var order_goods_qty = document.getElementById("order_goods_qty").value;

    // 폼 생성 및 데이터 추가
    var formObj = document.createElement("form");
    formObj.method = "post";
    formObj.action = "${contextPath}/order/orderEachGoods.do";

    // 폼 데이터 배열
    var formData = [
        { name: "goodsId", value: goods_id },
        { name: "goodsTitle", value: goods_title },
        { name: "goodsFinalPrice", value: discounted_price },
        { name: "orderGoodsQty", value: order_goods_qty },
        { name: "goodsFileName", value: fileName }
        
    ];

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
    document.body.removeChild(formObj);
} */
function fn_order_each_goods(goods_id) {
    // 로그인 여부 확인
    var isLogOn = document.getElementById("isLogOn").value; 
    if (isLogOn === "false" || isLogOn === '') {
        alert("로그인 후 주문이 가능합니다!!!");
    }

    // 선택된 수량 확인
    var order_goods_qty = document.getElementById("order_goods_qty").value;

    // 폼 생성 및 데이터 추가
    var formObj = document.createElement("form");
    formObj.method = "post";
    formObj.action = "${contextPath}/order/orderEachGoods.do";

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
    document.body.removeChild(formObj);
}

</script>
</head>
<body>
	<hgroup>
		<h1>컴퓨터와 인터넷</h1>
		<h2>국내외 도서 &gt; 컴퓨터와 인터넷 &gt; 웹 개발</h2>
		<h3>${goods.goods_title }</h3>
		<h4>${goods.goods_writer} &nbsp; 저| ${goods.goods_publisher}</h4>
	</hgroup>
	<div id="goods_image">
		<figure>
			<img alt="HTML5 &amp; CSS3"
				src="${goods.goods_fileName}">
		</figure>
	</div>
	<div id="detail_table">
		<table>
			<tbody>
				<tr>
					<td class="fixed">정가</td>
					<td class="active"><span>
					   <fmt:formatNumber  value="${goods.goods_price}" type="number" var="goods_priceStandard" />
				         ${goods_priceStandard}원
					</span></td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">판매가</td>
					<td class="active">
					<span>
					   <fmt:formatNumber  value="${goods.goods_price * (100 - goods.goods_sales_price) / 100}" type="number" var="discounted_price" />
				         ${discounted_price}원( ${ goods.goods_sales_price} %할인)</span></td>
				</tr>
				<%-- <tr>
					<td class="fixed">포인트적립</td>
					<td class="active">${goods.goods_point}P(10%적립)</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">포인트 추가적립</td>
					<td class="fixed">만원이상 구매시 1,000P, 5만원이상 구매시 2,000P추가적립 편의점 배송 이용시 300P 추가적립</td>
				</tr>
				<tr> --%>
					<td class="fixed">발행일</td>
					<td class="fixed">
					   <c:set var="pub_date" value="${goods.goods_published_date}" />
					   <c:set var="arr" value="${fn:split(pub_date,' ')}" />
					   <c:out value="${arr[0]}" />
					</td>
				</tr>
				<tr>
					<td class="fixed">페이지 수</td>
					<td class="fixed">${goods.goods_total_page}쪽</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">ISBN</td>
					<td class="fixed">${goods.goods_isbn}</td>
				</tr>
				<tr>
					<td class="fixed">배송료</td>
					<td class="fixed"><strong>${goods.goods_delivery_price }</strong></td>
				</tr>
				<tr>
					<td class="fixed">배송안내</td>
					<td class="fixed">
						<strong>[당일배송]</strong> 당일배송 서비스 시작!<br> 
						<strong>[휴일배송]</strong>
						휴일에도 배송받는 BookPlus
					</td>
				</tr>
				<tr>
					<td class="fixed">도착예정일</td>
					<td class="fixed">지금 주문 시 내일 도착 예정!</td>
				</tr>
				<tr>
					<td class="fixed">수량</td>
					<td class="fixed">
					      <select style="width: 60px;" id="order_goods_qty">
				      		<option>1</option>
							<option>2</option>
							<option>3</option>
							<option>4</option>
							<option>5</option>
					     </select>
					 </td>
				</tr>
			</tbody>
		</table>
		<ul>
<%-- 			<li><a class="buy" href="javascript:fn_order_each_goods('${goods.goods_id }','${goods.goods_title }','${discounted_price}','${goods.goods_fileName}');">구매하기 </a></li>--%>
			<li><a class="buy" href="javascript:fn_order_each_goods('${goods.goods_id }');">구매하기 </a></li>
			<li><a class="cart" href="javascript:add_cart('${goods.goods_id }')">장바구니</a></li>
			<!-- 
			<li><a class="wish" href="#">위시리스트</a></li> -->
		</ul>
	</div>
	
	<div class="clear"></div>
	<div id="layer" style="visibility: hidden">
	</div>		
</body>
</html>
<input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>
