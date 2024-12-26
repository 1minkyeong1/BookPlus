<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String contextPath = request.getContextPath();
%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!-- 주문자 휴대폰 번호 -->
<c:set var="orderer_hp" value="" />
<!-- 최종 결제 금액 -->
<c:set var="final_total_order_price" value="0" />
<!-- 총주문 금액 -->
<c:set var="total_order_price" value="0" />
<!-- 총 상품수 -->
<c:set var="total_order_goods_qty" value="0" />
<!-- 총할인금액 -->
<c:set var="total_discount_price" value="0" />
<!-- 총 배송비 -->
<c:set var="total_delivery_price" value="0" />

<c:set var="memberInfo"  value="${memberInfo}"  />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 확인 및 결제</title>
	<style>
		#layer {
			z-index: 2;
			position: absolute;
			top: 0px;
			left: 0px;
			width: 100%;
		}
		
		#popup_order_detail {
			z-index: 3;
			position: fixed;
			text-align: center;
			left: 10%;
			top: 0%;
			width: 60%;
			height: 100%;
			background-color: #ccff99; /* 팝업창의 배경색 설정*/
			border: 2px solid #0000ff;
		}
		
		#close {
			z-index: 4;
			float: right;
		}
	</style>


	<!-- jQuery -->
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<!-- iamport.payment.js -->
	<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
	<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

	<script>
	
		// 페이지 로드될 때 호출되는 함수
		window.onload = function() {
			init();
		}
	
		function requestPay() {
			

			var IMP = window.IMP;
	    	IMP.init("imp63260822"); // 아임포트 초기화
	    
	        var buyerName = document.getElementById("order_name").value;
	        var buyerEmail = document.getElementById("order_email").value;
	        var buyerTel = document.getElementById("order_phone").value;
	        var buyerAddr = document.getElementById("roadAddress").value + " " +
	                        document.getElementById("jibunAddress").value + " " +
	                        document.getElementById("namujiAddress").value;
	        var buyerPostcode = document.getElementById("zipcode").value;
	        var merchantUid = new Date().getTime();
	        var amount = document.getElementById("h_final_total_Price").value;
	        
	        // -----------------------------------------------------------------
	        // 다중 책(상품) 처리를 위해, 여러 h_goods_id, h_goods_title, h_order_goods_qty를 수집
	        // -----------------------------------------------------------------
	        var goodsIdElems    = document.getElementsByName("h_goods_id_");       // 여러 개
	        var goodsTitleElems = document.getElementsByName("h_goods_title_");    // 여러 개
	        var goodsQtyElems   = document.getElementsByName("h_order_goods_qty_");// 여러 개
	        var goodsTotalPrice  = document.getElementsByName("h_total_price_");// 여러 개

	        var goodsDataList = [];
	        for (var i = 0; i < goodsIdElems.length; i++) {
	            goodsDataList.push({
	                goods_id: goodsIdElems[i].value,
	                goods_title: goodsTitleElems[i].value,
	                order_goods_qty: parseInt(goodsQtyElems[i].value, 10),
	                total_price: parseInt(goodsTotalPrice[i].value.replace(/,/g, ''), 10)
	            });
	            console.log(parseInt(goodsTotalPrice[i].value.replace(/,/g, ''), 10));
	        }
	        
	    	 // 상품 제목 가공
	        var goodsTitle = "";
	        if (goodsTitleElems.length === 1) {
	            goodsTitle = goodsTitleElems[0].value;
	        } else if (goodsTitleElems.length > 1) {
	            goodsTitle = goodsTitleElems[0].value + " 외 " + (goodsTitleElems.length - 1) + "권";
	        }
	        
	        // 디버그 출력
	        console.log("buyerName:", buyerName);
	        console.log("buyerEmail:", buyerEmail);
	        console.log("buyerTel:", buyerTel);
	        console.log("buyerAddr:", buyerAddr);
	        console.log("buyerPostcode:", buyerPostcode);
	        console.log("merchantUid:", merchantUid);
	        console.log("amount:", amount);

	        console.log("=== 개별 책 정보 ===");
	        console.log(goodsDataList);

		    IMP.request_pay({
		        pg: "html5_inicis",
		        pay_method: "card",
		        merchant_uid: merchantUid,
		        name: goodsTitle,    
		        amount: amount,
		        buyer_email: buyerEmail,
		        buyer_name: buyerName,
		        buyer_tel: buyerTel,
		        buyer_addr: buyerAddr,
		        buyer_postcode: buyerPostcode
		    }, function(rsp) {
		        if (rsp.success) {
		            alert("결제가 성공적으로 완료되었습니다.");
		            var contextPath = '<%=request.getContextPath()%>';

		            $.ajax({
		                type: "POST",
		                url: contextPath + "/order/paySuccess", // 서버의 결제 성공 처리 API
		                contentType: "application/json",
		                data: JSON.stringify({
		                    imp_uid      : rsp.imp_uid,         // 아임포트 결제 고유 ID
		                    merchant_uid : rsp.merchant_uid,    // 상점에서 생성한 고유 주문 번호
		                    amount       : rsp.paid_amount,     // 실제 결제된 금액
		                    pay_method   : rsp.pay_method,      // 결제 방식
		                    status       : rsp.status,          // 결제 상태

		                    // 주문 관련 정보 (다중 상품 처리)
		                    order_id           : rsp.merchant_uid,
		                	order_member_id    : document.getElementById("order_member_id").value,
		                	order_member_name  : document.getElementById("order_member_name").value,

		                	 // 개별 책 정보 전송
		                    goods_list: goodsDataList,

		                    // 배송 관련 정보
		                    receiver_name     : document.getElementById("receiver_name").value,
		                    receiver_hp1      : document.getElementById("hp1").value,
		                    receiver_hp2      : document.getElementById("hp2").value,
		                    receiver_hp3      : document.getElementById("hp3").value,
		                    delivery_address  : buyerAddr,
		                    delivery_message  : document.getElementById("delivery_message").value ,
		                    delivery_method   : document.getElementById("delivery_method").value
		                }),
		                success: function(response) {
		                    if (response.success) {
		                        alert("결제 정보가 성공적으로 저장되었습니다.");
		                        document.getElementById("order_id").value = response.order_id; // 서버에서 반환된 order_id
		                        document.getElementById("orderForm").submit();
		                    } else {
		                        alert("결제 정보 저장에 실패했습니다. 관리자에게 문의하세요.");
		                    }
		                },
		                error: function(xhr, status, error) {
		                    console.error("결제 정보 전송 중 오류 발생:", error);
		                    alert("서버와 통신 중 오류가 발생했습니다. 관리자에게 문의하세요.");
		                }
		            });

		        } else {
		            alert("결제 실패: " + rsp.error_msg);
		        }
		    });
		}

		
		// 우편번호 검색 (다음 주소 API)
		function execDaumPostcode() {
			new daum.Postcode({
				oncomplete : function(data) {
					var fullRoadAddr = data.roadAddress; 
					var extraRoadAddr = '';

					if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
						extraRoadAddr += data.bname;
					}
					if (data.buildingName !== '' && data.apartment === 'Y') {
						extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					if (extraRoadAddr !== '') {
						extraRoadAddr = ' (' + extraRoadAddr + ')';
					}
					if (fullRoadAddr !== '') {
						fullRoadAddr += extraRoadAddr;
					}

					document.getElementById('zipcode').value = data.zonecode;
					document.getElementById('roadAddress').value = fullRoadAddr;
					document.getElementById('jibunAddress').value = data.jibunAddress;

					if (data.autoRoadAddress) {
						var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
						document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
					} else if (data.autoJibunAddress) {
						var expJibunAddr = data.autoJibunAddress;
						document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
					} else {
						document.getElementById('guide').innerHTML = '';
					}
				}
			}).open();
		}
	
		
		function init() {
			var form_order = document.form_order;
			// 로그인 한 주문자의 휴대폰번호 앞자리(010 등) select 셋팅
			var h_hp1 = form_order.h_hp1;
			var hp1 = h_hp1.value;
			var select_hp1 = form_order.hp1;
			select_hp1.value = hp1;
		}
		
		// 배송지 선택에서 새로 입력을 선택했을 경우 입력 활성화
		function setAddressEditable(editable) {
		    const fields = [
		        "receiver_name",
		        "hp1",
		        "hp2",
		        "hp3",
		        "zipcode",
		        "roadAddress",
		        "jibunAddress",
		        "namujiAddress",
		    ];
	
		    fields.forEach((id) => {
		        const field = document.getElementById(id);
		        if (field) {
		            field.readOnly = !editable; 
		            field.disabled = !editable; 
		            field.style.color = editable ? "" : "gray"; 
		        }
		    });
	
		    const addressButton = document.getElementById("searchAddressButton");
		    if (addressButton) {
		        addressButton.style.display = editable ? "inline" : "none";
		    }
	
		    const selectedDeliveryPlace = document.querySelector('input[name="delivery_place"]:checked').value;
	
		    if (editable && selectedDeliveryPlace === "새로입력") {
		        fields.forEach((id) => {
		            const field = document.getElementById(id);
		            if (field) {
		                if (field.tagName === "SELECT") {
		                    field.selectedIndex = 0;
		                } else {
		                    field.value = "";
		                }
		            }
		        });
		    } else if (!editable) {
		        restore_all(); 
		    }
		}
	
		// 기본 배송지로 복원
		function restore_all() {
		    const mapping = {
		        receiver_name: "h_receiver_name",
		        hp1: "h_hp1",
		        hp2: "h_hp2",
		        hp3: "h_hp3",
		        zipcode: "h_zipcode",
		        roadAddress: "h_roadAddress",
		        jibunAddress: "h_jibunAddress",
		        namujiAddress: "h_namujiAddress",
		    };
	
		    Object.entries(mapping).forEach(([fieldId, hiddenFieldId]) => {
		        const field = document.getElementById(fieldId);
		        const hiddenField = document.getElementById(hiddenFieldId);
		        if (field && hiddenField) {
		            field.value = hiddenField.value;
		        }
		    });
	
		    const fields = Object.keys(mapping);
		    fields.forEach((id) => {
		        const field = document.getElementById(id);
		        if (field) {
		            field.readOnly = true;
		            field.disabled = true;
		            field.style.color = "gray";
		        }
		    });
	
		    const addressButton = document.getElementById("searchAddressButton");
		    if (addressButton) {
		        addressButton.style.display = "none";
		    }
		}
	</script>
</head>
<body>
	<H1>1.주문확인</H1>
	<form name="form_order">
		<table class="list_view">
			<tbody align=center>
				<tr style="background: #33ff00">
					<td colspan=3 class="fixed">주문상품</td>
					<td>책 제목</td>
					<td>수량</td>
					<td>정가</td>
					<td>할인 후 금액</td>
					<td>배송비</td>
					<td>주문금액합계</td>
				</tr>

				<c:forEach var="item" items="${myOrderList}" varStatus="status">
					<tr>
						<td class="goods_image" colspan="3">
							<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
								<img width="75" alt="" src="${item.goods_fileName}" />
							</a>
						</td>
						
						<td width="200px">
							<span>${item.goods_title}</span>
						</td>
						
						<td>
							<strong>${orderQtyList[status.index]}개</strong>
						</td>

						<td class="price">
							<span>${item.goods_price}원</span>
						</td>
						
						<td>
						    <fmt:formatNumber  value="${item.goods_price * (100 - item.goods_sales_price) / 100}" type="number" var="discounted_price" />
							<strong>${discounted_price}원</strong><br>
							<strong>(${item.goods_sales_price}% 할인)</strong>
						</td>

						<td>
							<strong>${item.goods_delivery_price }원</strong>
						</td>

						<td>
							<fmt:formatNumber value="${((item.goods_price * (100 - item.goods_sales_price) / 100)  * orderQtyList[status.index]) + item.goods_delivery_price }"
							                  type="number" var="total_price" />
							<h2>${total_price}원</h2>
						</td>
					</tr>
					<!-- 누적합 계산 -->
				    <c:set var="final_total_order_price" value="${final_total_order_price + (item.goods_price * (100 - item.goods_sales_price) / 100) * orderQtyList[status.index] + item.goods_delivery_price}" />
				    <c:set var="total_order_goods_qty" value="${total_order_goods_qty + orderQtyList[status.index]}" />
				    <c:set var="total_order_price" value="${total_order_price + (item.goods_price * orderQtyList[status.index] ) }" />
				    <c:set var="total_discount_price" value="${total_discount_price + (item.goods_price * (item.goods_sales_price) / 100) * orderQtyList[status.index]}" />
				    <c:set var="total_delivery_price" value="${total_delivery_price + item.goods_delivery_price}" />
				    
				    <fmt:formatNumber  value="${final_total_order_price}" type="number" var="formatted_final_total_order_price" />
					
					<!-- 기존 hidden 필드는 그대로 두되, 중복 ID 문제 방지를 위해 id 속성 변경/추가 -->
					<!-- "name"을 동일하게 두어, 자바스크립트로 getElementsByName() 할 수 있게 함 -->
					
					<c:if test="${not empty item.goods_id}">
					    <input type="hidden" id="h_goods_id_${status.index}" name="h_goods_id_" value="${item.goods_id}">
					    <input type="hidden" id="h_goods_title_${status.index}" name="h_goods_title_" value="${item.goods_title}">
					    <input type="hidden" id="h_order_goods_qty_${status.index}" name="h_order_goods_qty_" value="${orderQtyList[status.index]}">
					    <input type="hidden" id="h_total_price_${status.index}" name="h_total_price_" value="${total_price}">
					</c:if>

				</c:forEach>
			</tbody>
		</table>
		<div class="clear"></div>
	<br><br>
	<h1>2. 주문 고객</h1>
	<div class="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">이름</td>
					<td>
						${memberInfo.member_name}
						<input type="hidden" id="order_member_id" value="${memberInfo.member_id}" />
						<input type="hidden" id="order_member_name" value="${memberInfo.member_name}" />
				    </td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">휴대폰 번호</td>
					<td>
						${memberInfo.hp1}-${memberInfo.hp2}-${memberInfo.hp3}
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이메일</td>
					<td>
					  ${memberInfo.email1}@${memberInfo.email2}</td>
				  </tr>
			</tbody>
		</table>
	</div>
	<div class="clear"></div>
		<br> <br>
		<H1>3.배송지 정보</H1>
		<DIV class="detail_table">
			<table>
				<tbody>
					<tr class="dot_line">
					    <td class="fixed_join">배송방법</td>
					    <td>
					        <input type="radio" id="delivery_method" name="delivery_method" value="일반택배" checked>일반택배 &nbsp;&nbsp;&nbsp;
					    </td>
					</tr>
					<tr class="dot_line">
					    <td class="fixed_join">배송지 선택</td>
					    <td>
					        <input type="radio" name="delivery_place" onClick="setAddressEditable(false)" value="기본배송지" checked>기본배송지 &nbsp;&nbsp;&nbsp; 
					        <input type="radio" name="delivery_place" onClick="setAddressEditable(true)"  value="새로입력">새로입력 &nbsp;&nbsp;&nbsp; 
					    </td>
					</tr>
					<tr class="dot_line">
					    <td class="fixed_join">받으실 분</td>
					    <td>
					        <input id="receiver_name" name="receiver_name" type="text" size="40" 
					               value="${memberInfo.member_name }" readonly style="color: gray;"> 
					        <input type="hidden" id="h_orderer_name" name="h_orderer_name" value="${memberInfo.member_name }" /> 
					        <input type="hidden" id="h_receiver_name" name="h_receiver_name" value="${memberInfo.member_name }" />
					    </td>
					</tr>
					<tr class="dot_line">
					    <td class="fixed_join">휴대폰번호</td>
					    <td>
					        <select id="hp1" name="hp1" disabled style="color: gray;">
					            <option>없음</option>
					            <option value="010" selected>010</option>
					            <option value="011">011</option>
					            <option value="016">016</option>
					            <option value="017">017</option>
					            <option value="018">018</option>
					            <option value="019">019</option>
					        </select> 
					        - <input size="10px" type="text" id="hp2" name="hp2" 
					                value="${memberInfo.hp2 }" readonly style="color: gray;"> 
					        - <input size="10px" type="text" id="hp3" name="hp3" 
					                value="${memberInfo.hp3 }" readonly style="color: gray;"> 
					        
					        <input size="10px" type="hidden" id="h_hp1" name="h_hp1" value="${memberInfo.hp1 }" > 
					        <input size="10px" type="hidden" id="h_hp2" name="h_hp2" value="${memberInfo.hp2 }" >
					        <input size="10px" type="hidden" id="h_hp3" name="h_hp3" value="${memberInfo.hp3 }" >
					    </td>
					</tr>
					<tr class="dot_line">
					    <td class="fixed_join">주소</td>
					    <td>
					        <input type="text" id="zipcode" name="zipcode" size="10" 
					               value="${memberInfo.zipcode }" readonly style="color: gray;">
					        <a href="javascript:execDaumPostcode()" style="display:none;" id="searchAddressButton">우편번호검색</a> 
					        <br>
					        <p>
					            지번 주소:<br> 
					            <input type="text" id="roadAddress" name="roadAddress" size="50" 
					                   value="${memberInfo.roadAddress }" readonly style="color: gray;"><br>
					            <br> 도로명 주소: 
					            <input type="text" id="jibunAddress" name="jibunAddress" size="50" 
					                   value="${memberInfo.jibunAddress }" readonly style="color: gray;"><br>
					            <br> 나머지 주소: 
					            <input type="text" id="namujiAddress" name="namujiAddress" size="50" 
					                   value="${memberInfo.namujiAddress }" readonly style="color: gray;">
					            
							     <input type="hidden" id="h_zipcode"      name="h_zipcode"      value="${memberInfo.zipcode }" >
							     <input type="hidden" id="h_roadAddress"  name="h_roadAddress"  value="${memberInfo.roadAddress }" >
							     <input type="hidden" id="h_jibunAddress" name="h_jibunAddress" value="${memberInfo.jibunAddress }" >
							     <input type="hidden" id="h_namujiAddress" name="h_namujiAddress" value="${memberInfo.namujiAddress }" >
					        </p>
					    </td>
					</tr>

					<tr class="dot_line">
						<td class="fixed_join">배송 메시지</td>
						<td>
							<input id="delivery_message" name="delivery_message" type="text" size="50" 
							       placeholder="택배 기사님께 전달할 메시지를 남겨주세요." />
						</td>
					</tr>
					<tr class="dot_line">
						<td class="fixed_join">선물 포장</td>
						<td>
							<input type="radio" id="gift_wrapping" name="gift_wrapping" value="yes">예 &nbsp;&nbsp;&nbsp; 
							<input type="radio" id="gift_wrapping" name="gift_wrapping" checked value="no">아니요
						</td>
					</tr>
				</tbody>
			</table>
		</DIV>
		<input type="hidden" id="order_name" value="${memberInfo.member_name}" size="15" />
		<input type="hidden" id="order_member_id" value="${memberInfo.member_id}" />
		<input type="hidden" id="order_member_name" value="${memberInfo.member_name}" />
		<input type="hidden" id="order_phone" value="${memberInfo.hp1}-${memberInfo.hp2}-${memberInfo.hp3}" size="15" />
		<input type="hidden" id="order_email" value="${memberInfo.email1}@${memberInfo.email2}" size="15" />
		<div class="clear"></div>
		
		<table width=80% class="list_view" style="background: #ccffff">
			<tbody>
				<tr align=center class="fixed">
					<td class="fixed">총 상품수</td>
					<td>총 상품금액</td>
					<td></td>
					<td>총 배송비</td>
					<td></td>
					<td>총 할인 금액</td>
					<td></td>
					<td>최종 결제금액</td>
				</tr>
				<tr cellpadding="40" align="center">
				    <td>
				        <p id="p_totalNum">${total_order_goods_qty}개</p>
				        <input id="h_total_order_goods_qty" type="hidden" value="${total_order_goods_qty}" />
				    </td>
				    <td>
				    	<fmt:formatNumber value="${total_order_price}" type="number" var="total_order_price" />
				        <p id="p_totalPrice">${total_order_price}원</p>
				        <input id="h_totalPrice" type="hidden" value="${total_order_price}" />
				    </td>
				    <td>				    	
				        <img width="25" alt="" src="${pageContext.request.contextPath}/resources/image/plus.jpg">
				    </td>
				    <td>
				        <p id="p_totalDelivery">${total_delivery_price}원</p>
				        <input id="h_totalDelivery" type="hidden" value="${total_delivery_price}" />
				    </td>
				    <td>
				        <img width="25" alt="" src="${pageContext.request.contextPath}/resources/image/minus.jpg">
				    </td>
				    <td>
				    	<fmt:formatNumber value="${total_discount_price}" type="number" var="total_discount_price" />
				        <p id="p_totalSalesPrice">${total_discount_price}원</p>
				        <input id="h_total_sales_price" type="hidden" value="${total_discount_price}" />
				    </td>
				    <td>
				        <img width="25" alt="" src="${pageContext.request.contextPath}/resources/image/equal.jpg">
				    </td>
				    <td>
				        <p id="p_final_totalPrice">
				            <font size="12">${formatted_final_total_order_price}원</font>
				        </p>
				        <input id="h_final_total_Price" type="hidden" value="${formatted_final_total_order_price}" />
				    </td>
				</tr>
			</tbody>
		</table>
		<br><br><br>
	</form>
	
	<form id="orderForm" method="post" action="${contextPath}/mypage/myOrderDetail.do">
	    <input type="hidden" name="order_id" id="order_id">
	</form>

	
	<!-- 결제하기 버튼 -->
	<a href="javascript:requestPay();">
	    <img width="100" height="30" alt="" src="${contextPath}/resources/image/btn_gulje.jpg">
	</a>

	<!-- 쇼핑 계속 하기 -->
	<a href="${contextPath}/main/main.do">
	    <img width="100" height="30" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
	</a>
		
</body>
</html>
