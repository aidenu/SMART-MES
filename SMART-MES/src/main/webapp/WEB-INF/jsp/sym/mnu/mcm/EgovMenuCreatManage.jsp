<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >

<title><spring:message code="smart.manage.auth.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>

<script type="text/javaScript">

	$(function(){
		var div_height = document.body.clientHeight-200;
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:div_height,autoShow:true});
	});
	
	
	function fMenuCreatManageSelect()
	{ 
	    document.menuCreatManageForm.action = "<c:url value='/sym/mnu/mcm/EgovMenuCreatManageSelect.do'/>";
	    document.menuCreatManageForm.submit();
	}
	
	
	function linkPage(pageNo)
	{
	    document.menuCreatManageForm.pageIndex.value = pageNo;
	    document.menuCreatManageForm.action = "<c:url value='/sym/mnu/mcm/EgovMenuCreatManageSelect.do'/>";
	    document.menuCreatManageForm.submit();
	}
	
	
	function selectMenuCreatManageList() 
	{ 
	    document.menuCreatManageForm.pageIndex.value = 1;
	    document.menuCreatManageForm.action = "<c:url value='/sym/mnu/mcm/EgovMenuCreatManageSelect.do'/>";
	    document.menuCreatManageForm.submit();
	}
	
	
	function selectMenuCreat(vAuthorCode) 
	{
	    document.menuCreatManageForm.authorCode.value = vAuthorCode;
	    document.menuCreatManageForm.action = "<c:url value='/sym/mnu/mcm/EgovMenuCreatSelect.do'/>";
	    window.open("#", "_menuCreat", "scrollbars = yes, top=100px, left=100px, height=700px, width=550px");    
	    document.menuCreatManageForm.target = "_menuCreat";
	    document.menuCreatManageForm.submit();  
	}
	
	<c:if test="${!empty resultMsg}">alert("${resultMsg}");</c:if>

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
    
    <form name="menuCreatManageForm" action ="<c:url value='/sym/mpm/EgovMenuCreatManageSelect.do'/>" method="post">
    <input name="checkedMenuNoForDel" type="hidden" />
	<input name="authorCode"          type="hidden" />
	<input name="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
	<input type="hidden" name="req_menuNo">
    
    
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
											<td id="captionSubTitle" align="center" style="background-color: #2c3338;">
												 <font color="#FFF"><spring:message code="space.manage.menu.item.code" /> : </font>
								                <input name="searchKeyword" type="text" size="50" value=""  maxlength="60"/>  
								                <a class='AXButton Gray' href="#LINK" onclick="javascript:selectMenuCreatManageList(); return false;"><spring:message code="button.search" /></a>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="3">
								<div class="tableContainer" style="width:1000px;">
									<table id="data_table" class="fancyTable"> 
										<thead>
											<tr>
												<th><spring:message code="space.manage.menu.item.code" /></th>
												<th><spring:message code="space.manage.menu.item.name" /></th>
												<th><spring:message code="space.manage.menu.item.desc" /></th>
												<th><spring:message code="space.manage.menu.item.regflag" /></th>
												<th><spring:message code="space.manage.menu.button.menucreate" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="result" items="${list_menumanage}" varStatus="status">
											<tr>
												<td><font color="#FFF"><c:out value="${result.authorCode}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.authorNm}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.authorDc}"/></font></td>
												<td><font color="#FFF">
													<c:if test="${result.chkYeoBu > 0}">Y</c:if>
					          						<c:if test="${result.chkYeoBu == 0}">N</c:if>
												</font></td>
												<td><a class='AXButtonSmall Red' href="<c:url value='/sym/mnu/mcm/EgovMenuCreatSelect.do'/>?authorCode='<c:out value="${result.authorCode}"/>'"  onclick="selectMenuCreat('<c:out value="${result.authorCode}"/>'); return false;"><spring:message code="space.manage.menu.button.menucreate" /></td>
											</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

	</div> 
	</form>

</div>
<!-- //전체 레이어 끝 -->
 </body>
</html>