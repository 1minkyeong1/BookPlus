<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<c:set var="goods"  value="${goodsMap.goods}"  />
<c:set var="imageFileList"  value="${goodsMap.imageFileList}"  />

<c:choose>
<c:when test='${not empty goods.goods_status}'>
<script>
window.onload=function(){
	init();
}
function init(){
	var frm_mod_goods=document.frm_mod_goods;
	var h_goods_status=frm_mod_goods.h_goods_status;
	var goods_status=h_goods_status.value;
	var select_goods_status=frm_mod_goods.goods_status;
	select_goods_status.value=goods_status;
}
</script>
</c:when>
</c:choose>

<script type="text/javascript">

function fn_modify_goods(goods_isbn, attribute){ 
	var frm_mod_goods=document.frm_mod_goods;
	var value="";
	
	if(attribute=='goods_categoryName'){
		value=frm_mod_goods.goods_categoryName.value;
	}else if(attribute=='goods_title'){
		value=frm_mod_goods.goods_title.value;
	}else if(attribute=='goods_author'){
		value=frm_mod_goods.goods_author.value;   
	}else if(attribute=='goods_publisher'){
		value=frm_mod_goods.goods_publisher.value;
	}else if(attribute=='goods_priceStandard'){
		value=frm_mod_goods.goods_priceStandard.value;
	}else if(attribute=='goods_priceSales'){
		value=frm_mod_goods.goods_priceSales.value;
	}else if(attribute=='goods_point'){
		value=frm_mod_goods.goods_point.value;
	}else if(attribute=='goods_pubDate'){
		value=frm_mod_goods.goods_pubDate.value;
	}else if(attribute=='goods_total_page'){
		value=frm_mod_goods.goods_total_page.value;
	}else if(attribute=='goods_isbn'){
		value=frm_mod_goods.goods_isbn.value;
	}else if(attribute=='goods_delivery_price'){
		value=frm_mod_goods.goods_delivery_price.value;
	}else if(attribute=='goods_delivery_date'){
		value=frm_mod_goods.goods_delivery_date.value;
	}else if(attribute=='goods_status'){
		value=frm_mod_goods.goods_status.value;
	}else if(attribute=='goods_contents_order'){
		value=frm_mod_goods.goods_contents_order.value;
	}else if(attribute=='goods_author_intro'){
		value=frm_mod_goods.goods_author_intro.value;
	}else if(attribute=='goods_intro'){
		value=frm_mod_goods.goods_intro.value;
	}else if(attribute=='goods_publisher_comment'){
		value=frm_mod_goods.goods_publisher_comment.value;
	}else if(attribute=='goods_recommendation'){
		value=frm_mod_goods.goods_recommendation.value;
	}

	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/admin/goods/modifyGoodsInfo.do",
		data : {
			goods_isbn:goods_isbn,
			attribute:attribute,
			value:value
		},               
		success : function(data, textStatus) {
			var inner = document.getElementById(attribute);
			if(data.trim()=='mod_success'){
				inner.innerHTML = "<h6>성공</h6>";
				inner.style.color="red";
			}else if(data.trim()=='failed'){
				inner.innerHTML = "<h6>실패</h6>";
				inner.style.color="blue";
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다."+data);
		}
	});
}

function readURL(input,preview) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (ProgressEvent) {
            $('#'+preview).attr('src', ProgressEvent.target.result);
        }
        reader.readAsDataURL(input.files[0]);
    }
}

var cnt =1;
function fn_addFile(){
  $("#d_file").append("<br><input type='file' name='detail_image"+cnt+"' id='detail_image"+cnt+"' onchange=readURL(this,'previewImage"+cnt+"') />");
  $("#d_file").append("<img id='previewImage"+cnt+"' width=200 height=200 />");
  $("#d_file").append("<input type='button' value='추가' onClick=addNewImageFile('detail_image"+cnt+"','${imageFileList[0].goods_isbn}','detail_image') />");
  cnt++;
}

function modifyImageFile(fileId,goods_isbn, image_id,fileType){
  var form = $('#FILE_FORM')[0];
  var formData = new FormData(form);
  formData.append("fileName", $('#'+fileId)[0].files[0]);
  formData.append("goods_isbn", goods_isbn);
  formData.append("image_id", image_id);
  formData.append("fileType", fileType);
  
  $.ajax({
    url: '${contextPath}/admin/goods/modifyGoodsImageInfo.do',
    processData: false,
    contentType: false,
    data: formData,
    type: 'POST',
    success: function(result){
       alert("이미지를 수정했습니다!");
     }
  });
}

function addNewImageFile(fileId,goods_isbn, fileType){
  var form = $('#FILE_FORM')[0];
  var formData = new FormData(form);
  formData.append("uploadFile", $('#'+fileId)[0].files[0]);
  formData.append("goods_isbn", goods_isbn);
  formData.append("fileType", fileType);
  
  $.ajax({
    url: '${contextPath}/admin/goods/addNewGoodsImage.do',
    processData: false,
    contentType: false,
    data: formData,
    type: 'post',
    success: function(result){
        alert("이미지를 수정했습니다!");
    }
  });
}

function deleteImageFile(goods_isbn,image_id,imageFileName,trId){
	var tr = document.getElementById(trId);
    $.ajax({
		type : "post",
		async : true,
		url : "${contextPath}/admin/goods/removeGoodsImage.do",
		data: {
			goods_isbn:goods_isbn,
			image_id:image_id,
			imageFileName:imageFileName
		},
		success : function(data, textStatus) {
			alert("이미지를 삭제했습니다!!");
            tr.style.display = 'none';
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다."+textStatus);
		}
	});
}
</script>

</HEAD>
<BODY>
<form name="frm_mod_goods" method=post>
<DIV class="clear"></DIV>
<DIV id="container">
	<UL class="tabs">
		<li><A href="#tab1">상품정보</A></li>
		<li><A href="#tab2">상품목차</A></li>
		<li><A href="#tab3">상품저자소개</A></li>
		<li><A href="#tab4">상품소개</A></li>
		<li><A href="#tab5">출판사 상품 평가</A></li>
		<li><A href="#tab6">추천사</A></li>
		<li><A href="#tab7">상품이미지</A></li>
	</UL>
	<DIV class="tab_container">
		<DIV class="tab_content" id="tab1">
			<table >
				<tr >
					<td width=200 >상품분류</td>
					<td width=500>
					  <select name="goods_categoryName">
						<!-- goods_sort → goods_categoryName -->
						<c:choose>
					      <c:when test="${goods.goods_categoryName=='컴퓨터와 인터넷'}">
							<option value="컴퓨터와 인터넷" selected>컴퓨터와 인터넷 </option>
					  	    <option value="디지털 기기">디지털 기기 </option>
					  	  </c:when>
					  	  <c:when test="${goods.goods_categoryName=='디지털 기기'}">
							<option value="컴퓨터와 인터넷" >컴퓨터와 인터넷 </option>
					  	    <option value="디지털 기기" selected>디지털 기기 </option>
					  	  </c:when>
					  	</c:choose>
					  </select>
					</td>
					<td><div id="goods_categoryName"></div></td>
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_categoryName')"/>
					</td>
				</tr>
				<tr >
					<td >상품이름</td>
					<td><input name="goods_title" type="text" size="40" value="${goods.goods_title }"/></td>
					<td><div id="goods_title"></div></td>
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_title')"/>
					</td>
				</tr>
				
				<tr>
					<td >저자</td>
					<!-- goods_writer → goods_author -->
					<td><input name="goods_author" type="text" size="40" value="${goods.goods_author }" /></td>
					<td><div id="goods_author"></div></td>
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_author')"/>
					</td>
				</tr>
				<tr>
					<td >출판사</td>
					<td><input name="goods_publisher" type="text" size="40" value="${goods.goods_publisher }" /></td>
					<td><div id="goods_publisher"></div></td>
				     <td>
					  <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_publisher')"/>
					</td>
				</tr>
				<tr>
					<td >상품정가</td>
					<!-- goods_price → goods_priceStandard -->
					<td><input name="goods_priceStandard" type="text" size="40" value="${goods.goods_priceStandard }" /></td>
					<td><div id="goods_priceStandard"></div></td>
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_priceStandard')"/>
					</td>
					
				</tr>
				
				<tr>
					<td >상품판매가격</td>
					<!-- goods_sales_price → goods_priceSales -->
					<td><input name="goods_priceSales" type="text" size="40" value="${goods.goods_priceSales }" /></td>
					<td><div id="goods_priceSales"></div></td>
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_priceSales')"/>
					</td>
					
				</tr>
				
				<tr>
					<td >상품 구매 포인트</td>
					<td><input name="goods_point" type="text" size="40" value="${goods.goods_point }" /></td>
					<td><div id="goods_point"></div></td>
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_point')"/>
					</td>
				</tr>

				<tr>
					<td >상품출판일</td>
					<!-- goods_published_date → goods_pubDate -->
					<td>
					  <input name="goods_pubDate" type="date" value="${goods.goods_pubDate }" />
					</td>
					<td><div id="goods_pubDate"></div></td>				
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_pubDate')"/>
					</td>
				</tr>
				
				<tr>
					<td >상품 총 페이지수</td>
					<td><input name="goods_total_page" type="text" size="40" value="${goods.goods_total_page }"/></td>
					<td><div id="goods_total_page"></div></td>				
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_total_page')"/>
					</td>
				</tr>
				
				<tr>
					<td >ISBN</td>
					<td><input name="goods_isbn" type="text" size="40" value="${goods.goods_isbn }" /></td>
					<td><div id="goods_isbn"></div></td>				
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_isbn')"/>
					</td>
				</tr>
				<tr>
					<td >상품 배송비</td>
					<td><input name="goods_delivery_price" type="text" size="40" value="${goods.goods_delivery_price }"/></td>
					<td><div id="goods_delivery_price"></div></td>								
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_delivery_price')"/>
					</td>
				</tr>
				<tr>
					<td >상품 도착 예정일</td>
					<td>
					  <input name="goods_delivery_date" type="date" value="${goods.goods_delivery_date }" />
					</td>
					<td><div id="goods_delivery_date"></div></td>												  
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_delivery_date')"/>
					</td>
				</tr>
				
				<tr>
					<td >상품종류</td>
					<td>
					<select name="goods_status">
					  <option value="bestseller">베스트셀러</option>
					  <option value="steadyseller">스테디셀러</option>
					  <option value="newbook">신간</option>
					  <option value="on_sale">판매중</option>
					  <option value="buy_out" selected>품절</option>
					  <option value="out_of_print">절판</option>
					</select>
					<input type="hidden" name="h_goods_status" value="${goods.goods_status }"/>
					</td>
					<td><div id="goods_status"></div></td>												  				
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_status')"/>
					</td>
				</tr>
				<tr>
				 <td colspan=3><br></td>
				</tr>
			</table>	
		</DIV>
		<DIV class="tab_content" id="tab2">
			<h4>책목차</h4>
			<table>	
			<tr>
				<td>상품목차</td>
				<td><textarea rows="100" cols="80" name="goods_contents_order">${goods.goods_contents_order }</textarea></td>
				<td><div id="goods_contents_order"></div></td>												  						
				<td>
				 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_contents_order')"/>
				</td>
			</tr>
			</table>	
		</DIV>
		<DIV class="tab_content" id="tab3">
			<H4>상품 저자 소개</H4>
			<table>
			 <tr>
				<td>상품 저자 소개</td>
				<!-- goods_writer_intro → goods_author_intro -->
				<td><textarea rows="100" cols="80" name="goods_author_intro">${goods.goods_author_intro }</textarea></td>
				<td><div id="goods_author_intro"></div></td>												  								
				<td>
				 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_author_intro')"/>
				</td>
			 </tr>
		   </table>
		</DIV>
		<DIV class="tab_content" id="tab4">
			<H4>상품소개</H4>
			<table>
				<tr>
					<td>상품소개</td>
					<td><textarea rows="100" cols="80" name="goods_intro">${goods.goods_intro }</textarea></td>
					<td><div id="goods_intro"></div></td>												  										
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_intro')"/>
					</td>
				</tr>
			</table>
		</DIV>
		<DIV class="tab_content" id="tab5">
			<H4>출판사 상품 평가</H4>
			<table>
				<tr>
					<!-- publisher_comment → goods_publisher_comment -->
					<td><textarea rows="100" cols="80" name="goods_publisher_comment">${goods.goods_publisher_comment }</textarea></td>
					<td><div id="goods_publisher_comment"></div></td>												  													
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_publisher_comment')"/>
					</td>
				</tr>
		</table>
		</DIV>
		<DIV class="tab_content" id="tab6">
			<H4>추천사</H4>
			 <table>
				 <tr>
					<td>추천사</td>
					<!-- recommendation → goods_recommendation -->
					<td><textarea rows="100" cols="80" name="goods_recommendation">${goods.goods_recommendation }</textarea></td>
					<td><div id="goods_recommendation"></div></td>												  													
					<td>
					 <input type="button" value="수정반영" onClick="fn_modify_goods('${goods.goods_isbn }','goods_recommendation')"/>
					</td>
				</tr>
		    </table>
		</DIV>
		<DIV class="tab_content" id="tab7">
		   <form id="FILE_FORM" method="post" enctype="multipart/form-data">
			<h4>상품이미지</h4>
			 <table>
				 <tr>
					<c:forEach var="item" items="${imageFileList }" varStatus="itemNum">
			        <c:choose>
			            <c:when test="${item.fileType=='main_image'}">
			              <tr>
						    <td>메인 이미지</td>
						    <td>
							  <input type="file" id="main_image" name="main_image" onchange="readURL(this,'preview${itemNum.count}');" />
							  <input type="hidden" name="image_id" value="${item.image_id}"  />
							  <br>
							</td>
							<td>
							  <img id="preview${itemNum.count }" width=200 height=200 src="${contextPath}/download.do?goods_isbn=${item.goods_isbn}&fileName=${item.fileName}" />
							</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>
							 <input type="button" value="수정" onClick="modifyImageFile('main_image','${item.goods_isbn}','${item.image_id}','${item.fileType}')"/>
							</td> 
						</tr>
						<tr><td><br></td></tr>
			         </c:when>
			         <c:otherwise>
			           <tr id="${itemNum.count-1}">
						<td>상세 이미지${itemNum.count-1 }</td>
						<td>
							<input type="file" name="detail_image" id="detail_image" onchange="readURL(this,'preview${itemNum.count}');" />
							<input type="hidden" name="image_id" value="${item.image_id}"  />
							<br>
						</td>
						<td>
						  <img id="preview${itemNum.count }" width=200 height=200 src="${contextPath}/download.do?goods_isbn=${item.goods_isbn}&fileName=${item.fileName}">
						</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						 <td>
						 <input type="button" value="수정" onClick="modifyImageFile('detail_image','${item.goods_isbn}','${item.image_id}','${item.fileType}')"/>
						 <input type="button" value="삭제" onClick="deleteImageFile('${item.goods_isbn}','${item.image_id}','${item.fileName}','${itemNum.count-1}')"/>
						</td> 
					</tr>
					<tr><td><br></td></tr> 
			         </c:otherwise>
			       </c:choose>		
			    </c:forEach>
			    <tr align="center">
			      <td colspan="3">
				      <div id="d_file"></div>
			      </td>
			    </tr>
		    <tr>
		     <td align=center colspan=2>
		     <input type="button" value="이미지파일추가하기" onClick="fn_addFile()" />
		     </td>
		    </tr> 
	    </table>
	   </form>
	  </DIV>
	<DIV class="clear"></DIV>
</form>
</BODY>
