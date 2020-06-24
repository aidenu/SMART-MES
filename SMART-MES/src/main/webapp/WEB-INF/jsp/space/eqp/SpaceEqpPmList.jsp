<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script>

	var strHtml = new StringBuffer();
	
	<c:forEach var="result" items="${result}" varStatus="status">
	
		strHtml.append("<tr style='cursor:pointer' onclick='getDetailInfo(\"${result.PM_ID}\")'>");
		strHtml.append("<td><font color='#FFF'>${result.PM_TYPE}</font></td>");
		strHtml.append("<td><font color='#FFF'>${result.PM_EQPPART}</font></td>");
		strHtml.append("<td><font color='#FFF'>${result.PM_EQP}</font></td>");
		strHtml.append("<td><font color='#FFF'>${result.PM_DATE}</font></td>");
		strHtml.append("<td><font color='#FFF'>${result.PM_WORKER_NAME}</font></td>");
		strHtml.append("<td><c:if test="${result.PM_HOUR ne null}"><font color='#FFF'>${result.PM_HOUR} 시간</font></c:if></td>");
		strHtml.append("<td style='padding-left:10px;text-align:left'><font color='#FFF'>${result.PM_DETAIL}</font></td>");
		strHtml.append("<td><c:if test="${result.IMAGE_FLAG == 'Y'}"><img src=\"<c:url value='/'/>images/png/Attach-icon.png\" width='20' height='20' style='background-color:#FFFFFF;'/></c:if></td>");
		strHtml.append("</tr>");
		
	</c:forEach>
	
	parent.jq$("#data_table_tbody").empty();
	
	parent.jq$("#data_table_tbody").append(strHtml.toString());
	
	parent.document.getElementById("progress_div").style.visibility = "hidden";
	
</script>