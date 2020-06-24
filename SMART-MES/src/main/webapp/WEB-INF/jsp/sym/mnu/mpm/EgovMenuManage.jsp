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

<title><spring:message code="space.manage.menulist.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>

<script language="javascript1.2" type="text/javaScript">

	$(function(){
		var div_height = document.body.clientHeight-200;
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:div_height,autoShow:true});
	});
	
	function fCheckAll() 
	{
	    var checkField = document.menuManageForm.checkField;
	    
	    if(document.getElementById("checkAll").checked)
	    {
	        if(checkField) 
	        {
	            if(checkField.length > 1) 
	            {
	                for(var i=0; i < checkField.length; i++) 
	                {
	                    checkField[i].checked = true;
	                }
	            } 
	            else 
	            {
	                checkField.checked = true;
	            }
	        }
	    } 
	    else 
	    {
	        if(checkField) 
	        {
	            if(checkField.length > 1) 
	            {
	                for(var j=0; j < checkField.length; j++) 
	                {
	                    checkField[j].checked = false;
	                }
	            } 
	            else 
	            {
	                checkField.checked = false;
	            }
	        }
	    }
	}
	
	
	function fDeleteMenuList() 
	{
	    var checkField = document.menuManageForm.checkField;
	    var menuNo = document.menuManageForm.checkMenuNo;
	    var checkMenuNos = "";
	    var checkedCount = 0;
	    
	    if(checkField) 
	    {
	        if(checkField.length > 1) 
	        {
	            for(var i=0; i < checkField.length; i++) 
	            {
	                if(checkField[i].checked) 
	                {
	                    checkMenuNos += ((checkedCount==0? "" : ",") + menuNo[i].value);
	                    checkedCount++;
	                }
	            }
	        } 
	        else 
	        {
	            if(checkField.checked) 
	            {
	                checkMenuNos = menuNo.value;
	            }
	        }
	    }   
	
	    if(checkMenuNos == "")
	    {
	    	alert("<spring:message code="space.manage.menulist.alert.noselect" />");
	    	return;
	    }
	    else
	    {
	    	if(confirm("<spring:message code="space.manage.menulist.alert.isdelete" />"))
	    	{
		    	document.menuManageForm.checkedMenuNoForDel.value=checkMenuNos;
			    document.menuManageForm.action = "<c:url value='/sym/mnu/mpm/EgovMenuManageListDelete.do'/>";
			    document.menuManageForm.submit();	    	
	    	}
	    }
	}
	
	
	function linkPage(pageNo)
	{
	    document.menuManageForm.pageIndex.value = pageNo;
	    document.menuManageForm.action = "<c:url value='/sym/mnu/mpm/EgovMenuManageSelect.do'/>";
	    document.menuManageForm.submit();
	}
	
	
	function selectMenuManageList() 
	{ 
	    document.menuManageForm.pageIndex.value = 1;
	    document.menuManageForm.action = "<c:url value='/sym/mnu/mpm/EgovMenuManageSelect.do'/>";
	    document.menuManageForm.submit();
	}
	
	
	function insertMenuManage() 
	{
	    document.menuManageForm.action = "<c:url value='/sym/mnu/mpm/EgovMenuRegistInsert.do'/>";
	    document.menuManageForm.submit();   
	}
	
	
	function bndeInsertMenuManage() 
	{
	    document.menuManageForm.action = "<c:url value='/sym/mnu/mpm/EgovMenuBndeRegist.do'/>";
	    document.menuManageForm.submit();
	} 
	
	
	function selectUpdtMenuManageDetail(menuNo) 
	{
	    document.menuManageForm.req_menuNo.value = menuNo;
	    document.menuManageForm.action = "<c:url value='/sym/mnu/mpm/EgovMenuManageListDetailSelect.do'/>";
	    document.menuManageForm.submit();   
	}
	
	
	function fMenuManageSelect()
	{ 
	    document.menuManageForm.action = "<c:url value='/sym/mpm/EgovMenuManageSelect.do'/>";
	    document.menuManageForm.submit();
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
    
    <form name="menuManageForm" action ="<c:url value='/sym/mnu/mpm/EgovMenuManageSelect.do'/>" method="post">
    <input name="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
	<input name="checkedMenuNoForDel" type="hidden" />
	<input name="req_menuNo" type="hidden"  />
    
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
												 <font color="#FFF"><spring:message code="space.manage.menulist.item.name" /> : </font>
								                <input name="searchKeyword" type="text" size="50" value="<c:out value='${searchVO.searchKeyword}'/>"  maxlength="60"/>  
								                <a class='AXButton Gray' href="#LINK" onclick="javascript:selectMenuManageList(); return false;"><spring:message code="space.manage.menulist.button.search" /></a>
		                                        <a class='AXButton Gray' href="<c:url value='/sym/mpm/EgovMenuRegistInsert.do'/>" onclick="insertMenuManage(); return false;"><spring:message code="space.manage.menulist.button.regist" /></a>
		                                        <a class='AXButton Gray' href="#LINK" onclick="fDeleteMenuList(); return false;"><spring:message code="space.manage.menulist.button.delete" /></a>
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
												<th><input type="checkbox" name="checkAll" id="checkAll" class="check2" onclick="javascript:fCheckAll();"/></th>
												<th><spring:message code="space.manage.menulist.item.no" /></th>
												<th><spring:message code="space.manage.menulist.item.name" /></th>
												<th><spring:message code="space.manage.menulist.item.filename" /></th>
												<th><spring:message code="space.manage.menulist.item.desc" /></th>
												<th><spring:message code="space.manage.menulist.item.parent" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="result" items="${list_menumanage}" varStatus="status">
											<tr>
												<td><input type="checkbox" name="checkField" class="check2"/><input name="checkMenuNo" type="hidden" value="<c:out value='${result.menuNo}'/>"/></td>
												<td><font color="#FFF"><c:out value="${result.menuNo}"/></font></td>
												<td><a href="<c:url value='/sym/mpm/EgovMenuManageListDetailSelect.do?req_menuNo='/>${result.menuNo}" onclick="selectUpdtMenuManageDetail('<c:out value="${result.menuNo}"/>'); return false;"><font color="#FFF"><c:out value="${result.menuNm}"/></font></a></td>
												<td><font color="#FFF"><c:out value="${result.progrmFileNm}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.menuDc}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.upperMenuId}"/></font></td>
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