<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<c:set var="registerFlag" value="${empty authorManageVO.authorCode ? 'INSERT' : 'UPDATE'}"/>
<c:set var="registerFlagName" value="${empty authorManageVO.authorCode ? '권한 등록' : '권한 수정'}"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Language" content="ko" >

<title><spring:message code="space.manage.auth.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="authorManage" staticJavascript="false" xhtml="true" cdata="false"/>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javaScript" language="javascript">
	
	function fncSelectAuthorList()
	{
	    var varFrom = document.getElementById("authorManage");
	    varFrom.action = "<c:url value='/sec/ram/EgovAuthorList.do'/>";
	    varFrom.submit();       
	}
	
	
	function fncAuthorInsert()
	{
	    var varFrom = document.getElementById("authorManage");
	    varFrom.action = "<c:url value='/sec/ram/EgovAuthorInsert.do'/>";
	
	    if(confirm("<spring:message code="space.common.saveis" />"))
	    {
	        if(!validateAuthorManage(varFrom))
	        {           
	            return;
	        }
	        else
	        {
	            varFrom.submit();
	        } 
	    }
	}
	
	
	function fncAuthorUpdate()
	{
	    var varFrom = document.getElementById("authorManage");
	    varFrom.action = "<c:url value='/sec/ram/EgovAuthorUpdate.do'/>";
	
	    if(confirm("<spring:message code="space.common.saveis" />"))
	    {
	        if(!validateAuthorManage(varFrom))
	        {           
	            return;
	        }
	        else
	        {
	            varFrom.submit();
	        } 
	    }
	}
	
	
	function fncAuthorDelete() 
	{
	    var varFrom = document.getElementById("authorManage");
	    varFrom.action = "<c:url value='/sec/ram/EgovAuthorDelete.do'/>";
	    
	    if(confirm("<spring:message code="space.common.deleteis" />"))
	    {
	        varFrom.submit();
	    }
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
    

	<form:form commandName="authorManage" method="post" >
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
											<td id="captionTitle" align="center"><spring:message code="space.manage.auth.item.code" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="authorCode" id="authorCode" type="text" value="<c:out value='${authorManage.authorCode}'/>" size="40"/>
												<form:errors path="authorCode" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.auth.item.name" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="authorNm" id="authorNm" type="text" value="<c:out value='${authorManage.authorNm}'/>" maxLength="50" size="40" />
												<form:errors path="authorNm" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.auth.item.desc" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="authorDc" id="authorDc" type="text" value="<c:out value='${authorManage.authorDc}'/>" maxLength="50" size="50" />
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
	
	<c:if test="${registerFlag == 'UPDATE'}">
	<input type="hidden" name="searchCondition" value="<c:out value='${authorManageVO.searchCondition}'/>"/>
	<input type="hidden" name="searchKeyword" value="<c:out value='${authorManageVO.searchKeyword}'/>"/>
	<input type="hidden" name="pageIndex" value="<c:out value='${authorManageVO.pageIndex}'/>"/>
	</c:if>
	</form:form>

	<div style="width:1000px" align="center">
		<table>
			<tr>
				<td>
					<a class='AXButton Gray' href="#LINK" onclick="javascript:fncSelectAuthorList()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.list" /></a>
					
					<c:if test="${registerFlag == 'INSERT'}">
						<a class='AXButton Gray' href="#LINK" onclick="javascript:fncAuthorInsert()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.save" /></a>
					</c:if>
					
					<c:if test="${registerFlag == 'UPDATE'}">
						<a class='AXButton Gray' href="#LINK" onclick="javascript:fncAuthorUpdate()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.save" /></a>
						<a class='AXButton Gray' href="#LINK" onclick="javascript:fncAuthorDelete()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.delete" /></a>
					</c:if>
				</td>
			</tr>
		</table>
    </div>
    

</div>
<!-- //전체 레이어 끝 -->
</body>
</html>

