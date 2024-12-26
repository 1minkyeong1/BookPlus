<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html>
    <head>
        <title>게시판</title>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.js"></script>
        <script src="//cdn.ckeditor.com/4.7.1/standard/ckeditor.js"></script>
        <style>
    /* 전체 레이아웃 스타일 */
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        color: #333;
    }

    h1 {
        text-align: center;
        margin-bottom: 20px;
        color: #444;
        font-weight: bold;
    }

    .container {
        width: 80%;
        margin: 0 auto;
        background: #fff;
        border: 1px solid #ddd;
        padding: 20px;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    }

    /* 입력 필드 스타일 */
    input[type="text"], input[type="password"], textarea {
        width: 95%;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
    }

    input[type="text"]:read-only {
        background-color: #f0f0f0;
    }

    /* CKEditor 높이 및 여백 */
    #content {
        width: 100%;
        box-sizing: border-box;
        margin-top: 10px;
    }

    /* 버튼 스타일 */
    button {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 10px 15px;
        font-size: 14px;
        cursor: pointer;
        border-radius: 4px;
        margin-right: 5px;
        display: inline-block;
    }

    button:hover {
        background-color: #0056b3;
    }

    button:disabled {
        background-color: #aaa;
        cursor: not-allowed;
    }

    /* 테이블 스타일 */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    table td {
        padding: 10px;
    }

    /* 지도 검색 팝업 버튼 스타일 */
    button[onclick="openPopup()"] {
        background-color: #28a745;
        color: white;
    }

    button[onclick="openPopup()"]:hover {
        background-color: #218838;
    }

    /* 텍스트 입력 필드와 라벨 스타일 */
    label {
        font-weight: bold;
        margin-right: 10px;
    }

    /* 장소 선택 input 스타일 */
    #selectedPlaceInput {
        background-color: #e9ecef;
        border: 1px solid #ddd;
        padding: 8px;
        border-radius: 4px;
        width: 300px;
    }

    /* 버튼을 한 줄에 정렬 */
    #buttonGroup {
        text-align: right;
    }

    /* 콘텐츠 영역 스타일 */
    .content-area {
        margin-top: 20px;
    }
</style>
        
        <script type="text/javascript">
            $(document).ready(function(){
            	
            	CKEDITOR.replace( 'content' );
            	CKEDITOR.config.height = 500;
            	
            	$("#list").click(function(){
            		location.href = "${contextPath}/board/boardList.do";
            	});
            	
            	$("#save").click(function(){
            		
            		//에디터 내용 가져옴
            		var content = CKEDITOR.instances.content.getData();
            		
            		//널 검사
                    if($("#subject").val().trim() == ""){
                    	alert("제목을 입력하세요.");
                    	$("#subject").focus();
                    	return false;
                    }
            		
                    if($("#writer").val().trim() == ""){
                    	alert("작성자를 입력하세요.");
                    	$("#writer").focus();
                    	return false;
                    }
                    
                    if($("#password").val().trim() == ""){
                    	alert("비밀번호를 입력하세요.");
                    	$("#password").focus();
                    	return false;
                    }
            		
            		//값 셋팅
            		var objParams = {
            				<c:if test="${boardView.id != null}"> //있으면 수정 없으면 등록
            				id			: $("#board_id").val(),
            				</c:if>
            				subject		: $("#subject").val(),
            				userId		: $("#userId").val(),
            				password	: $("#password").val(),
            				place_name	: $("#selectedPlaceName").val(),
                            road_address_name: $("#selectedPlaceRoad").val(),
                            place_url	: $("#selectedPlaceUrl").val(),
                            x		: $("#selectedPlaceX").val(),
                            y		: $("#selectedPlaceY").val(),
            				content		: content
    				};
            		
            		//ajax 호출
            		$.ajax({
            			url			:	"${contextPath}/board/save",
            			dataType	:	"json",
            			contentType :	"application/x-www-form-urlencoded; charset=UTF-8",
            			type 		:	"post",
            			data		:	objParams,
            			success 	:	function(retVal){
            				console.log("retVal:", retVal);
            				if(retVal.code == "OK") {
            					alert(retVal.message);
            					location.href = "${contextPath}/board/boardList.do";	
            				} else {
            					alert(retVal.message);
            				}
            				
            			},
            			error		:	function(request, status, error){
            				console.log("AJAX_ERROR");
            			}
            		});
            		
            		
            	});
            	
            });
            
            function openPopup() {
                // 팝업 창 열기
                window.open(
                    "${contextPath}/map/map",  // 팝업으로 띄울 파일 경로
                    "주소찾기",          // 팝업 창 이름
                    "width=800,height=600,scrollbars=yes,resizable=yes" // 팝업 옵션
                );
            }
         // 팝업에서 데이터를 받는 함수
            function setPlaceData(placeName, roadAddress, placeUrl, placeX, placeY) {
                $("#selectedPlaceName").val(placeName);        // 장소 이름
                $("#selectedPlaceRoad").val(roadAddress);      // 도로명 주소
                $("#selectedPlaceUrl").val(placeUrl);          // 장소 URL
                $("#selectedPlaceX").val(placeX);              // 위도
                $("#selectedPlaceY").val(placeY);              // 경도
            }
        </script>
    </head>
    <body>
    	<input type="hidden" id="board_id" name="board_id" value="${boardView.id}" />
    	<div align="center">
    		</br>
    		</br>
   			<table width="100%">
   				<tr>
   					<td>
   						제목: <input type="text" id="subject" name="subject" style="width:600px;" placeholder="제목" value="${boardView.subject}"/><br>
   						작성자: <input type="text" id="writer" name="writer" style="width:170px;" maxlength="10" placeholder="작성자" value="${userName}" readonly/>
   						<input type="hidden" id="userId" name="userId" value="${userId}"/>
   						<br>
   						<label for="selectedPlaceInput">선택된 장소:</label>
						<input type="text" id="selectedPlaceInput" readonly style="width: 300px;" value="${boardView.place_name}${boardView.road_address_name}">
						<input type="hidden" id="selectedPlaceName">
						<input type="hidden" id="selectedPlaceRoad">
						<input type="hidden" id="selectedPlaceUrl">
						<input type="hidden" id="selectedPlaceX">
						<input type="hidden" id="selectedPlaceY">
						
   						<button onclick="openPopup()">지도 검색 팝업 열기</button><br>
   						비밀번호: <input type="password" id="password" name="password" style="width:170px;" maxlength="10" placeholder="패스워드"/>
   						<button id="save" name="save">저장</button>   						
   				
   					</td>
   				</tr>
   				<tr>
   					<td>
   						<textarea name="content" id="content" rows="10" cols="80">${boardView.content}</textarea>
   					</td>
   				</tr>
   				<tr>
   					<td align="right">
   						<button id="list" name="list">게시판</button>
   					</td>
   				</tr>
   			</table>
    	</div>
    </body>
</html>