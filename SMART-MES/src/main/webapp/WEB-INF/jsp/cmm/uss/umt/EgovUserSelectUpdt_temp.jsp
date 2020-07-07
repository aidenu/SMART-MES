<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<meta http-equiv="content-language" content="ko">
<title><spring:message code="space.manage.user.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="userManageVO" staticJavascript="false" xhtml="true" cdata="false"/>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javaScript" language="javascript" defer="defer">
	
	function fnListPage()
	{
	    document.userManageVO.action = "<c:url value='/uss/umt/user/EgovUserManage.do'/>";
	    document.userManageVO.submit();
	}
	
	
	function fnDeleteUser(checkedIds)
	{
	    if(confirm("<spring:message code="common.delete.msg" />"))
	    {
	        document.userManageVO.checkedIdForDel.value=checkedIds;
	        document.userManageVO.action = "<c:url value='/uss/umt/user/EgovUserDelete.do'/>";
	        document.userManageVO.submit(); 
	    }
	}
	
	
	function fnPasswordMove()
	{
	    document.userManageVO.action = "<c:url value='/uss/umt/user/EgovUserPasswordUpdtView.do'/>";
	    document.userManageVO.submit();
	}
	
	
	function fnUpdate()
	{
		if(document.userManageVO.emplyrId.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.id" />");
			return;
		}
		
		if(document.userManageVO.emplyrNm.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.name" />");
			document.userManageVO.emplyrNm.focus();
			return;
		}
		
		/* if(document.userManageVO.passwordHint.selectedIndex == 0)
		{
			alert("<spring:message code="space.manage.user.alert.hint" />");
			document.userManageVO.passwordHint.focus();
			return;
		}
		
		if(document.userManageVO.passwordCnsr.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.answer" />");
			document.userManageVO.passwordCnsr.focus();
			return;
		} 
		
		if(document.userManageVO.emailAdres.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.email" />");
			document.userManageVO.emailAdres.focus();
			return;
		}*/
	
	    document.userManageVO.submit();
	}
	
	
	function fn_egov_inqire_cert()
	{
	    var url = '/uat/uia/EgovGpkiRegist.do';
	    var popupwidth = '500';
	    var popupheight = '400';
	    var title = '인증서';
	
	    Top = (window.screen.height - popupheight) / 3;
	    Left = (window.screen.width - popupwidth) / 2;
	    
	    if (Top < 0) Top = 0;
	    if (Left < 0) Left = 0;
	    
	    Future = "fullscreen=no,toolbar=no,location=no,directories=no,status=no,menubar=no, scrollbars=no,resizable=no,left=" + Left + ",top=" + Top + ",width=" + popupwidth + ",height=" + popupheight;
	    PopUpWindow = window.open(url, title, Future)
	    PopUpWindow.focus();
	}
	
	function fn_egov_dn_info_setting(dn)
	{
	    var frm = document.userManageVO;
	    
	    frm.subDn.value = dn;
	}

</script>

</head>
<body style="background-color: #2c3338;">
    
<!-- 전체 레이어 시작 -->
<div id="wrap">
    <!-- header 시작 -->
    <div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
    <div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>    
    <div id="subnavi"><c:import url="/sym/mms/EgovMainMenuSub.do" /></div>      
    <!-- //header 끝 --> 
    
    <form:form commandName="userManageVO" action="${pageContext.request.contextPath}/uss/umt/user/EgovUserSelectUpdt.do" name="userManageVO" method="post" >
    <div id="spacecontainer">
		<table width="100%">
			<tr><td colspan="3" height="3"></td></tr>
			<tr>
				<td valign="top">
					<table>
						<tr>
							<td width="*">
								<div style="width:1000px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.id" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="emplyrId" id="emplyrId" cssClass="txaIpt" size="20" maxlength="20" readonly="true" />
							                    <form:errors path="emplyrId" cssClass="error"/>
							                    <form:hidden path="uniqId" />
											</td>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.name" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="emplyrNm" id="emplyrNm" cssClass="txaIpt" size="20"  maxlength="60" />
				                    			<form:errors path="emplyrNm" cssClass="error" />
											</td>
										</tr>
										<%-- <tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.hint" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:select path="passwordHint" id="passwordHint">
							                        <form:option value="" label="-- Select --"/>
							                        <form:options items="${passwordHint_result}" itemValue="code" itemLabel="codeNm"/>
							                    </form:select>
							                    <form:errors path="passwordHint" cssClass="error"/>
											</td>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.answer" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="passwordCnsr" id="passwordCnsr" cssClass="txaIpt" size="50" maxlength="100" />
				                    			<form:errors path="passwordCnsr" cssClass="error"/>
											</td>
										</tr> --%>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.email" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="emailAdres" id="emailAdres" cssClass="txaIpt" size="20" maxlength="50" />
				                    			<form:errors path="emailAdres" cssClass="error" />
											</td>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.phone" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="moblphonNo" id="moblphonNo" cssClass="txaIpt" size="20" maxlength="15" />
				                    			<form:errors path="moblphonNo" cssClass="error" />
											</td>
										</tr>
										<tr>
										    <td id="captionTitle" align="center">퇴사자</td>
										    <td id="captionSubTitle" align="left" style="padding-left:10px" colspan="3">
										      <form:select path="ihidnum" id="ihidnum">
										        <form:option value="" label="-- Select --"/>
										        <form:options items="${expireFlag_result}" itemValue="code" itemLabel="codeNm"/>
										      </form:select>
										     </td>
									    </tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	
	<input type="hidden" name="orgnztId" value="<c:out value='ORGNZT_0000000000000'/>"/>
	<input type="hidden" name="emplyrSttusCode" value="<c:out value='P'/>"/>
	<input type="hidden" name="groupId" value="<c:out value='GROUP_00000000000000'/>"/>
	<input name="checkedIdForDel" type="hidden" />
	<input type="hidden" name="searchCondition" value="<c:out value='${userSearchVO.searchCondition}'/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value='${userSearchVO.searchKeyword}'/>"/>
    <input type="hidden" name="sbscrbSttus" value="<c:out value='${userSearchVO.sbscrbSttus}'/>"/>
    <input type="hidden" name="pageIndex" value="<c:out value='${userSearchVO.pageIndex}'/>"/>
    <input type="hidden" name="userTyForPassword" value="<c:out value='${userManageVO.userTy}'/>" />
    <form:hidden path="password" />
	</form:form>

	<div style="width:1000px" align="center">
		<table>
			<tr>
				<td>
		            <a class='AXButton Gray' href="#LINK" onclick="JavaScript:fnUpdate(); return false;"><spring:message code="button.save" /></a>
		            <a class='AXButton Gray' href="<c:url value='/uss/umt/user/EgovUserDelete.do'/>" onclick="fnDeleteUser('<c:out value='${userManageVO.userTy}'/>:<c:out value='${userManageVO.uniqId}'/>'); return false;"><spring:message code="button.delete" /></a> 
		            <a class='AXButton Gray' href="<c:url value='/uss/umt/user/EgovUserManage.do'/>" onclick="fnListPage(); return false;"><spring:message code="button.list" /></a>
		            <a class='AXButton Gray' href="<c:url value='/uss/umt/user/EgovUserPasswordUpdtView.do'/>" onclick="fnPasswordMove(); return false;"><spring:message code="button.passwordUpdate" /></a>
		            <a class='AXButton Gray' href="#LINK" onclick="javascript:document.userManageVO.reset();"><spring:message code="button.reset" /></a>
				</td>
			</tr>
		</table>
    </div>
    
    <br>
    <!-- footer 시작 -->
    <div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div>
    <!-- //footer 끝 -->
</div>
<!-- //전체 레이어 끝 -->
</body>
</html>

