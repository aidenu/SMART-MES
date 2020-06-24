<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<meta http-equiv="content-language" content="ko">
<title><spring:message code="space.manage.user.title" /></title>
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
		var div_height = document.body.clientHeight-200;
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:div_height,autoShow:true});
	});
	
	function fnCheckAll()
	{
	    var checkField = document.listForm.checkField;
	    
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
	
	
	function fnDeleteUser()
	{
	    var checkField = document.listForm.checkField;
	    var id = document.listForm.checkId;
	    var checkedIds = "";
	    var checkedCount = 0;
	    
	    if(checkField)
	    {
	        if(checkField.length > 1)
	        {
	            for(var i=0; i < checkField.length; i++)
	            {
	                if(checkField[i].checked)
	                {
	                    checkedIds += ((checkedCount==0? "" : ",") + id[i].value);
	                    checkedCount++;
	                }
	            }
	        }
	        else
	       {
	            if(checkField.checked)
	            {
	                checkedIds = id.value;
	            }
	        }
	    }
	    
	    if(checkedIds.length > 0)
	    {
	        //alert(checkedIds);
	        if(confirm("<spring:message code="common.delete.msg" />"))
	        {
	            document.listForm.checkedIdForDel.value=checkedIds;
	            document.listForm.action = "<c:url value='/uss/umt/user/EgovUserDelete.do'/>";
	            document.listForm.submit();
	        }
	    }
	    else
	    {
	    	alert("<spring:message code="space.manage.user.alert.delete" />");
	    }
	}
	
	
	function fnSelectUser(id)
	{
	    document.listForm.selectedId.value = id;
	    array = id.split(":");
	    
	    if(array[0] == "")
	    {
	    }
	    else
	    {
	        userTy = array[0];
	        userId = array[1];    
	    }
	    
	    document.listForm.selectedId.value = userId;
	    document.listForm.action = "<c:url value='/uss/umt/user/EgovUserSelectUpdtView.do'/>";
	    document.listForm.submit();
	}
	
	
	function fnAddUserView()
	{
	    document.listForm.action = "<c:url value='/uss/umt/user/EgovUserInsertView.do'/>";
	    document.listForm.submit();
	}
	
	
	function fnLinkPage(pageNo)
	{
	    document.listForm.pageIndex.value = pageNo;
	    document.listForm.action = "<c:url value='/uss/umt/user/EgovUserManage.do'/>";
	    document.listForm.submit();
	}
	
	
	function fnSearch()
	{
	    document.listForm.pageIndex.value = 1;
	    document.listForm.action = "<c:url value='/uss/umt/user/EgovUserManage.do'/>";
	    document.listForm.submit();
	}
	
	
	function fnViewCheck()
	{ 
	    if(insert_msg.style.visibility == 'hidden'){
	        insert_msg.style.visibility = 'visible';
	    }else{
	        insert_msg.style.visibility = 'hidden';
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
    
    
    <!-- container 시작 -->
    <form name="listForm" action="<c:url value='/uss/umt/user/EgovUserManage.do'/>" method="post">
	<input type="submit" id="invisible" class="invisible"/>
	<input name="selectedId" type="hidden" />
	<input name="checkedIdForDel" type="hidden" />
	<input name="sbscrbSttus" type="hidden" value="0" />
	<input name="pageIndex" type="hidden" value="<c:out value='${userSearchVO.pageIndex}'/>"/>
				        
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
											<td align="center" style="background-color: #2c3338;">
												 <select name="searchCondition" id="searchCondition">
								                    <option value="0" <c:if test="${userSearchVO.searchCondition == '0'}">selected="selected"</c:if> >ID</option>
								                    <option value="1" <c:if test="${empty userSearchVO.searchCondition || userSearchVO.searchCondition == '1'}">selected="selected"</c:if> >Name</option>
								                </select>
								                <input name="searchKeyword" type="text" value="<c:out value="${userSearchVO.searchKeyword}"/>" />
								                <a class='AXButton Gray' href="<c:url value='/uss/umt/user/EgovUserManage.do'/>" onclick="javascript:fnSearch(); return false;"><spring:message code="button.search" /></a>
		                                    	<a class='AXButton Gray' href="#LINK" onclick="javascript:fnDeleteUser(); return false;"><spring:message code="button.delete" /></a>
		                                    	<%-- <c:if test="${userreg_able eq 'YES'}"> // 사용자 등록 수가 제한수를 넘으면 등록 버튼을 감춘다--%>
		                                    		<a class='AXButton Gray' href="<c:url value='/uss/umt/user/EgovUserInsertView.do'/>" onclick="fnAddUserView(); return false;"><spring:message code="button.create" /></a>
		                                    	<%-- </c:if> --%>
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
												<th><input name="checkAll" id="checkAll" type="checkbox" title="Check All" onclick="javascript:fnCheckAll();"/></th>
												<th><spring:message code="space.manage.user.item.id" /></th>
												<th><spring:message code="space.manage.user.item.name" /></th>
												<th><spring:message code="space.manage.user.item.email" /></th>
												<th><spring:message code="space.manage.user.item.phone" /></th>
												<th><spring:message code="space.manage.user.item.regdate" /></th>
											</tr>
										</thead>
										<tbody>
											 <c:forEach var="result" items="${resultList}" varStatus="status">
											<tr>
												<td>
													<input name="checkField" title="Check <c:out value="${status.count}"/>" type="checkbox"/>
					                        		<input name="checkId" type="hidden" value="<c:out value='${result.userTy}'/>:<c:out value='${result.uniqId}'/>"/>
												</td>
												<td><span class="link"><a href="<c:url value='/uss/umt/user/EgovUserSelectUpdtView.do'/>?selectedId=<c:out value="${result.uniqId}"/>"  onclick="javascript:fnSelectUser('<c:out value="${result.userTy}"/>:<c:out value="${result.uniqId}"/>'); return false;"><font color="#FFF"><c:out value="${result.userId}"/></font></a></span></td>
												<td><font color="#FFF"><c:out value="${result.userNm}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.emailAdres}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.moblphonNo}"/></font></td>
												<td><font color="#FFF"><c:out value="${result.sbscrbDe}"/></font></td>
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
	    <%-- <c:if test="${!empty userSearchVO.pageIndex }">
	   <table width="1000">
			<tr>
				<td>
					<div id="paging_div">
						<ul class="paging_align"><ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="linkPage" /></ul>
					</div>
				</td>
			</tr>
		</table>
	    </c:if>                   --%>   
	     <!-- //페이지 네비게이션 끝 -->
	</div>
	</form>

</div>
    <!-- //전체 레이어 끝 -->
 </body>
</html>