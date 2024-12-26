<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
	var loopSearch = true;
	
	function keywordSearch() {
		if(!loopSearch) return;
		var value = document.frmSearch.searchWord.value;
		$.ajax({
			type: "get",
			async: true,
			url: "${contextPath}/goods/keywordSearch.do",
			dataType: "json",
			data: { keyword: value },
			success: function(data, textStatus) {
				displayResult(data);
			},
			error: function(data, textStatus) {
				alert("에러가 발생했습니다." + data);
			}
		});
	}
	
	function displayResult(jsonInfo) {
		var count = jsonInfo.keyword.length;
		if(count > 0) {
			var html = '';
			for(var i in jsonInfo.keyword) {
				html += "<a href=\"javascript:select('"+jsonInfo.keyword[i]+"')\">"+jsonInfo.keyword[i]+"</a><br/>";
			}
			var listView = document.getElementById("suggestList");
			listView.innerHTML = html;
			show('suggest');
		} else {
			hide('suggest');
		} 
	}
	
	function select(selectedKeyword) {
		document.frmSearch.searchWord.value=selectedKeyword;
		loopSearch = false;
		hide('suggest');
	}
		
	function show(elementId) {
		var element = document.getElementById(elementId);
		if(element) element.style.display = 'block';
	}
	
	function hide(elementId) {
		var element = document.getElementById(elementId);
		if(element) element.style.display = 'none';
	}
</script>

<c:if test="${sessionScope.isLogOn==true and not empty sessionScope.memberInfo }">
</c:if>
<c:if test="${message=='cancel_order'}">
<script>
window.onload = function() {
	alert("주문을 취소했습니다.");
}
</script>
</c:if>
</head>
<body>
<div id="logo">
	<a href="${contextPath}/main/main.do">
		<img width="176" height="80" alt="booktopia" src="${contextPath}/resources/image/bookplus.png">
		</a>
	</div>
	<div id="head_link">
		<ul>
		   <c:choose>
		   	<%-- 세션에  isLogOn변수 값이 true이고  세션에 조회된 memberVO객체가 저장되어 있으므로 로그인 된 화면을 보여주자. --%>
		     <c:when test="${sessionScope.isLogOn==true and not empty sessionScope.memberInfo }">
		       <li><p>반갑습니다. <b style="color: blue; font-size: 13px"> ${sessionScope.memberInfo.getMember_name()}</b> 님!</p></li>
			   <li><a href="${contextPath}/member/logout.do">로그아웃</a></li>
			   <li><a href="${contextPath}/mypage/myPageMain.do">마이페이지</a></li>
			   <li><a href="${contextPath}/cart/myCartList.do">장바구니</a></li>
			 </c:when>
			 <%--로그아웃된 화면을 보여주자. --%>
			 <c:otherwise>
			   <li><a href="${contextPath}/member/loginForm.do">로그인</a></li>
			   <li><a href="${contextPath}/member/memberForm.do">회원가입</a></li> 
			 </c:otherwise>
			</c:choose>
			   <li><a href="${contextPath}/board/boardList.do">게시판</a></li>
			  <%--세션에 isLogOn변수 값이 true이고 세션에 입력한 아이디(admin)로 조회된 MemberVO객체의 member_id변수값이 admin이라면?
			  	   관리자 화면 추가 
			   --%>
		      <c:if test="${sessionScope.isLogOn==true and sessionScope.memberInfo.member_id =='admin' }">  
		   	   <li class="no_line"><a href="${contextPath}/admin/member/adminMemberMain.do">관리자</a></li>
			  </c:if>
			  
		</ul>
	</div>
	<br>
<%--	<div
			style="display: flex; justify-content: right; align-items: center; gap: 10px; margin-top: 20px;">
			<input type="text" id="searchQuery" placeholder="실시간 도서정보 확인가능"
				style="width: 300px; padding: 10px; font-size: 16px; border: 2px solid #ccc; border-radius: 5px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">

			<button id="searchButton"
				style="padding: 10px 20px; font-size: 16px; background-color: #FF5733; color: white; border: none; border-radius: 5px; cursor: pointer; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">
				검색</button>
		</div>
 	<div id="search" >
		<form name="frmSearch" action="${contextPath}/goods/searchGoods.do" >
			<input name="searchWord" class="main_input" type="text" value="" onKeyUp="keywordSearch()"> 
			<input type="submit" name="search" class="btn1"  value="검 색" >
		</form>
	</div> --%>
   <div id="suggest">
        <div id="suggestList"></div>
   </div>
</body>
</html>
