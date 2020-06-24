<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    response.setHeader("Content-Disposition", "attachment; filename=EqpToolData.xls"); 
    response.setHeader("Content-Description", "JSP Generated Data");
%>

<html>
<head>
<META HTTP-EQUIVE="CONTENT-TYPE" CONTENT="TEXT/HTML; CHARSET=UTF-8">
</head>

<body>
	<table border='1'>
		<tr>
			<td>대분류:${tool_level_1}</td>
			<td>소분류:${tool_level_2}</td>
			<td>파이:${tool_pie}</td>
			<td>F/B:${tool_fb}</td>
			<td>R:${tool_radius}</td>
			<td>기장:${tool_length}</td>
		</tr>
	</table>
	<br>
	<table border='1'>
		<tr>
			<td align='center' bgcolor='#FFFFFF'>대분류</td>
			<td align='center' bgcolor='#FFFFFF'>소분류</td>
			<td align='center' bgcolor='#FFFFFF'>파이(mm)</td>
			<td align='center' bgcolor='#FFFFFF'>F/B</td>
			<td align='center' bgcolor='#FFFFFF'>R(mm)</td>
			<td align='center' bgcolor='#FFFFFF'>기장(mm)</td>
			<td align='center' bgcolor='#FFFFFF'>단가(원)</td>
			<td align='center' bgcolor='#FFFFFF'>안전재고(EA)</td>
			<td align='center' bgcolor='#FFFFFF'>현재고(EA)</td>
		</tr>
		
		<c:forEach var="result" items="${result}" varStatus="status">
	
			<tr <c:choose><c:when test="${result.TOOL_SAFE_STOCK == result.TOOL_CURRENT_STOCK}">bgcolor='#99ccff'</c:when><c:when test="${result.TOOL_SAFE_STOCK > result.TOOL_CURRENT_STOCK}">bgcolor='#ff6699'</c:when><c:otherwise>bgcolor='#ffffff'</c:otherwise></c:choose>>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_LEVEL_1}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_LEVEL_2}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_PIE}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_FB}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_RADIUS}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_LENGTH}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_UNIT}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_SAFE_STOCK}</td>
				<td align='center' style='mso-number-format:"\@";'>${result.TOOL_CURRENT_STOCK}</td>
			</tr>
	
		</c:forEach>
	</table>
</body>
</html>