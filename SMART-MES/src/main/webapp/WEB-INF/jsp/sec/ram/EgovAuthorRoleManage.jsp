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
<title><spring:message code="space.manage.auth.title" /></title>
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
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:336,autoShow:true});
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
	    var checkRegYn = document.listForm.regYn;
	    var checkOldRegYn = document.listForm.old_regYn;
	    var returnValue = "";
	    var returnRegYns = "";
	    var checkedCount = 0;
	    var returnBoolean = false;
	
	    if(checkField) 
	    {
	        if(checkField.length > 1) 
	        {
	            for(var i=0; i<checkField.length; i++) 
	            {
	            	if(checkOldRegYn[i].value == "Y" && checkRegYn[i].value == "Y")
	            	{
	            		// 처음 값이 등록인데 바뀐값도 등록이면 중복 등록 되므로 PASS
	            	}
	            	else
	            	{
		                if(checkField[i].checked) 
		                {
		                    checkedCount++;
		                    checkField[i].value = checkId[i].value;
		                
		                    if(returnValue == "") 
		                    {
		                        returnValue = checkField[i].value;
		                        returnRegYns = checkRegYn[i].value;
		                    }
		                    else 
		                    { 
		                        returnValue = returnValue + ";" + checkField[i].value;
		                        returnRegYns = returnRegYns + ";" + checkRegYn[i].value;
		                    }
		                }
	            	}
	            }
	
	            if(checkedCount > 0) 
	                returnBoolean = true;
	            else 
	            {
	                alert("<spring:message code="space.manage.auth.alert.norole" />");
	                returnBoolean = false;
	            }
	        } 
	        else 
	        {
	             if(document.listForm.delYn.checked == false) 
	             {
	                alert("<spring:message code="space.manage.auth.alert.norole" />");
	                returnBoolean = false;
	            }
	            else 
	            {
	            	if(checkOldRegYn.value == "Y" && checkRegYn.value == "Y")
	            	{
	            		// 처음 값이 등록인데 바뀐값도 등록이면 중복 등록 되므로 PASS
	            	}
	            	else
	            	{
		                returnValue = checkId.value;
		                returnRegYns = checkRegYn.value;
	            	}
	
	                returnBoolean = true;
	            }
	        }
	    } 
	    else 
	    {
	        alert("<spring:message code="space.manage.auth.alert.noresult" />");
	    }
	
	    document.listForm.roleCodes.value = returnValue;
	    document.listForm.regYns.value = returnRegYns;
	
	    return returnBoolean;
	}

	
	function fncSelectAuthorRoleList() 
	{
	    document.listForm.searchCondition.value = "1";
	    document.listForm.pageIndex.value = "1";
	    document.listForm.action = "<c:url value='/sec/ram/EgovAuthorRoleList.do'/>";
	    document.listForm.submit();
	}
	
	
	function fncSelectAuthorList()
	{
	    document.listForm.searchKeyword.value = "";
	    document.listForm.action = "<c:url value='/sec/ram/EgovAuthorList.do'/>";
	    document.listForm.submit();
	}
	
	
	function fncSelectAuthorRole(roleCode) 
	{
	    document.listForm.roleCode.value = roleCode;
	    document.listForm.action = "<c:url value='/sec/ram/EgovRole.do'/>";
	    document.listForm.submit();     
	}
	
	
	function fncAddAuthorRoleInsert() 
	{
	    if(fncManageChecked()) 
	    {
	        if(confirm("<spring:message code="space.common.insertis" />")) 
	        {
	            document.listForm.action = "<c:url value='/sec/ram/EgovAuthorRoleInsert.do'/>";
	            document.listForm.submit();
	        }
	    } 
	    else 
	    	return;
	}
	
	
	function linkPage(pageNo)
	{
	    document.listForm.searchCondition.value = "1";
	    document.listForm.pageIndex.value = pageNo;
	    document.listForm.action = "<c:url value='/sec/ram/EgovAuthorRoleList.do'/>";
	    document.listForm.submit();
	}
	
	
	function press() 
	{
	    if (event.keyCode==13) 
	    {
	        fncSelectAuthorRoleList();
	    }
	}
	
	function showHelp()
	{
		alert("<spring:message code="space.manage.auth.alert.help" />");
	}

</script>

</head>

<body>

<!-- 전체 레이어 시작 -->
<div id="wrap">
    <!-- header 시작 -->
    <div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
    <div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>    
    <div id="subnavi"><c:import url="/sym/mms/EgovMainMenuSub.do" /></div>    
    <!-- //header 끝 --> 
    
    <form:form name="listForm" action="<c:url value='/sec/ram/EgovAuthorRoleList.do'/>" method="post">
    <input type="hidden" name="roleCodes"/>
	<input type="hidden" name="regYns"/>
	<input type="hidden" name="pageIndex" value="<c:out value='${authorRoleManageVO.pageIndex}'/>"/>
	<input type="hidden" name="authorCode" value="<c:out value="${authorRoleManageVO.searchKeyword}"/>"/>
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
											<td id="captionSubTitle" align="center">
												 <spring:message code="space.manage.auth.item.code" /> : 
								                <input name="searchKeyword" type="text" size="30" value="<c:out value='${authorRoleManageVO.searchKeyword}'/>" onkeypress="press();" readonly="readonly" /> 
								                <a class='AXButton Green' href="#LINK" onclick="javascript:fncSelectAuthorList()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="space.manage.auth.button.authlist" /></a>
		                                        <a class='AXButton Green' href="#LLINK" onclick="javascript:fncSelectAuthorRoleList()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="space.manage.auth.button.authresearch" /></a> 
		                                        <a class='AXButton Green' href="#LINK" onclick="javascript:fncAddAuthorRoleInsert()" style="selector-dummy:expression(this.hideFocus=false);"><spring:message code="space.manage.auth.button.regist" /></a>
		                                        <a href="#" onclick="javascript:showHelp()"><img src="<c:url value='/'/>images/png/help.png" width="20" height="20" style="cursor:hand"></a>
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
												<th><spring:message code="space.manage.auth.item.roleid" /></th>
												<th><spring:message code="space.manage.auth.item.rolename" /></th>
												<th><spring:message code="space.manage.auth.item.roledesc" /></th>
												<th><spring:message code="space.manage.auth.item.regdate" /></th>
												<th><spring:message code="space.manage.auth.item.regflag" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="authorRole" items="${authorRoleList}" varStatus="status">
											<tr>
												<td><input type="checkbox" name="delYn" class="check2"><input type="hidden" name="checkId" value="<c:out value="${authorRole.roleCode}"/>" /></td>
												<td><c:out value="${authorRole.roleCode}"/></td>
												<td><c:out value="${authorRole.roleNm}"/></td>
												<td><c:out value="${authorRole.roleDc}"/></td>
												<td><c:out value="${authorRole.creatDt}"/></td>
												<td>
													<select name="regYn">
											            <option value="Y" <c:if test="${authorRole.regYn == 'Y'}">selected</c:if> >Y</option>
											            <option value="N" <c:if test="${authorRole.regYn == 'N'}">selected</c:if> >N</option>
											        </select>
											        <input type="hidden" name="old_regYn" value="${authorRole.regYn}">
												</td>
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
		<c:if test="${!empty authorRoleManageVO.pageIndex }">
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
	
	<!-- footer 시작 -->
    <div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div>
    <!-- //footer 끝 -->
</div>
<!-- //전체 레이어 끝 -->
 </body>
</html>