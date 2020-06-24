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
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script>

	////////////// 부품 정보 리스트에 대한 부분을 셋팅 한다 ////////////////////////////////////////////////////////////////////
	var strHtml = new StringBuffer();
	
	<c:forEach var="resultSpec" items="${resultSpec}" varStatus="status">
	
		strHtml.append("<div id='eqpbox_${resultSpec.EQP_PART}_${resultSpec.EQP_NAME_ID}' style='width:${resultSpec.EQP_WIDTH}px;height:${resultSpec.EQP_HEIGHT}px;left:${resultSpec.EQP_LEFT}px;top:${resultSpec.EQP_TOP}px;background-color:#F2F2F2;border:5px solid #CCCCCC' class='float-shadow eqpbox' onclick='resizeDiv(\"eqpbox_${resultSpec.EQP_PART}_${resultSpec.EQP_NAME_ID}\");'>");
		strHtml.append("<table style='width:100%;height:100%'>");
		strHtml.append("<tr><td style='width:100%;'><font id='title_eqpbox_${resultSpec.EQP_PART}_${resultSpec.EQP_NAME_ID}'>${resultSpec.EQP_PART}</font></td></tr>");
		strHtml.append("<tr><td style='width:80%;height:2px;background-color:#000000'></td></tr>");
		strHtml.append("<tr><td style='width:100%;'><font id='content_eqpbox_${resultSpec.EQP_PART}_${resultSpec.EQP_NAME_ID}'>${resultSpec.EQP_NAME}</font></td></tr>");
		strHtml.append("<input type='hidden' id='process_eqpbox_${resultSpec.EQP_PART}_${resultSpec.EQP_NAME_ID}' value='${resultSpec.EQP_PART}'>");
		strHtml.append("<input type='hidden' id='eqpname_eqpbox_${resultSpec.EQP_PART}_${resultSpec.EQP_NAME_ID}' value='${resultSpec.EQP_NAME}'>");
		strHtml.append("</table>");
		strHtml.append("</div>");
		
	</c:forEach>
	
	parent.jq$("#drag_div").empty();
	
	parent.jq$("#drag_div").append(strHtml.toString());
	
	//if("${userrole}" == "ROLE_ADMIN" || "${userrole}" == "ROLE_USER_MANAGER")
	//{
		<c:forEach var="resultSpec" items="${resultSpec}" varStatus="status">
			parent.setDrag("eqpbox_${resultSpec.EQP_PART}_${resultSpec.EQP_NAME_ID}");
			parent.resizeDiv("eqpbox_${resultSpec.EQP_PART}_${resultSpec.EQP_NAME_ID}");
		</c:forEach>
	//}
	
	
	//설비별 상태 정보를 셋팅한다
	<c:forEach var="resultStatus" items="${resultStatus}" varStatus="status">

		//전원이 들어와 있는지 표시
		<c:if test="${resultStatus.ACTIVE_FLAG == 'ACTIVE'}">
			parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").style.border = "5px solid #F9F900";
		</c:if>
		
		//작업 상태 표시
		<c:choose>
			<c:when test="${resultStatus.RED_STATUS == 'ON'}">
				parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").style.backgroundColor = "#FF3300";
				<c:if test="${resultStatus.RED_VALUE == '2'}">
					parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").className = "float-shadow eqpbox blinkcss";
				</c:if>
			</c:when>
			<c:when test="${resultStatus.GREEN_STATUS == 'ON'}">
				parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").style.backgroundColor = "#00E600";
				<c:if test="${resultStatus.GREEN_VALUE == '2'}">
					parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").className = "float-shadow eqpbox blinkcss";
				</c:if>
			</c:when>
			<c:when test="${resultStatus.AMBER_STATUS == 'ON'}">
				parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").style.backgroundColor = "#FFCC00";
				<c:if test="${resultStatus.AMBER_VALUE == '2'}">
					parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").className = "float-shadow eqpbox blinkcss";
				</c:if>
			</c:when>
			<c:when test="${lamplevel > 3 && resultStatus.BLUE_STATUS == 'ON'}">
				parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").style.backgroundColor = "#33CCFF";
				<c:if test="${resultStatus.BLUE_VALUE == '2'}">
					parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").className = "float-shadow eqpbox blinkcss";
				</c:if>
			</c:when>
			<c:when test="${lamplevel > 4 && resultStatus.WHITE_STATUS == 'ON'}">
				parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").style.backgroundColor = "#F9F9F9";
				<c:if test="${resultStatus.WHITE_VALUE == '2'}">
					parent.document.getElementById("eqpbox_${resultStatus.EQP_PART}_${resultStatus.EQP_NAME_ID}").className = "float-shadow eqpbox blinkcss";
				</c:if>
			</c:when>
		</c:choose>
	</c:forEach>
	
	if("${userrole}" != "ROLE_ADMIN" && "${userrole}" != "ROLE_USER_MANAGER")
	{
		parent.document.getElementById('reload_icon').innerHTML = "<img	src='<c:url value='/'/>images/space/reload.gif' width='20' height='20' />";
		
		parent.second = ${reload_time} + 1;
		parent.orgin_second = ${reload_time} + 1;
		
		parent.endTimer();
		parent.startTimer();
	} 
	
// 	parent.document.getElementById("progress_div").style.visibility = "hidden";	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
</script>