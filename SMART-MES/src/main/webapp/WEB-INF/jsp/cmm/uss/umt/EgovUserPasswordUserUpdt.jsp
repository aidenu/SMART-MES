<%--
  Class Name : EgovPasswordUpdt.jsp
  Description : 암호수정 JSP
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2009.03.03   JJY              최초 생성
     2011.08.31   JJY       경량환경 버전 생성
 
    author   : 공통서비스 개발팀 JJY
    since    : 2009.03.03
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
<title>암호 수정</title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="passwordChgVO" staticJavascript="false" xhtml="true" cdata="false"/>
<script type="text/javaScript" language="javascript" defer="defer">
<!--

function fnUpdate(){
    if(validatePasswordChgVO(document.passwordChgVO)){
        if(document.passwordChgVO.newPassword.value != document.passwordChgVO.newPassword2.value){
            alert("<spring:message code="fail.user.passwordUpdate2" />");
            return;
        }
        document.passwordChgVO.submit();
    }
}
<c:if test="${!empty resultMsg}">alert("<spring:message code="${resultMsg}" />");</c:if>
//-->
</script>
</head>
<body style="background-color: #2c3338;">
   
<!-- 전체 레이어 시작 -->
<div id="wrap">
    <!-- header 시작 -->
    <div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
    <div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>        
    <!-- //header 끝 --> 
    <!-- container 시작 -->
    <div id="container">
            <!-- 현재위치 네비게이션 시작 -->
            <div id="content">
				<br>
		        <form name="passwordChgVO" method="post" action="${pageContext.request.contextPath}/uss/umt/user/EgovUserUserPasswordUpdt.do">
		        <div style="width:400px;border: 1px solid #D5D1B0;">
					<table width="100%">
						<tr>
							<td width="35%" id="captionTitle">사용자 아이디</td>
							<td width="65%" id="captionSubTitle" align="center">
								<input name="emplyrId" id="emplyrId" title="사용자아이디" type="text" size="20" value="<c:out value='${userId}'/>"  maxlength="20" readonly/>
				                <input name="uniqId" id="uniqId" title="uniqId" type="hidden" size="20" value="<c:out value='${selectedId}'/>"/>
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
							<td align="right">
                            	<a href='#' class='AXButton Gray' onclick="JavaScript:fnUpdate(); return false;"><spring:message code="button.save" /></a>
                          	</td>
                          	<td width="10"></td>
                          	<td align="left">
                            	<a href='#' class='AXButton Gray' onclick="javascript:document.passwordChgVO.reset();"><spring:message code="button.reset" /></a>
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

