<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="true" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<html>
    <head>
        <title>게시판</title>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.js"></script>
        <style>
    /* 전체 페이지 스타일 */
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

    /* 게시판 컨테이너 */
    .form-inline {
        width: 80%;
        margin: 0 auto;
        padding: 20px;
    }

    /* 테이블 스타일 */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    table th {
        background-color: #333;
        color: white;
        padding: 10px;
    }

    table td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }

    table tr:hover {
        background-color: #f1f1f1;
    }

    /* 링크 스타일 */
    .mouseOverHighlight {
        text-decoration: none;
        color: #007bff;
        font-weight: bold;
      
    }

    .mouseOverHighlight:hover {
        text-decoration: underline;
        color: #0056b3;
    }       
        

    /* 버튼 스타일 */
    button {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 8px 12px;
        font-size: 14px;
        cursor: pointer;
        border-radius: 4px;
    }

    button:hover {
        background-color: #0056b3;
    }

    button[disabled] {
        background-color: #aaa;
        cursor: not-allowed;
    }

    /* 페이징 스타일 */
    #pagination {
        margin-top: 20px;
        text-align: center;
    }

    #pagination button {
        margin: 0 3px;
        padding: 5px 10px;
        border: 1px solid #ddd;
        background-color: #6c757d;
        color: white;
        border-radius: 4px;
    }

    #pagination button[disabled] {
        background-color: #007bff;
        border-color: #007bff;
        font-weight: bold;
    }

    #pagination button:hover:not([disabled]) {
        background-color: #555;
    }

    /* 글 작성 버튼 위치 조정 */
    #write {
        float: right;
    }
</style>
        
        <script type="text/javascript">
            $(document).ready(function(){
            	
            	//--페이지 셋팅
            	var totalPage = ${totalPage}; //전체 페이지
            	var startPage = ${startPage}; //현재 페이지
            	
            	var pagination = "";
            	
            	//--페이지네이션에 항상 10개가 보이도록 조절
            	var forStart = 0;
            	var forEnd = 0;
            	
            	if((startPage-5) < 1){
            		forStart = 1;
            	}else{
            		forStart = startPage-5;
            	}
            	
            	if(forStart == 1){
            		
            		if(totalPage>9){
            			forEnd = 10;
            		}else{
            			forEnd = totalPage;
            		}
            		
            	}else{
            		
            		if((startPage+4) > totalPage){
                		
            			forEnd = totalPage;
                		
                		if(forEnd>9){
                			forStart = forEnd-9
                		}
                		
                	}else{
                		forEnd = startPage+4;
                	}
            	}
            	//--페이지네이션에 항상 10개가 보이도록 조절
            	
            	//전체 페이지 수를 받아 돌린다.
            	for(var i = forStart ; i<= forEnd ; i++){
            		if(startPage == i){
            			pagination += ' <button name="page_move" start_page="'+i+'" disabled>'+i+'</button>';
            		}else{
            			pagination += ' <button name="page_move" start_page="'+i+'" style="cursor:pointer;" >'+i+'</button>';
            		}
            	}
            	
            	//하단 페이지 부분에 붙인다.
            	$("#pagination").append(pagination);
            	//--페이지 셋팅
            	
            	
            	$("a[name='subject']").click(function(){
            		
            		location.href = "${contextPath}/board/view.do?id="+$(this).attr("content_id");
            		
            	});
            	
            	$("#write").click(function(){
            		location.href = "${contextPath}/board/edit.do";
            	});
            	            	
            	$(document).on("click","button[name='page_move']",function(){
            		
                    var visiblePages = 10;//리스트 보여줄 페이지
                    
                    $('#startPage').val($(this).attr("start_page"));//보고 싶은 페이지
                    $('#visiblePages').val(visiblePages);
                    
                    $("#frmSearch").submit();
                    
            	});
            	
            });
        </script>

    </head>
    <body>
    	<form class="form-inline" id="frmSearch" action="${contextPath}/board/boardList.do">
	    	<input type="hidden" id="startPage" name="startPage" value=""><!-- 페이징을 위한 hidden타입 추가 -->
	        <input type="hidden" id="visiblePages" name="visiblePages" value=""><!-- 페이징을 위한 hidden타입 추가 -->
	    	
	    	<h1>게시판</h1>
	    	<div align="center">
	    		<table border="1" width="100%">
	    			<tr>
	    				<th width="10%">
	    					No
	    				</th>
	    				<th width="50%">
	    					제목
	    				</th>
	    				<th width="20%">
	    					작성자
	    				</th>
	    				<th width="30%">
	    					작성일
	    				</th>
	    			</tr>
	    			<c:choose>
			        	<c:when test="${fn:length(boardList) == 0}">
			            	<tr>
			            		<td colspan="4" align="center">
			            			조회결과가 없습니다.
			            		</td>
			            	</tr>
			           	</c:when>
			           	<c:otherwise>
			            	<c:forEach var="boardList" items="${boardList}" varStatus="status">
								<tr>
						    		<td align="center">${boardList.id}</td>
						    		<td>
						    			<a href="${contextPath}/board/view.do?id=${boardList.id}" 
							           	   name="subject" class="mouseOverHighlight">${boardList.subject}
							            </a>
						    		</td>
						    		<td align="center">${boardList.member_name}</td>
						    		<td align="center">${boardList.register_datetime}</td>
						    	</tr>
						    </c:forEach>
			           	</c:otherwise> 
			    	</c:choose>
	    		</table>
	    		<br>
	    			<tr>
	    				<td align="right">
		    				   <!-- 로그인 상태에서만 글 작성 버튼 표시 -->
                             <c:if test="${not empty sessionScope.memberInfo}">
                                <button type="button" id="write" name="write">글 작성</button>
                            </c:if>
	    				</td>
	    			</tr>
	    		<div id="pagination"></div>
	    	</div>
    	</form>
    </body>
</html>