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
<meta http-equiv="Content-Language" content="ko" >
<link href="<c:url value='/'/>css/common.css" rel="stylesheet" type="text/css" >
<title>암호 수정</title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="passwordChgVO" staticJavascript="false" xhtml="true" cdata="false"/>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javaScript" language="javascript" defer="defer">

	function fnListPage()
	{
	    document.passwordChgVO.action = "<c:url value='/uss/umt/user/EgovUserManage.do'/>";
	    document.passwordChgVO.submit();
	}
	
	
	function fnUpdate()
	{
	    if(validatePasswordChgVO(document.passwordChgVO))
	    {
	        if(document.passwordChgVO.newPassword.value != document.passwordChgVO.newPassword2.value)
	        {
	            alert("<spring:message code="fail.user.passwordUpdate2" />");
	            return;
	        }
	        
	        document.passwordChgVO.submit();
	    }
	}
	
	<c:if test="${!empty resultMsg}">alert("<spring:message code="${resultMsg}" />");</c:if>

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
    <!-- container 시작 -->
    <div id="container">
    
    	<div id="content">
				<br>
		        <form name="passwordChgVO" method="post" action="${pageContext.request.contextPath}/uss/umt/user/EgovUserPasswordUpdt.do">
				<input type="submit" id="invisible" class="invisible"/>
	            <input name="checkedIdForDel" type="hidden" />
		        <input type="hidden" name="searchCondition" value="<c:out value='${userSearchVO.searchCondition}'/>"/>
		        <input type="hidden" name="searchKeyword" value="<c:out value='${userSearchVO.searchKeyword}'/>"/>
		        <input type="hidden" name="sbscrbSttus" value="<c:out value='${userSearchVO.sbscrbSttus}'/>"/>
		        <input type="hidden" name="pageIndex" value="<c:out value='${userSearchVO.pageIndex}'/>"/>
		        <div style="width:400px;border: 1px solid #D5D1B0;">
					<table width="100%">
						<tr>
							<td width="35%" id="captionTitle">사용자 아이디</td>
							<td width="65%" id="captionSubTitle" align="center">
								<input name="emplyrId" id="emplyrId" title="사용자아이디" type="text" size="20" value="<c:out value='${userManageVO.emplyrId}'/>"  maxlength="20" readonly/>
			                    <input name="uniqId" id="uniqId" title="uniqId" type="hidden" size="20" value="<c:out value='${userManageVO.uniqId}'/>"/>
			                    <input name="userTy" id="userTy" title="userTy" type="hidden" size="20" value="<c:out value='${userManageVO.userTy}'/>"/>
							</td>
						</tr>
						<tr>
							<td width="35%" id="captionTitle">기존 비밀번호</td>
							<td width="65%" id="captionSubTitle" align="center">
								<input name="oldPassword" id="oldPassword" title="기존 비밀번호" type="password" size="20" value=""  maxlength="100" />
							</td>
						</tr>
						<tr>
							<td width="35%" id="captionTitle">비밀번호</td>
							<td width="65%" id="captionSubTitle" align="center">
								<input name="newPassword" id="newPassword" title="비밀번호" type="password" size="20" value=""  maxlength="100" />
							</td>
						</tr>
						<tr>
							<td width="35%" id="captionTitle">비밀번호 확인</td>
							<td width="65%" id="captionSubTitle" align="center">
								<input name="newPassword2" id="newPassword2" title="비밀번호확인" type="password" size="20" value=""  maxlength="100" />
							</td>
						</tr>
					</table>
				</div>
				<br>
				<!-- 버튼 시작(상세지정 style로 div에 지정) -->
				 <div style="width:400px;">
					<!-- 목록/저장버튼  -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="center"> 
							<td align="center">
                            	<a class='AXButton Gray' href="#LINK" onclick="JavaScript:fnUpdate(); return false;"><spring:message code="button.save" /></a> 
                            	<a class='AXButton Gray' href="<c:url value='/uss/umt/user/EgovUserManage.do'/>" onclick="fnListPage(); return false;"><spring:message code="button.list" /></a>
                            	<a class='AXButton Gray' href="#LINK" onclick="javascript:document.passwordChgVO.reset();"><spring:message code="button.reset" /></a>
                          	</td>
						</tr>
					</table>
				</div>
                </form>
            </div>  
            <!-- //content 끝 -->    
    </div>  
    <!-- //container 끝 -->

</div>
<!-- //전체 레이어 끝 -->
</body>
</html>

