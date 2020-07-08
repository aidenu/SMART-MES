<%--
  Class Name : EgovIncHeader.jsp
  Description : 화면상단 Header (include)
  Modification Information
 --%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<script>

	function goPassWordChg(selectedid,uniqueid)
	{
		document.userForm.selectedId.value = selectedid;
		document.userForm.uniqueId.value = uniqueid;
	    document.userForm.action = "<c:url value='/uss/umt/user/EgovUserPasswordUpdtUserView.do'/>";
	    document.userForm.target = "";
	    document.userForm.submit();
	}
	
	function getAlarmList()
	{
		window.open("<c:url value='/'/>space/common/SpaceAlarm.do","alarm_win","scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=1030,height=800");
	}
	
	
	function getMobileApp()
	{
		window.open("<c:url value='/'/>space/common/SpaceMobileApp.do","","scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=600,height=520");
	}
	
</script>

<table width="100%" style="background-color:#2c3338;">
	<tr>
		<td  width="400" height="30">
			<div id="project_title">
				<a href="<c:url value='/'/>uat/uia/actionMain.do"><span class="maintitle"><font size=4><spring:message code="smart.header.title" /></font></span></a>
			</div>
		</td>
		<td  width="*" align="right">
			<div id="top_menu" align="right" style="padding-right:10px;">
<%
	LoginVO loginVO = (LoginVO) session.getAttribute("LoginVO");

	if (loginVO != null)
	{
%>
				<form name="userForm" method="post">
				<input name="selectedId" type="hidden" />
				<input name="uniqueId" type="hidden" />
				<table width="100%">
					<tr>
						<td align="right">
							<table width="400">
								<tr>
									<td><font color="#FFFFFF"><b><%=loginVO.getName()%>(<%=loginVO.getId()%>)</b></font></td>
									<td><a href="#" onclick="getAlarmList()"><font color="#FFFFFF"><b><spring:message code="space.header.alarm" /></b></font></a></td>
									<td><a href="#" onclick="goPassWordChg('<%=loginVO.getId()%>','<%=loginVO.getUniqId()%>')"><font color="#FFFFFF"><b><spring:message code="space.header.chgpass" /></b></font></a></td>
									<td><a href="#" onclick="getMobileApp()"><font color="#FFFFFF"><b><spring:message code="space.header.mobile" /></b></font></a></td>
									<td><a href="<c:url value='/uat/uia/actionLogout.do'/>"><font color="#FFFFFF"><b><spring:message code="space.header.logout" /></b></font></a></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				</form>
				
				<form name="popupForm" method="post"></form>
<%
	}
%>
			</div>
		</td>
	</tr>
</table>
