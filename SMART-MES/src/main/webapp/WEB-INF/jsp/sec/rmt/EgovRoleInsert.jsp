<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<c:set var="registerFlag" value="${empty roleManageVO.roleCode ? 'INSERT' : 'UPDATE'}"/>
<c:set var="registerFlagName" value="${empty roleManageVO.roleCode ? '롤 등록' : '롤 수정'}"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Language" content="ko" >

<title><spring:message code="space.manage.role.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="roleManage" staticJavascript="false" xhtml="true" cdata="false"/>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<script type="text/javaScript" language="javascript">

	function fncSelectRoleList() 
	{
	    var varFrom = document.getElementById("roleManage");
	    varFrom.action = "<c:url value='/sec/rmt/EgovRoleList.do'/>";
	    varFrom.submit();       
	}
	
	
	function fncRoleInsert() 
	{
	    var varFrom = document.getElementById("roleManage");
	    varFrom.action = "<c:url value='/sec/rmt/EgovRoleInsert.do'/>";
	    
	    if(!validateRoleManage(varFrom))
	    {           
	        return;
	    }
	    else
	    {
	     	if(confirm("<spring:message code="space.common.saveis" />"))
	     	{
	            varFrom.submit();
	     	}
	    } 
	}

	
	function fncRoleUpdate() 
	{
	    var varFrom = document.getElementById("roleManage");
	    varFrom.action = "<c:url value='/sec/rmt/EgovRoleUpdate.do'/>";
	
	    if(!validateRoleManage(varFrom))
	    {           
	        return;
	    }
	    else
	    {
	        if(confirm("<spring:message code="space.common.saveis" />"))
	        {
	            varFrom.submit();
	        }
	    } 
	}
	
	
	function fncRoleDelete() 
	{
	    var varFrom = document.getElementById("roleManage");
	    varFrom.action = "<c:url value='/sec/rmt/EgovRoleDelete.do'/>";
	    
	    if(confirm("<spring:message code="space.common.deleteis" />")){
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
    

	<form:form commandName="roleManage" method="post" >
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
											<td id="captionTitle" align="center"><spring:message code="space.manage.role.item.rolename" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="roleNm" id="roleNm" type="text" value="<c:out value='${roleManage.roleNm}'/>" maxLength="50" size="50"/>
												<form:errors path="roleNm" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.role.item.rolepattern" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="rolePtn" id="rolePtn" type="text" value="<c:out value='${roleManage.rolePtn}'/>" maxLength="50" size="50"/>
												<form:errors path="rolePtn" />
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.role.item.roledesc" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="roleDc" id="roleDc" type="text" value="<c:out value='${roleManage.roleDc}'/>" maxLength="50" size="50"/>
											</td>
										</tr>
										<tr>
											<td id="captionTitle" align="center"><spring:message code="space.manage.role.item.rolesort" /></td>
											<td id="captionSubTitle" align="left" style="padding-left:10px">
												<input name="roleSort" id="roleSort" type="text" value="<c:out value='${roleManage.roleSort}'/>" maxLength="50" size="50"/>
												<input type="hidden" name="roleTyp" value="url">
												<input type="hidden" name="roleCreatDe" value="">
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
	<input type="hidden" name="searchCondition" value="<c:out value='${roleManageVO.searchCondition}'/>"/>
	<input type="hidden" name="searchKeyword" value="<c:out value='${roleManageVO.searchKeyword}'/>"/>
	<input type="hidden" name="pageIndex" value="<c:out value='${roleManageVO.pageIndex}'/>"/>
	</c:if>
	</form:form>

	<div style="width:1000px" align="center">
		<table>
			<tr>
				<td>
					<a class='AXButton Gray' href="#LINK" onclick="javascript:fncSelectRoleList()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.list" /></a>
					
					<c:if test="${registerFlag == 'INSERT'}">
						<a class='AXButton Gray' href="#LINK" onclick="javascript:fncRoleInsert()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.save" /></a>
					</c:if>
					
					<c:if test="${registerFlag == 'UPDATE'}">
						<a class='AXButton Gray' href="#LINK" onclick="javascript:fncRoleUpdate()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.save" /></a>
						<a class='AXButton Gray' href="#LINK" onclick="javascript:fncRoleDelete()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.delete" /></a>
					</c:if>
				</td>
			</tr>
		</table>
    </div>
   
</div>
<!-- //전체 레이어 끝 -->
</body>
</html>

