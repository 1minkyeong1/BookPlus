<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
	<H3>회원 조회</H3>
	<form name="frm_delivery_list">
		<div class="clear"></div>

		<table class="list_view">
			<tbody align=center>
				<tr align=center bgcolor="#ffcc00">
					<td class="fixed">회원아이디</td>
					<td class="fixed">회원이름</td>
					<td>휴대폰번호</td>
					<td>주소</td>
					<td>가입일</td>
				</tr>
				<c:choose>
					<c:when test="${empty member_list}">
						<tr>
							<td colspan=5 class="fixed"><strong>조회된 회원이 없습니다.</strong></td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="item" items="${member_list}" varStatus="item_num">
							<tr>
								<td width=10%><a
									href="${pageContext.request.contextPath}/admin/member/memberDetail.do?member_id=${item.member_id}">
										<strong>${item.member_id}</strong>
								</a></td>
								<td width=10%><strong>${item.member_name}</strong><br>
								</td>
								<td width=20%><strong>${item.hp1}-${item.hp2}-${item.hp3}</strong><br>
								</td>
								<td width=40%><strong>${item.roadAddress}</strong><br>
									<strong>${item.jibunAddress}</strong><br> <strong>${item.namujiAddress}</strong><br>
								</td>
								<td width=10%><c:set var="join_date"
										value="${item.joinDate}" /> <c:set var="arr"
										value="${fn:split(join_date,' ')}" /> <strong><c:out
											value="${arr[0]}" /></strong></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
				<tr>
					<td colspan=8 class="fixed"><c:forEach var="page" begin="1"
							end="10" step="1">
							<c:if test="${section >1 && page==1 }">
								<a
									href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?section=${section-1}&pageNum=${(section-1)*10 +1 }">&nbsp;pre
									&nbsp;</a>
							</c:if>
							<a
								href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?section=${section}&pageNum=${page}">${(section-1)*10 +page }
							</a>
							<c:if test="${page ==10 }">
								<a
									href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?section=${section+1}&pageNum=${section*10+1}">&nbsp;
									next</a>
							</c:if>
						</c:forEach></td>
				</tr>
			</tbody>
		</table>
	</form>
	<div class="clear"></div>
	<c:choose>
		<c:when test="${not empty order_goods_list }">
			<DIV id="page_wrap">
				<c:forEach var="page" begin="1" end="10" step="1">
					<c:if test="${section >1 && page==1 }">
						<a
							href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?section=${section-1}&pageNum=${(section-1)*10 +1 }">&nbsp;pre
							&nbsp;</a>
					</c:if>
					<a
						href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?section=${section}&pageNum=${page}">${(section-1)*10 +page }
					</a>
					<c:if test="${page ==10 }">
						<a
							href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?section=${section+1}&pageNum=${section*10+1}">&nbsp;
							next</a>
					</c:if>
				</c:forEach>
			</DIV>
		</c:when>
	</c:choose>
</body>
</html>
