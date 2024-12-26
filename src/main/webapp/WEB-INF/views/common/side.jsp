<%@ page language="java" contentType="text/html; charset=utf-8" 
	pageEncoding="utf-8" 
	isELIgnored="false" 
%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% String contextPath = request.getContextPath(); %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/horoscope.css' />">
<nav>
<ul>
<c:choose>
	<%-- admin계정으로 로그인 했을 경우 메인화면의 왼쪽 사이드 영역 !! 관리자 메뉴 디자인 표시  --%>
	<c:when test="${sessionScope.side_menu=='admin_mode' }">
	   <li>
			<H3>주요기능</H3>
			<ul>
				<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
				
			</ul>
		</li>
	</c:when>
	<%-- 일반 계정으로 로그인 했을 경우 메인화면의 왼쪽 사이드 영역!! 일반 사용자를 위한 메뉴 항목 표시 --%>
	<c:when test="${sessionScope.side_menu=='my_page' }">
		<%-- <li>
			<h3>주문내역</h3>
			<ul>
				<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역/배송 조회</a></li>
			</ul>
		</li> --%>
		<li>
			<h3>정보내역</h3>
			<ul>
				<li><a href="${contextPath}/mypage/myInfoModify.do">회원정보관리</a></li>
				<li><a href="${contextPath}/mypage/deleteInfo.do">회원탈퇴</a></li>
			</ul>
		</li>
	</c:when>
	
	<%-- 그외 사용자 메뉴 표시 --%>	
	<c:otherwise>
		<li>
			<h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;국내외 도서</h3>
			<ul>
				<li><a href="${contextPath}/main/main.do?category=컴퓨터/모바일">컴퓨터/모바일</a></li>
				<li><a href="${contextPath}/main/main.do?category=경제/경영">경제/경영</a></li>
				<li><a href="${contextPath}/main/main.do?category=대학교재/과학">대학교재/과학</a></li>
				<li><a href="${contextPath}/main/main.do?category=자기계발/자격증">자기계발/자격증</a></li>
				<li><a href="${contextPath}/main/main.do?category=예술/대중문화">예술/대중문화</a></li>
				<li><a href="${contextPath}/main/main.do?category=에세이/인문학">에세이/인문학</a></li>
				<li><a href="${contextPath}/main/main.do?category=어린이/만화">어린이/만화</a></li>
			</ul>
		</li>
		<li>
			<h3>커뮤니티</h3>
			<ul>
				<li><a href="${contextPath}/board/boardList.do">자유게시판</a></li>
				<li><a href="${contextPath}/book/kakaobook.do">도서 검색</a></li>
				<li><a href="${contextPath}/API/weather/weather">날씨별 추천</a></li>
			</ul>
		</li>


	 </c:otherwise>
</c:choose>	
</ul>
</nav>
<div class="clear"></div>
<div class="horoscope-container">
    <h3>오늘의 별자리 운세</h3>
    <form action="${contextPath}/horoscope/view.do" method="get">
        <select id="sign" name="sign" required>
            <option value="">------ 별자리 선택 ------</option>
            <option value="aries">양자리 (3월21일~4월19일)</option>
            <option value="taurus">황소자리(4월20일~5월20일)</option>
            <option value="gemini">쌍둥이자리(5월21일~6월21일)</option>
            <option value="cancer">게자리(6월22일~7월22일)</option>
            <option value="leo">사자자리(7월23일~8월22일)</option>
            <option value="virgo">처녀자리(8월23일~9월22일)</option>
            <option value="libra">천칭자리(9월23일~10월22일)</option>
            <option value="scorpio">전갈자리(10월23일~11월22일)</option>
            <option value="sagittarius">궁수자리(11월23일~12월21일)</option>
            <option value="capricorn">염소자리(12월22일~1월19일)</option>
            <option value="aquarius">물병자리(1월20일~2월18일)</option>
            <option value="pisces">물고기자리(2월19일~3월20일)</option>
        </select>
        <button type="button" id="checkHoroscopeBtn">운세 보기</button>
    </form>

   <!-- 운세 결과 표시 영역 -->
    <div class="horoscope-description" id="horoscopeDescription"></div>
</div>

<div id="banner">
    <a href="#"><img width="190" height="104" src="${contextPath}/resources/image/call_center_logo.jpg"></a>
</div>
<div id="banner">
    <a href="#"><img width="190" height="69" src="${contextPath}/resources/image/QnA_logo.jpg"></a>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script type="text/javascript">
$(document).ready(function() {
    $('#checkHoroscopeBtn').click(function() {
        var sign = $('#sign').val();  // 선택된 별자리 값을 가져옴
       

        // 별자리가 선택되지 않은 경우
        if (sign === "") {
            alert("별자리를 선택해주세요.");
            return;
        }
            // AJAX 요청 보내기
            $.ajax({
                url: 'https://horoscope-astrology.p.rapidapi.com/horoscope', // RapidAPI 엔드포인트 URL
                type: 'GET',
                data: {
                    day: 'today', // 오늘의 운세를 가져옵니다
                    sunsign: sign // 선택된 별자리 정보 전달
                },
                headers: {
                    'x-rapidapi-host': 'horoscope-astrology.p.rapidapi.com', // RapidAPI 호스트
                    'x-rapidapi-key': '9c5819e8a9msh27cec47277983a8p15ee97jsn0f8fb0fd3a60' // 본인의 RapidAPI 키로 교체
                },
                success: function(response) {
                    // 운세가 정상적으로 반환되었으면 운세 내용 표시
                    if (response) {
                        translateText(response.horoscope); // 응답에서 운세 내용 가져오기
                    } else {
                        $('#horoscopeDescription').html("운세를 가져올 수 없습니다.");
                    }
                },
                error: function() {
                    $('#horoscopeDescription').html("운세를 가져오는 중 오류가 발생했습니다.");
                }
            });
       
    // 번역 요청 함수
        	
    function translateText(text) {
        $.ajax({
            url: 'https://translate.googleapis.com/translate_a/single',  // 구글 번역 API URL
            type: 'GET',
            data: {
                client: 'gtx',  // 구글 번역 API 기본 클라이언트
                sl: 'en',  // 원본 언어 (영어)
                tl: 'ko',  // 번역할 언어 (한국어)
                dt: 't',  // 번역된 텍스트를 반환
                q: text    // 번역할 텍스트
            },
            success: function(translation) {
                // 번역 결과 표시
                if (translation && translation[0] && translation[0][0]) {
                    $('#horoscopeDescription').html(translation[0][0][0]);  // 번역된 텍스트 표시
                } else {
                    $('#horoscopeDescription').html("번역 결과를 가져올 수 없습니다.");
                }
            },
            error: function() {
                $('#horoscopeDescription').html("번역 중 오류가 발생했습니다.");
            }
        });
    }
    });
});
</script>

</html>
