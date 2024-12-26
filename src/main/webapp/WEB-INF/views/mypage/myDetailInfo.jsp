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
<script>
function execDaumPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
			var fullRoadAddr = data.roadAddress;
			var extraRoadAddr = '';
			if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)) extraRoadAddr += data.bname;
			if(data.buildingName !== '' && data.apartment === 'Y') {
				extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
			}
			if(extraRoadAddr !== '') fullRoadAddr += ' (' + extraRoadAddr + ')';

			document.getElementById('zipcode').value = data.zonecode;
			document.getElementById('roadAddress').value = fullRoadAddr;
			document.getElementById('jibunAddress').value = data.jibunAddress;

			if(data.autoRoadAddress) {
				var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
				document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
			} else if(data.autoJibunAddress) {
				var expJibunAddr = data.autoJibunAddress;
				document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
			} else {
				document.getElementById('guide').innerHTML = '';
			}
		}
	}).open();
}

// 페이지 로드 시 select box 초기화
window.onload=function() {
	selectBoxInit();
}

function selectBoxInit(){
	var tel1='${memberInfo.tel1}';
	var hp1='${memberInfo.hp1}';
	var selTel1 = document.getElementById('tel1');
	var selHp1 = document.getElementById('hp1');
	var optionTel1 = selTel1.options;
	var optionHp1 = selHp1.options;
	var val;
	for(var i=0; i<optionTel1.length; i++){
		val = optionTel1[i].value;
		if(tel1 == val){
			optionTel1[i].selected= true;
			break;
		}
	}  
	for(var i=0; i<optionHp1.length; i++){
		val = optionHp1[i].value;
		if(hp1 == val){
			optionHp1[i].selected= true;
			break;
		}
	}
}

function fn_modify_member_info(attribute){
	var frm_mod_member=document.frm_mod_member;
	var value;
	if(attribute=='member_pw'){
		value=frm_mod_member.member_pw.value;
	}else if(attribute=='member_gender'){
		var member_gender=frm_mod_member.member_gender;
		for(var i=0; i<member_gender.length;i++){
			if(member_gender[i].checked){
				value=member_gender[i].value;
				break;
			}
		}
	}else if(attribute=='member_birth'){
		var member_birth_y=frm_mod_member.member_birth_y;
		var member_birth_m=frm_mod_member.member_birth_m;
		var member_birth_d=frm_mod_member.member_birth_d;
		var member_birth_gn=frm_mod_member.member_birth_gn;
		for(var i=0; i<member_birth_y.length;i++){
			if(member_birth_y[i].selected){
				value_y=member_birth_y[i].value;break;
			} 
		}
		for(var i=0; i<member_birth_m.length;i++){
			if(member_birth_m[i].selected){
				value_m=member_birth_m[i].value;break;
			} 
		}
		for(var i=0; i<member_birth_d.length;i++){
			if(member_birth_d[i].selected){
				value_d=member_birth_d[i].value;break;
			}
		}
		for(var i=0; i<member_birth_gn.length;i++){
			if(member_birth_gn[i].checked){
				value_gn=member_birth_gn[i].value;break;
			}
		}
		value=+value_y+","+value_m+","+value_d+","+value_gn;
	}else if(attribute=='tel'){
		var tel1=frm_mod_member.tel1;
		var tel2=frm_mod_member.tel2;
		var tel3=frm_mod_member.tel3;
		for(var i=0; i<tel1.length;i++){
			if(tel1[i].selected){
				value_tel1=tel1[i].value;break;
			}
		}
		value_tel2=tel2.value;
		value_tel3=tel3.value;
		value=value_tel1+","+value_tel2+", "+value_tel3;
	}else if(attribute=='hp'){
		var hp1=frm_mod_member.hp1;
		var hp2=frm_mod_member.hp2;
		var hp3=frm_mod_member.hp3;
		var smssts_yn=frm_mod_member.smssts_yn;
		for(var i=0; i<hp1.length;i++){
			if(hp1[i].selected){
				value_hp1=hp1[i].value;break;
			} 
		}
		value_hp2=hp2.value;
		value_hp3=hp3.value;
		value_smssts_yn=smssts_yn.checked;
		value=value_hp1+","+value_hp2+", "+value_hp3+","+value_smssts_yn;
	}else if(attribute=='email'){
		var email1=frm_mod_member.email1;
		var email2=frm_mod_member.email2;
		var emailsts_yn=frm_mod_member.emailsts_yn;
		value_email1=email1.value;
		value_email2=email2.value;
		value_emailsts_yn=emailsts_yn.checked;
		value=value_email1+","+value_email2+","+value_emailsts_yn;
	}else if(attribute=='address'){
		var zipcode=frm_mod_member.zipcode;
		var roadAddress=frm_mod_member.roadAddress;
		var jibunAddress=frm_mod_member.jibunAddress;
		var namujiAddress=frm_mod_member.namujiAddress;
		value_zipcode=zipcode.value;
		value_roadAddress=roadAddress.value;
		value_jibunAddress=jibunAddress.value;
		value_namujiAddress=namujiAddress.value;
		value=value_zipcode+","+value_roadAddress+","+value_jibunAddress+","+value_namujiAddress;
	}
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/mypage/modifyMyInfo.do",
		data : {attribute:attribute,value:value},
		success : function(data, textStatus) {
			if(data.trim()=='mod_success'){
				alert("회원 정보를 수정했습니다.");
			}else if(data.trim()=='failed'){
				alert("다시 시도해 주세요.");	
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다."+data);
		}
	});
}
</script>
</head>
<body>
<h3>내 상세 정보</h3>
<form name="frm_mod_member">
<div id="detail_table">
	<table>
		<tbody>
			<tr class="dot_line">
				<td class="fixed_join">아이디</td>
				<td><input name="member_id" type="text" size="20" value="${sessionScope.memberInfo.member_id}" disabled/></td>
				<td></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed_join">비밀번호</td>
				<td><input name="member_pw" type="password" size="20" value="${memberInfo.member_pw}"/></td>
				<td><input type="button" value="수정하기" onClick="fn_modify_member_info('member_pw')"/></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed_join">이름</td>
				<td><input name="member_name" type="text" size="20" value="${memberInfo.member_name}" disabled/></td>
				<td></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed_join">성별</td>
				<td>
				  <c:choose>
				    <c:when test="${memberInfo.member_gender =='101'}">
				      <input type="radio" name="member_gender" value="102"/>여성 <span style="padding-left:30px"></span>
				      <input type="radio" name="member_gender" value="101" checked/>남성
				    </c:when>
				    <c:otherwise>
				      <input type="radio" name="member_gender" value="102" checked/>여성 <span style="padding-left:30px"></span>
				      <input type="radio" name="member_gender" value="101"/>남성
				    </c:otherwise>
				  </c:choose>
				</td>
				<td><input type="button" value="수정하기" onClick="fn_modify_member_info('member_gender')"/></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed_join">법정생년월일</td>
				<td>
				   <select name="member_birth_y">
				     <c:forEach var="i" begin="1" end="100">
				       <c:choose>
				         <c:when test="${memberInfo.member_birth_y==1920+i}">
						   <option value="${1920+i}" selected>${1920+i}</option>
						 </c:when>
						 <c:otherwise>
						   <option value="${1920+i}">${1920+i}</option>
						 </c:otherwise>
					   </c:choose>
				     </c:forEach>
				   </select>년 
				   <select name="member_birth_m">
					 <c:forEach var="i" begin="1" end="12">
					   <c:choose>
					     <c:when test="${memberInfo.member_birth_m==i}">
						   <option value="${i}" selected>${i}</option>
						 </c:when>
						 <c:otherwise>
						   <option value="${i}">${i}</option>
						 </c:otherwise>
					   </c:choose>
					 </c:forEach>
				   </select>월 
				   <select name="member_birth_d">
					 <c:forEach var="i" begin="1" end="31">
					   <c:choose>
					     <c:when test="${memberInfo.member_birth_d==i}">
						   <option value="${i}" selected>${i}</option>
						 </c:when>
						 <c:otherwise>
						   <option value="${i}">${i}</option>
						 </c:otherwise>
					   </c:choose>
					 </c:forEach>
				   </select>일 <span style="padding-left:50px"></span>
				   <c:choose>
				     <c:when test="${memberInfo.member_birth_gn=='2'}">
					   <input type="radio" name="member_birth_gn" value="2" checked/>양력
					   <span style="padding-left:20px"></span>
					   <input type="radio" name="member_birth_gn" value="1"/>음력
					 </c:when>
					 <c:otherwise>
					   <input type="radio" name="member_birth_gn" value="2"/>양력
					   <input type="radio" name="member_birth_gn" value="1" checked/>음력
					 </c:otherwise>
				   </c:choose>
				</td>
				<td><input type="button" value="수정하기" onClick="fn_modify_member_info('member_birth')"/></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed_join">전화번호</td>
				<td>
				  <select name="tel1" id="tel1">
					<option value="00">없음</option>
					<option value="02">02</option>
					<option value="031">031</option>
					<!-- 기타번호 옵션 생략 가능 -->
				  </select> - <input type="text" size=4 name="tel2" value="${memberInfo.tel2}"> - <input type="text" size=4 name="tel3" value="${memberInfo.tel3}">
				</td>
				<td><input type="button" value="수정하기" onClick="fn_modify_member_info('tel')"/></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed_join">휴대폰번호</td>
				<td>
				  <select name="hp1" id="hp1">
					<option>없음</option>
					<option value="010">010</option>
					<option value="011">011</option>
					<option value="016">016</option>
					<option value="017">017</option>
					<option value="018">018</option>
					<option value="019">019</option>
				  </select> - <input type="text" name="hp2" size=4 value="${memberInfo.hp2}"> - <input type="text" name="hp3" size=4 value="${memberInfo.hp3}"><br><br>
				  <c:choose>
				    <c:when test="${memberInfo.smssts_yn=='true'}">
				      <input type="checkbox" name="smssts_yn" value="Y" checked/> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
					</c:when>
					<c:otherwise>
					  <input type="checkbox" name="smssts_yn" value="N"/> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
					</c:otherwise>
				  </c:choose>
				</td>
				<td><input type="button" value="수정하기" onClick="fn_modify_member_info('hp')"/></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed_join">이메일(e-mail)</td>
				<td>
				  <input type="text" name="email1" size=10 value="${memberInfo.email1}"/> @ <input type="text" size=10 name="email2" value="${memberInfo.email2}"/> 
				  <select name="select_email2" title="직접입력">
					<option value="non">직접입력</option>
					<option value="hanmail.net">hanmail.net</option>
					<option value="naver.com">naver.com</option>
					<!-- 기타 이메일 옵션 생략 가능 -->
				  </select><br><br>
				  <c:choose> 
				    <c:when test="${memberInfo.emailsts_yn=='true'}">
				      <input type="checkbox" name="emailsts_yn" value="Y" checked/> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
					</c:when>
					<c:otherwise>
					  <input type="checkbox" name="emailsts_yn" value="N"/> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
					</c:otherwise>
				  </c:choose>
				</td>
				<td><input type="button" value="수정하기" onClick="fn_modify_member_info('email')"/></td>
			</tr>
			<tr class="dot_line">
				<td class="fixed_join">주소</td>
				<td>
				  <input type="text" id="zipcode" name="zipcode" size=5 value="${memberInfo.zipcode}"> <a href="javascript:execDaumPostcode()">우편번호검색</a><br>
				  <p>지번 주소:<br><input type="text" id="roadAddress" name="roadAddress" size="50" value="${memberInfo.roadAddress}"><br><br>
				  도로명 주소: <input type="text" id="jibunAddress" name="jibunAddress" size="50" value="${memberInfo.jibunAddress}"><br><br>
				  나머지 주소: <input type="text" name="namujiAddress" size="50" value="${memberInfo.namujiAddress}"/></p>
				</td>
				<td><input type="button" value="수정하기" onClick="fn_modify_member_info('address')"/></td>
			</tr>
		</tbody>
	</table>
</div>
<div class="clear">
<br><br>
<table align="center">
<tr>
	<td>
		<input type="hidden" name="command" value="modify_my_info"/>
		<input name="btn_cancel_member" type="button" value="수정 취소">
	</td>
</tr>
</table>
</div>
<input type="hidden" name="h_tel1" value="${memberInfo.tel1}"/>
<input type="hidden" name="h_hp1" value="${memberInfo.hp1}"/>		
</form>	
</body>
</html>
