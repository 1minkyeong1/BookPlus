<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />


<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>

function validateForm() {
    // 아이디 확인
    var memberId = document.getElementById("_member_id");
    if (memberId && memberId.value.trim() === "") {
        alert("아이디를 입력하세요.");
        memberId.focus();
        return false;
    }

    // 비밀번호 확인
    var password = document.getElementsByName("member_pw")[0];
    if (password && password.value.trim() === "") {
        alert("비밀번호를 입력하세요.");
        password.focus();
        return false;
    }

    // 이름 확인
    var memberName = document.getElementsByName("member_name")[0];
    if (memberName && memberName.value.trim() === "") {
        alert("이름을 입력하세요.");
        memberName.focus();
        return false;
    }

    // 휴대폰 번호 확인
    var phone1 = document.getElementsByName("hp1")[0];
    var phone2 = document.getElementsByName("hp2")[0];
    var phone3 = document.getElementsByName("hp3")[0];
    if (phone1 && phone2 && phone3) {
        if (phone1.value.trim() === "" || phone2.value.trim() === "" || phone3.value.trim() === "") {
            alert("휴대폰 번호를 입력하세요.");
            phone1.focus();
            return false;
        }
        if (isNaN(phone2.value) || isNaN(phone3.value)) {
            alert("휴대폰 번호는 숫자만 입력해야 합니다.");
            phone2.focus();
            return false;
        }
    }

    // 이메일 확인
    var email1 = document.getElementsByName("email1")[0];
    var email2 = document.getElementsByName("email2")[0];
    if (email1 && email2) {
        if (email1.value.trim() === "" || email2.value.trim() === "") {
            alert("이메일을 입력하세요.");
            email1.focus();
            return false;
        }
    }

    // 주소 확인
    var roadAddress = document.getElementById("roadAddress");
    if (roadAddress && roadAddress.value.trim() === "") {
        alert("도로명 주소를 입력하세요.");
        roadAddress.focus();
        return false;
    }
    
    const smsCheckbox = document.getElementById('smsstsCheckbox');
    const smsHidden = document.getElementById('smsHidden');
    const emailCheckbox = document.getElementById('emailstsCheckbox');
    const emailHidden = document.getElementById('emailHidden');

    // SMS 수신 동의 여부
    if (smsCheckbox.checked) {
        smsHidden.disabled = true; // hidden input 비활성화
    } else {
        smsHidden.disabled = false; // hidden input 활성화
    }

    // 이메일 수신 동의 여부
    if (emailCheckbox.checked) {
        emailHidden.disabled = true; // hidden input 비활성화
    } else {
        emailHidden.disabled = false; // hidden input 활성화
    }
    
    // 모든 유효성 검사를 통과하면 true 반환
    return true;
}

function execDaumPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
			var fullRoadAddr = data.roadAddress;
			var extraRoadAddr = '';
			if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) extraRoadAddr += data.bname;
			if (data.buildingName !== '' && data.apartment === 'Y') {
				extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
			}
			if (extraRoadAddr !== '') fullRoadAddr += ' (' + extraRoadAddr + ')';

			document.getElementById('zipcode').value = data.zonecode;
			document.getElementById('roadAddress').value = fullRoadAddr;
			document.getElementById('jibunAddress').value = data.jibunAddress;

	      // 법정동명이 있을 경우 추가 (법정리는 제외)
	      if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
	        extraRoadAddr += data.bname;
	      }
	      // 건물명이 있고 공동주택일 경우 추가
	      if (data.buildingName !== '' && data.apartment === 'Y') {
	        extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	      }
	      // 참고 항목이 있을 경우 추가
	      if (extraRoadAddr !== '') {
	        extraRoadAddr = ' (' + extraRoadAddr + ')';
	      }
	      
	      // 주소 정보를 해당 필드에 입력
	      document.getElementById('zipcode').value = data.zonecode;
	      document.getElementById('roadAddress').value = fullRoadAddr;
	      document.getElementById('jibunAddress').value = data.jibunAddress;
	      
	      if (fullRoadAddr !== '') {
	        fullRoadAddr += extraRoadAddr;
	      }

	      // 예상 주소 표시
	      var guideElement = document.getElementById('guide');

	      if (data.autoRoadAddress) {
	        var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
	        guideElement.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
	        guideElement.style.display = 'block';
	      } else if (data.autoJibunAddress) {
	        var expJibunAddr = data.autoJibunAddress;
	        guideElement.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
	        guideElement.style.display = 'block';
	      } else {
	        guideElement.innerHTML = '';
	        guideElement.style.display = 'none';
	      }
	    }
	  }).open(); // 팝업 창 열기 (기본 동작으로 닫힘)
}

//아이디 중복 확인
function fn_overlapped(){
	
    var _id=$("#_member_id").val();
    
    if(_id==''){
   	 alert("ID를 입력하세요");
   	 return;
    }
    
    $.ajax({
       type:"post",
       async:false,  
       url:"${contextPath}/member/overlapped.do", //회원가입 시  입력한 아이디가 DB에 저장되어 있는지 중복확인 요청!
       dataType:"text",
       data: {id:_id},
       success:function (data,textStatus){
          if(data=='false'){
       	    alert("사용할 수 있는 ID입니다.");
       	    $('#btnOverlapped').prop("disabled", true);
       	    $('#_member_id').prop("disabled", true);
       	    $('#member_id').val(_id);
          }else{
        	  alert("사용할 수 없는 ID입니다.");
          }
       },
       error:function(data,textStatus){
          alert("에러가 발생했습니다.");
       },
       complete:function(data,textStatus){
          //alert("작업을완료 했습니다");
       }
    });  //end ajax	 
 }	
 
 
// 이메일 선택한 option 값을 email2Input 필드에 넣는 함수
function updateEmailDomain() {
  // select 요소와 input 요소 가져오기
  var select = document.getElementById('email2Select');
  var emailInput = document.getElementById('email2Input');

  // 선택한 옵션 값을 input 요소에 설정
  emailInput.value = select.value;
}
 
// 선택 체크박스 미 클릭시 DB 등록 가능하게 설정  
// 제출 전에 체크박스 값 설정
function prepareFormData() {
    const smsCheckbox = document.getElementById('smsstsCheckbox');
    const smsHidden = document.getElementById('smsHidden');
    const emailCheckbox = document.getElementById('emailstsCheckbox');
    const emailHidden = document.getElementById('emailHidden');

    // SMS 수신 동의 여부
    if (smsCheckbox.checked) {
        smsHidden.disabled = true; // hidden input 비활성화
    } else {
        smsHidden.disabled = false; // hidden input 활성화
    }

    // 이메일 수신 동의 여부
    if (emailCheckbox.checked) {
        emailHidden.disabled = true; // hidden input 비활성화
    } else {
        emailHidden.disabled = false; // hidden input 활성화
    }
}

function fn_overlapped(){
	var _id=$("#_member_id").val();
	if(_id==''){
		alert("ID를 입력하세요");
		return;
	}
	$.ajax({
		type:"post",
		async:false,
		url:"${contextPath}/member/overlapped.do",
		dataType:"text",
		data: {id:_id},
		success:function(data,textStatus){
			if(data=='false'){
				alert("사용할 수 있는 ID입니다.");
				$('#btnOverlapped').prop("disabled", true);
				$('#_member_id').prop("disabled", true);
				$('#member_id').val(_id);
			}else{
				alert("사용할 수 없는 ID입니다.");
				// 입력 필드 초기화
				$('#_member_id').val('').focus();
			}
		},
		error:function(data,textStatus){
			alert("에러가 발생했습니다.");
		}
	});
}

function updateEmailDomain() {
	var select = document.getElementById('email2Select');
	var emailInput = document.getElementById('email2Input');
	emailInput.value = select.value;
}

</script>
</head>
<body>
<%
    JSONObject userProfile = (JSONObject) request.getAttribute("userProfile");
%>
	<h3>필수입력사항</h3>
	<form action="${contextPath}/member/addMember.do" method="post" onsubmit="return validateForm();">
	<input type="hidden" name="socialProvider" value="${requestScope.socialProvider}"> 	
	<div id="detail_table">
		<table>
			<tbody>
				<c:choose>
		            <c:when test="${not empty requestScope.id}">	
						  <input type="hidden" name="apiId" value="${requestScope.id }" /> 
						  <input type="hidden" name="member_id" value="${requestScope.id }"/>
						
		            </c:when>
		            <c:otherwise>
						<tr class="dot_line">
							<td class="fixed_join">아이디</td>
							<td>
							  <input type="text" name="_member_id"  id="_member_id"  size="20" />
							  <input type="hidden" name="member_id"  id="member_id" value=""/>
							  <input type="button"  id="btnOverlapped" value="중복체크" onClick="fn_overlapped()" />
							</td>
						</tr>
		            </c:otherwise>
		        </c:choose>
				<tr class="dot_line">
					<td class="fixed_join">비밀번호</td>
					<td><input id="member_pw" name="member_pw" type="password" size="20" /></td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이름</td>
				<c:choose>
					<c:when test="${not empty requestScope.name}">	
						<td><input type="text" name="member_name" value="${requestScope.name}"  readonly style="color:gray;"/></td> 
		            </c:when>
		            <c:otherwise>
						<td><input id="member_name" type="text" name="member_name" size="20" /></td>
		            </c:otherwise>
		        </c:choose>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">성별</td>
					 <td>
				        <c:choose>
				            <c:when test="${not empty requestScope.gender}">
				                <input type="radio" id="member_gender" name="member_gender" value="female" 
				                       <c:if test="${requestScope.gender == '102'}">checked</c:if> disabled />여성
				                <span style="padding-left:120px"></span>
				                <input type="radio" id="member_gender" name="member_gender" value="male" 
				                       <c:if test="${requestScope.gender == '101'}">checked</c:if> disabled />남성
				                <input type="hidden" id="member_gender" name="member_gender" value="${requestScope.gender}" />
				            </c:when>
				
				            <c:otherwise>
				                <input type="radio" name="member_gender" value="female" />여성
				                <span style="padding-left:120px"></span>
				                <input type="radio" name="member_gender" value="male" checked />남성
				            </c:otherwise>
				        </c:choose>
				    </td>
				</tr>
				<tr class="dot_line">
				    <td class="fixed_join">법정생년월일</td>
				    <td>
				        <!-- 연도 -->
				        <c:choose>
				            <c:when test="${not empty requestScope.birthyear}">
				                <input type="text" name="member_birth_y" id="member_birth_y"
				                       value="${requestScope.birthyear}" 
				                       readonly 
				                       style="font-size:12px; color:gray; width:50px;" />년
				            </c:when>
				            <c:otherwise>
				                <select name="member_birth_y", style="font-size:12px; color:gray; width:60px;">
				                    <c:forEach var="year" begin="1920" end="2020">
				                        <option value="${year}" 
				                                <c:if test="${year == 1980}">selected</c:if>>${year}</option>
				                    </c:forEach>
				                </select>년
				            </c:otherwise>
				        </c:choose>
				
				        <!-- 월 -->
				        <c:choose>
				            <c:when test="${not empty requestScope.birthday}">
				                <input type="text" name="member_birth_m" id="member_birth_m"
				                       value="${requestScope.birthday.substring(0, 2)}" 
				                       readonly 
				                       style="font-size:12px; color:gray; width:30px;" />월
				            </c:when>
				            <c:otherwise>
				                <select name="member_birth_m" style="font-size:12px; color:gray; width:40px;">
				                    <c:forEach var="month" begin="1" end="12">
				                        <option value="${month}" 
				                                <c:if test="${month == 5}">selected</c:if>>${month}</option>
				                    </c:forEach>
				                </select>월
				            </c:otherwise>
				        </c:choose>
				
				        <!-- 일 -->
				        <c:choose>
				            <c:when test="${not empty requestScope.birthday}">
				                <input type="text" name="member_birth_d" id="member_birth_d"
				                       value="${requestScope.birthday.substring(2, 4)}" 
				                       readonly 
				                       style="font-size:12px; color:gray; width:30px;" />일
				            </c:when>
				            <c:otherwise>
				                <select name="member_birth_d" style="font-size:12px; color:gray; width:40px;">
				                    <c:forEach var="day" begin="1" end="31">
				                        <option value="${day}" 
				                                <c:if test="${day == 10}">selected</c:if>>${day}</option>
				                    </c:forEach>
				                </select>일
				            </c:otherwise>
				        </c:choose>
				
				        <span style="padding-left:20px;"></span>
				
				        <!-- 양력/음력 -->
				        <c:choose>
				            <c:when test="${not empty requestScope.birth_gn}">
				                <input type="radio" name="member_birth_gn" id="member_birth_gn"
				                       value="2" 
				                       <c:if test="${requestScope.birth_gn == '2'}">checked</c:if> 
				                       disabled 
				                       style="font-size:12px; color:gray;" />양력
				                <span style="padding-left:20px;"></span>
				                <input type="radio" name="member_birth_gn" id="member_birth_gn"
				                       value="1" 
				                       <c:if test="${request.birth_gn == '1'}">checked</c:if> 
				                       disabled 
				                       style="font-size:12px; color:gray;" />음력
				            </c:when>
				            <c:otherwise>
				                <input type="radio" name="member_birth_gn" value="2" checked 
				                       style="font-size:12px; color:gray;" />양력
				                <span style="padding-left:20px;"></span>
				                <input type="radio" name="member_birth_gn" value="1" 
				                       style="font-size:12px; color:gray;" />음력
				            </c:otherwise>
				        </c:choose>
				    </td>
				</tr>
				<tr class="dot_line">
				    <td class="fixed_join">휴대폰번호</td>
				    <td>
				        <c:choose>
				            <c:when test="${not empty requestScope.phone1 and not empty requestScope.phone2 and not empty requestScope.phone3}">
				                <input type="text" name="hp1" size="5" value="${requestScope.phone1}" readonly style="color:gray;" />
				                <input type="text" name="hp2" size="5" value="${requestScope.phone2}" readonly style="color:gray;" />
				                <input type="text" name="hp3" size="5" value="${requestScope.phone3}" readonly style="color:gray;" />
				            </c:when>
				            
				            <c:otherwise>
				                <select name="hp1" id="hp1">
				                    <option>없음</option>
				                    <option value="010" selected>010</option>
				                    <option value="011">011</option>
				                    <option value="016">016</option>
				                    <option value="017">017</option>
				                    <option value="018">018</option>
				                    <option value="019">019</option>
				                </select> - 
				                <input size="10px" type="text" name="hp2" id="hp2"> - <input size="10px" type="text" name="hp3" id="hp3">
				            </c:otherwise>
				        </c:choose>
				        <br><br>
		                <!-- SMS 수신 동의 -->
						<input type="checkbox" id="smsstsCheckbox" name="smssts_yn" value="Y" checked /> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
						<input type="hidden" id="smsHidden" name="smssts_yn" value="N" />

				    </td>
				</tr>
				<tr class="dot_line">
				    <td class="fixed_join">이메일<br>(e-mail)</td>
				    <td>
				        <c:choose>
				            <c:when test="${not empty requestScope.email1 and not empty requestScope.email2}">
				            	<input size="15px" type="text" name="email1" value="${requestScope.email1}" style="color:gray;" readonly /> @
								<input size="15px" type="text" name="email2" value="${requestScope.email2}" style="color:gray;" readonly />
				            </c:when>
				
				            <c:otherwise>
				                <input size="10px" type="text" name="email1" id="email1" /> @ 
				                <input size="10px" type="text" name="email2" id="email2Input" /> 
				                <select id="email2Select" name="email2Select" onChange="updateEmailDomain()" title="직접입력">
				                    <option value="non">직접입력</option>
				                    <option value="hanmail.net">hanmail.net</option>
				                    <option value="naver.com">naver.com</option>
				                    <option value="yahoo.co.kr">yahoo.co.kr</option>
				                    <option value="hotmail.com">hotmail.com</option>
				                    <option value="paran.com">paran.com</option>
				                    <option value="nate.com">nate.com</option>
				                    <option value="google.com">google.com</option>
				                    <option value="gmail.com">gmail.com</option>
				                    <option value="empal.com">empal.com</option>
				                    <option value="korea.com">korea.com</option>
				                    <option value="freechal.com">freechal.com</option>
				                </select>
				            </c:otherwise>
				        </c:choose>
				        <br><br>
				        <!-- 이메일 수신 동의 -->
						<input type="checkbox" id="emailstsCheckbox" name="emailsts_yn" value="Y" checked /> 쇼핑몰에서 발송하는 이메일 소식을 수신합니다.
						<input type="hidden" id="emailHidden" name="emailsts_yn" value="N" />
				    </td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">주소</td>
					<td>
					   <input type="text" id="zipcode" name="zipcode" size="10" > <a href="javascript:execDaumPostcode()">우편번호검색</a>
					  <br>
					  <p> 
					  도로명 주소:<br><input type="text" id="roadAddress"  name="roadAddress" size="50"><br><br>
					  지번 주소: <br><input type="text" id="jibunAddress" name="jibunAddress" size="50"><br><br>
					  나머지 주소: <br><input type="text"  id="namujiAddress" name="namujiAddress" size="50" />
					  <span id="guide" style="color:#999;display:none"></span>
					   </p>
					</td>
				</tr>
			</tbody>
		</table>
		</div>
		<div class="clear">
		<br><br>
		<table align=center>
		<tr >
			<td >
				<input type="submit" value="회원 가입">
				<input  type="reset"  value="다시입력">
			</td>
		</tr>
	</table>
</div>
</form>

</body>
</html>
