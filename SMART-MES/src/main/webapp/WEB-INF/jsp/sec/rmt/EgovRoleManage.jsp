<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<meta http-equiv="content-language" content="ko">
<title><spring:message code="space.manage.role.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>

<script type="text/javaScript" language="javascript" defer="defer">
	
	$(function(){
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:340,autoShow:true});
	});

	
	function fncCheckAll()
	{
	    var checkField = document.listForm.delYn;
	    
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
	
	
	function fncManageChecked() 
	{
	    var checkField = document.listForm.delYn;
	    var checkId = document.listForm.checkId;
	    var returnValue = "";
	    var returnBoolean = false;
	    var checkCount = 0;
	    
	    if(checkField) 
	    {
	        if(checkField.length > 1) 
	        {
	            for(var i=0; i<checkField.length; i++) 
	            {
	                if(checkField[i].checked) 
	                {
	                    checkCount++;
	                    checkField[i].value = checkId[i].value;
	                    
	                    if(returnValue == "")
	                        returnValue = checkField[i].value;
	                    else 
	                        returnValue = returnValue + ";" + checkField[i].value;
	                }
	            }
	            
	            if(checkCount > 0) 
	                returnBoolean = true;
	            else 
	            {
	                alert("<spring:message code="space.manage.role.alert.noselect" />");
	                returnBoolean = false;
	            }
	        } 
	        else 
	        {
	            if(document.listForm.delYn.checked == false) 
	            {
	                alert("<spring:message code="space.manage.role.alert.noselect" />");
	                returnBoolean = false;
	            }
	            else 
	            {
	                returnValue = checkId.value;
	                returnBoolean = true;
	            }
	        }
	    } 
	    else 
	    {
	        alert("<spring:message code="space.manage.role.alert.noresult" />");
	    }
	
	    document.listForm.roleCodes.value = returnValue;
	    return returnBoolean;
	}
	
	
	function fncSelectRoleList(pageNo)
	{
	    document.listForm.searchCondition.value = "1";
	    document.listForm.pageIndex.value = pageNo;
	    document.listForm.action = "<c:url value='/sec/rmt/EgovRoleList.do'/>";
	    document.listForm.submit();
	}
	
	
	function fncSelectRole(roleCode) 
	{
	    document.listForm.roleCode.value = roleCode;
	    document.listForm.action = "<c:url value='/sec/rmt/EgovRole.do'/>";
	    document.listForm.submit();     
	}
	
	
	function fncAddRoleInsert() 
	{
	    location.replace("<c:url value='/sec/rmt/EgovRoleInsertView.do'/>"); 
	}
	
	
	function fncRoleListDelete() 
	{
	    if(fncManageChecked()) 
	    {
	        if(confirm("<spring:message code="space.common.deleteis" />")) 
	        {
	            document.listForm.action = "<c:url value='/sec/rmt/EgovRoleListDelete.do'/>";
	            document.listForm.submit();
	        }
	    }
	}
	
	
	function fncAddRoleView() 
	{
	    document.listForm.action = "<c:url value='/sec/rmt/EgovRoleUpdate.do'/>";
	    document.listForm.submit();     
	}
	
	
	function linkPage(pageNo)
	{
	    document.listForm.searchCondition.value = "1";
	    document.listForm.pageIndex.value = pageNo;
	    document.listForm.action = "<c:url value='/sec/rmt/EgovRoleList.do'/>";
	    document.listForm.submit();
	}
	
	
	function press() 
	{
	    if (event.keyCode==13) 
	    {
	        fncSelectRoleList('1');
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
    <!-- //header 끝 --> 
    
    <form:form name="listForm" action="<c:url value='/sec/rmt/EgovRoleList.do'/>" method="post">
    <input type="hidden" name="roleCode"/>
	<input type="hidden" name="roleCodes"/>
	<input type="hidden" name="pageIndex" value="<c:out value='${roleManageVO.pageIndex}'/>"/>
	<input type="hidden" name="searchCondition"/>
    
    
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
												<font color="#FFF"><spring:message code="space.manage.role.item.rolename" /> : </font>
								                <input name="searchKeyword" type="text" value="<c:out value='${roleManageVO.searchKeyword}'/>" size="25" onkeypress="press();" />  
								                <a class='AXButton Gray' href="#LINK" onclick="javascript:fncSelectRoleList('1')" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.search" /></a>
		                                        <a class='AXButton Gray' href="#LINK" onclick="javascript:fncAddRoleInsert()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.create" /></a>
		                                        <a class='AXButton Gray' href="#LINK" onclick="javascript:fncRoleListDelete()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="button.delete" /></a>
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
												<th><input type="checkbox" name="checkAll" id="checkAll" class="check2" onclick="javascript:fncCheckAll()"></th>
												<th><spring:message code="space.manage.role.item.roleid" /></th>
												<th><spring:message code="space.manage.role.item.rolename" /></th>
												<th><spring:message code="space.manage.role.item.roledesc" /></th>
												<th><spring:message code="space.manage.role.item.roleregdate" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="role" items="${roleList}" varStatus="status">
											<tr>
												<td><input type="checkbox" name="delYn" class="check2"><input type="hidden" name="checkId" value="<c:out value="${role.roleCode}"/>" /></td>
												<td><a href="#LINK" onclick="javascript:fncSelectRole('<c:out value="${role.roleCode}"/>')"><font color="#FFF"><c:out value="${role.roleCode}"/></font></a></td>
												<td><font color="#FFF"><c:out value="${role.roleNm}"/></font></td>
												<td><font color="#FFF"><c:out value="${role.roleDc}"/></font></td>
												<td><font color="#FFF"><c:out value="${role.roleCreatDe}"/></font></td>
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
		<!-- 페이지 네비게이션 시작 -->
	   <c:if test="${!empty roleManageVO.pageIndex }">
	   <table width="1000">
			<tr>
				<td>
					<div id="paging_div">
						<ul class="paging_align"><ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="linkPage" /></ul>
					</div>
				</td>
			</tr>
		</table>
	    </c:if>                   
	     <!-- //페이지 네비게이션 끝 -->
	</div>
	</form:form>

</div>
<!-- //전체 레이어 끝 -->
 </body>
</html>