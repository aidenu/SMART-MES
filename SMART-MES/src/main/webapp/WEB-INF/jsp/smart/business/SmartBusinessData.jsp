<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/smart/smartutil.js"/>"/></script>
<script>

	var strHtml = new StringBuffer();
	
	<c:forEach var="result" items="${result}" varStatus="status">
	
		strHtml += "<tr>";
		strHtml += "	<td>${result.MODEL_NO}</td>";
		strHtml += "	<td>${result.PRODUCT_NO}</td>";
		strHtml += "	<td>${result.PRODUCT_NAME}</td>";
		strHtml += "	<td>${result.ORDER_DATE}</td>";
		strHtml += "	<td>${result.DUE_DATE}</td>";
		strHtml += "	<td>";
		strHtml += "	<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='${result.MODEL_ID }_detail'>";
		strHtml += "		<i data-feather='edit'></i>";
		strHtml += "	</div>";
		strHtml += "	</td>";
		strHtml += "</tr>";
		
	</c:forEach>

	parent.$("#data_table_tbody").empty();
	parent.$("#data_table_tbody").append(strHtml.toString());
	
</script>