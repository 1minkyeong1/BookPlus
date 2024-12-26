<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
request.setCharacterEncoding("UTF-8");
%>
	<!-- jQuery 라이브러리 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${contextPath}/resources/jquery/jquery.easing.1.3.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/stickysidebar.jquery.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/basic-jquery-slider.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/tabs.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/carousel.js" type="text/javascript"></script>


 <div class="main_book"  id="goodsContainer">
	<!-- 조회된 베스트 셀러 15개를 메인화면 중앙에 표시 합니다.-->
	<c:forEach var="item" items="${goodsList }">  
	   
		<div class="book">
		
			<!-- 이미지 클릭시 상품 상세페이지를 요청합니다. -->
			<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
				<img class="link"  src="${contextPath}/resources/image/1px.gif"> 
				<%-- <img class="link"  src="${item.filename}">  --%>
			</a> 
				<!-- 원본이미지를 썸네일 이미지로 보여 주기 위해  서버페이지 요청시  상품번호와 상품이미지명 전달  -->
				<img width="121" height="154" src="${item.goods_fileName}">

			<div class="title">${item.goods_title }</div>
			<div class="price">
		  	   <fmt:formatNumber  value="${item.goods_price}" type="number" var="goods_price" />
		          ${goods_price}원
			</div>
		</div>
  </c:forEach>
</div>
<!-- more 버튼 -->
<div id="moreButton" style="text-align: center;">
    <button id="loadMore" onclick="loadMoreGoods()" class="more-button">more</button>
</div>

<style>
	#moreButton {
		margin: 50px auto;
        width: 100%; /* 너비 */
        height: 50px; /* 높이 */
		display: inline-block;
		
	}
    /* 버튼 크기 및 스타일 설정 */
    .more-button {
        width: 100%; /* 너비 */
        height: 50px; /* 높이 */
        background-color: #f5f5f5; /* 배경색 */
        border: 1px solid #ccc; /* 테두리 */
        border-radius: 4px; /* 모서리 둥글게 */
        cursor: pointer; /* 커서 포인터 */
        font-size: 16px; /* 글자 크기 */
        text-align: center; /* 텍스트 정렬 */
        vertical-align: middle; /* 텍스트 세로 정렬 */
        padding: 0; /* 내부 여백 제거 */
        display: inline-block; /* 크기 설정을 위해 inline-block 사용 */
    }

    /* 호버 시 스타일 */
    .more-button:hover {
        background-color: #e0e0e0; /* 호버 시 배경색 */
        border-color: #999; /* 호버 시 테두리색 */
    }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	 /* $(document).ready(function() {
		console.log("updating");
		// 페이지 로딩 후 DB 갱신을 위한 AJAX 요청
		$.ajax({
		    url: "${contextPath}/goods/updateDatabase",
		    type: "POST",
		    dataType: "json",
		    success: function(response) {
		        console.log(response.message);
		    },
		    error: function(xhr, status, error) {	
		        console.error("DB 갱신 실패:", error);
		    }
		});
	});  */
    let currentPage = 1; // 현재 페이지 번호
    const contextPath = "${contextPath}";

    
    function loadMoreGoods() {
    	console.log(contextPath);
    	
        currentPage++; // 페이지 증가

        // AJAX 요청으로 다음 페이지 데이터를 불러옴
        $.ajax({
            url: contextPath + "/main/main.do?category=${selectedCategory}", // 컨트롤러 URL
            type: "GET",
            data: { page: currentPage }, // 요청 데이터: 페이지 번호
            success: function (response) {
                // 서버에서 반환된 HTML 파싱
                let parser = new DOMParser();
                let doc = parser.parseFromString(response, 'text/html');
                let newBooks = doc.querySelector('#goodsContainer').innerHTML;

                // 기존 데이터에 새로운 데이터 추가
                $('#goodsContainer').append(newBooks);

                // 데이터 개수가 15개 미만이면 더 이상 불러올 데이터가 없음
                if (doc.querySelectorAll('.book').length < 12) {
                    $('#moreButton').html('더 이상 상품이 없습니다.');
                }
            },
            error: function (xhr, status, error) {
                console.error('Error:', error); // 에러 출력
            }
        });
    }
</script>
