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

	function fnIdCheck()
	{
		var retVal;
	    var url = "<c:url value='/uss/umt/cmm/EgovIdDplctCnfirmView.do'/>";
	    window.open(url,'','toolbar=no,location=no,status=yes,menubar=no,scrollbars=no,resizable=no,width=430,height=130,top=100,left=100');
	}
	
	
	function fnListPage()
	{
	    document.userManageVO.action = "<c:url value='/uss/umt/user/EgovUserManage.do'/>"; 
	    document.userManageVO.submit();
	}
	
	
	function fnInsert()
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
		
		if(document.userManageVO.password.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.passwd" />");
			document.userManageVO.password.focus();
			return;
		}
		
		if(document.userManageVO.password2.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.repasswd" />");
			document.userManageVO.password2.focus();
			return;
		}
		
		/* if(document.userManageVO.passwordHint.selectedIndex == 0)
		{
			alert("<spring:message code="space.manage.user.alert.hint" />");
			document.userManageVO.passwordHint.focus();
			return;
		} */
		
		/* if(document.userManageVO.passwordCnsr.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.answer" />");
			document.userManageVO.passwordCnsr.focus();
			return;
		} */
	
        if(document.userManageVO.password.value != document.userManageVO.password2.value)
        {
            alert("<spring:message code="fail.user.passwordUpdate2" />");
            return;
        }
        
        
        /* if(document.userManageVO.emailAdres.value == "")
		{
			alert("<spring:message code="space.manage.user.alert.email" />");
			document.userManageVO.emailAdres.focus();
			return;
		} */
        
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
    
    <form:form commandName="userManageVO" action="${pageContext.request.contextPath}/uss/umt/user/EgovUserInsert.do" name="userManageVO" method="post" >
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
												<input type="text" size="20" maxlength="20" disabled="disabled" id="id_view" name="id_view" >
							                    <form:input path="emplyrId" id="emplyrId" size="20" maxlength="20" cssStyle="display:none" />
							                    <a class='AXButtonSmall Red' href="javascript:fnIdCheck();"><spring:message code="space.manage.user.button.idsearch" /></a>
							                    <div><form:errors path="emplyrId" cssClass="error"/></div>
											</td>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.name" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="emplyrNm" id="emplyrNm" type="text" size="20" value="" maxlength="60" />
                                    			<div><form:errors path="emplyrNm" cssClass="error" /></div>
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.passwd" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:password path="password" id="password" size="20" maxlength="20" />
				                    			<div><form:errors path="password" cssClass="error" /></div>
											</td>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.repasswd" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="password2" id="password2" type="password" size="20" maxlength="20" />
											</td>
										</tr>
										<%-- <tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.hint" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:select path="passwordHint" id="passwordHint">
							                        <form:option value="" label="-- Select --"/>
							                        <form:options items="${passwordHint_result}" itemValue="code" itemLabel="codeNm"/>
							                    </form:select>
							                    <div><form:errors path="passwordHint" cssClass="error"/></div>
											</td>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.answer" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="passwordCnsr" id="passwordCnsr" cssClass="txaIpt" size="50" maxlength="100" />
				                   				<div><form:errors path="passwordCnsr" cssClass="error"/></div>
											</td>
										</tr> --%>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.email" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="emailAdres" id="emailAdres" cssClass="txaIpt" size="20" maxlength="50" />
                                    			<div><form:errors path="emailAdres" cssClass="error" /></div>
											</td>
											<td id="captionTitle" align="center"><spring:message code="space.manage.user.item.phone" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<form:input path="moblphonNo" id="moblphonNo" cssClass="txaIpt" size="20" maxlength="15" />
                                    			<div><form:errors path="moblphonNo" cssClass="error" /></div>
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
	<input type="hidden" name="searchCondition" value="<c:out value='${userSearchVO.searchCondition}'/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value='${userSearchVO.searchKeyword}'/>"/>
    <input type="hidden" name="sbscrbSttus" value="<c:out value='${userSearchVO.sbscrbSttus}'/>"/>
    <input type="hidden" name="pageIndex" value="<c:out value='${userSearchVO.pageIndex}'/><c:if test="${userSearchVO.pageIndex eq null}">1</c:if>"/>
	</form:form>

	<div style="width:1000px" align="center">
		<table>
			<tr>
				<td>
		            <a class='AXButton Gray' href="#LINK" onclick="JavaScript:fnInsert(); return false;"><spring:message code="button.save" /></a>
		            <a class='AXButton Gray' href="<c:url value='/uss/umt/user/EgovUserManage.do'/>" onclick="fnListPage(); return false;"><spring:message code="button.list" /></a>
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

