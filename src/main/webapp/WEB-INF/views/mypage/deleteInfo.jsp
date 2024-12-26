<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<style>
/* deleteMember.css */

/* 전체 컨테이너 스타일 */
#delete-member-container {
	font-family: Arial, sans-serif;
	background-color: #f4f6f9;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

/* 폼 컨테이너 스타일 */
.delete-member-form {
	background-color: #ffffff;
	padding: 40px;
	border-radius: 8px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	text-align: center;
	max-width: 400px;
	width: 100%;
}

/* 제목 스타일 */
#delete-member-title {
	font-size: 1.5em;
	margin-bottom: 30px;
	color: #333333;
}

/* 버튼 그룹 스타일 */
.button-group {
	display: flex;
	justify-content: center;
	gap: 10px;
}

/* 탈퇴 버튼 스타일 */
#btn-delete.btn-delete {
	background-color: #e74c3c;
	color: #ffffff;
	border: none;
	padding: 12px 24px;
	border-radius: 4px;
	font-size: 1em;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

#btn-delete.btn-delete:hover {
	background-color: #c0392b;
}

/* 취소 버튼 스타일 */
#btn-cancel.btn-cancel {
	color: #3498db;
	text-decoration: none;
	font-size: 1em;
	padding: 12px 24px;
	border: 2px solid #3498db;
	border-radius: 4px;
	transition: background-color 0.3s ease, color 0.3s ease;
}

#btn-cancel.btn-cancel:hover {
	background-color: #3498db;
	color: #ffffff;
}
</style>
<script type="text/javascript">
	function fn_delete_member(member_id, del_yn) {
		var frm_mod_member = document.getElementById("frm_mod_member");
		var i_member_id = document.createElement("input");
		var i_del_yn = document.createElement("input");

		i_member_id.name = "member_id";
		i_del_yn.name = "del_yn";
		i_member_id.type = "hidden";
		i_del_yn.type = "hidden";
		i_member_id.value = member_id;
		i_del_yn.value = del_yn;

		frm_mod_member.appendChild(i_member_id);
		frm_mod_member.appendChild(i_del_yn);
		frm_mod_member.method = "post";
		frm_mod_member.action = "${contextPath}/admin/member/deleteInfo.do";
		frm_mod_member.submit();
	}
</script>
</head>
<body>
	<div id="delete-member-container">
		<form id="frm_mod_member" class="delete-member-form">
			<h1 id="delete-member-title">정말로 회원 탈퇴를 하시겠습니까?</h1>
			<div class="button-group">
				<button type="button" id="btn-delete" class="btn btn-delete"
					onClick="fn_delete_member('${memberInfo.member_id}','Y')">탈퇴하기</button>
				<a href="${contextPath}/mypage/myPageMain.do" id="btn-cancel"
					class="btn btn-cancel">취소</a>
			</div>
		</form>
	</div>
</body>
</html>
