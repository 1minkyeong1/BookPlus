<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	 isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>

<%
    // CSRF 방지를 위한 state 값 생성
    SecureRandom secureRandom = new SecureRandom();
    String state = new BigInteger(130, secureRandom).toString(32);
    
    // 생성된 state 값을 세션에 저장
    request.setAttribute("state", state);
%>


<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 페이지</title>
    <c:if test='${not empty message }'>
		<script>
			window.onload=function()
			{
			  result();
			}
			
			function result(){
				alert("아이디나  비밀번호가 틀립니다. 다시 로그인해주세요");
			}
		</script>
	</c:if>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center; 
            align-items: center;
        }
        .login-container {
            width: 100%;
            max-width: 50%;
            background: #ffffff;
            padding: 20px;
            margin: auto;
            border-radius: 5px;
        }
        .login-container h2 {
            margin-bottom: 20px;
            font-size: 24px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
        }
        .form-group input {
            width: 95%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        .btn-group {
        display: flex;
        justify-content: space-between;
        gap: 10px; /* 버튼 간격 추가 */
	    }
	    .btn-primary {
	        flex: 1;
	        text-align: center;
	        padding: 10px;
	        background-color: #007bff;
	        color: white;
	        border: none;
	        border-radius: 4px;
	        cursor: pointer;
	    }
	    .btn-secondary {
	        flex: 1;
	        text-align: center;
	        padding: 10px;
	        background-color: white; /* 회원가입 버튼 색상 */
	        color: #007bff;
	        border: none;
	        border-radius: 4px;
	        cursor: pointer;
	    }
        
        .btn-link {
	        flex: 1;
	        text-align: center;
	        padding: 10px;
	        color: #007bff;
	        border: 1px solid #007bff;
	        border-radius: 4px;
	        cursor: pointer;
    	}
    	
        .social-login {
            text-align: center;
            margin-top: 10px;
        }
        .social-login img {
            width: 40px;
            height: 40px;
            margin: 0 3px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>로그인</h2>
        <form action="${contextPath}/member/login.do" method="post">
            <div class="form-group">
                <label for="member_id">아이디</label>
                <input type="text" id="member_id" name="member_id" placeholder="아이디를 입력하세요">
            </div>
            <div class="form-group">
                <label for="member_pw">비밀번호</label>
                <input type="password" id="member_pw" name="member_pw" placeholder="비밀번호를 입력하세요">
            </div>
           <div class="btn-group">
			    <button type="submit" class="btn btn-primary">로그인</button>
			    <button onclick="location.href='${contextPath}/member/memberForm.do'" type="button" class="btn-secondary btn-link">회원가입</button>
			</div>

        </form>
        <br><br><hr>
        <div class="social-login">
            <h3>소셜 로그인</h3>
            <a href="https://nid.naver.com/oauth2.0/authorize?&client_id=JyvgOzKzRCnvAIRqpVXo&response_type=code&redirect_uri=http://localhost:8090/BookPlus/member/naver/callback&state=<%= URLEncoder.encode(state, "UTF-8") %>">
                <img src="${contextPath}/resources/image/naverlogin_button/btnG_아이콘원형.png" alt="네이버 로그인">
            </a>
            <a href="https://kauth.kakao.com/oauth/authorize?client_id=279e4cf54e1d0711b4748cd1ffb04c56&redirect_uri=http://localhost:8090/BookPlus/member/kakao/callback&response_type=code">
                <img src="${contextPath}/resources/image/kakao_login_simple/kakao_login_circle.png" alt="카카오 로그인">
            </a>
        </div>
        <%-- div class="links">
            <a href="#">아이디 찾기</a> | 
            <a href="#">비밀번호 찾기</a> | 
            <a href="${contextPath}/member/addMember.do">회원가입</a> | 
            <a href="#">고객 센터</a>
        </div> --%>
    </div>
</body>
</html>
