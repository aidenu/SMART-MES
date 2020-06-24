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

<title><spring:message code="space.manage.program.title" /></title>
<link rel="shortcut icon" href="<c:url value='/'/>images/bl_circle.gif">
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/table.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/space/AXButton.css'/>" rel="stylesheet" type="text/css" >

<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>

<script language="javascript1.2"  type="text/javaScript"> 
	
	$(function(){
		$('#data_table').fixedHeaderTable({ fixedColumn: true,height:420,autoShow:true});
	});
	
	
	function linkPage(pageNo)
	{
		document.progrmManageForm.pageIndex.value = pageNo;
		document.progrmManageForm.action = "<c:url value='/sym/prm/EgovProgramListSearch.do'/>";
	   	document.progrmManageForm.submit();
	}
	
	 
	function selectProgramListSearch() 
	{ 
		document.progrmManageForm.pageIndex.value = 1;
		document.progrmManageForm.action = "<c:url value='/sym/prm/EgovProgramListSearch.do'/>";
		document.progrmManageForm.submit();
	}
	
	 
	function choisProgramListSearch(vFileNm) 
	{ 
		eval("opener.document.all."+opener.document.all.tmp_SearchElementName.value).value = vFileNm;
		
		if(opener.document.all.progrmFileNm_view)
		{
			opener.document.all.progrmFileNm_view.value = vFileNm;
		}
		
	    window.close();
	}
	
	
</script>
</head>
<body style="background-color: #2c3338;"> 

<!-- 전체 레이어 시작 -->
<div id="wrap">
    
    <form name="progrmManageForm" action ="<c:url value='/sym/prm/EgovProgramListSearch.do'/>" method="post">
    <input type="submit" id="invisible" class="invisible"/>
	<input name="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
    
    <div id="spacecontainer">
		<table width="100%">
			<tr><td colspan="3" height="3"></td></tr>
			<tr>
				<td valign="top">
					<table>
						<tr>
							<td width="*">
								<div style="width:700px;border: 1px solid #D5D1B0;">
									<table width="100%">
										<tr>
											<td id="captionSubTitle" align="center" style="background-color: #2c3338;">
												 <font color="#FFF"><spring:message code="space.manage.program.item.hangulname" /> : </font>
								                <input name="searchKeyword" type="text" size="30" value=""  maxlength="60">
								                <a class='AXButton Gray' href="#LINK" onclick="javascript:selectProgramListSearch(); return false;"><spring:message code="button.search" /></a>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="3">
								<div class="tableContainer" style="width:700px;">
									<table id="data_table" class="fancyTable"> 
										<thead>
											<tr>
												<th><spring:message code="space.manage.program.item.filename" /></th>
												<th><spring:message code="space.manage.program.item.hangulname" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="result" items="${list_progrmmanage}" varStatus="status">
											<tr>
												<td><a href="#LINK" onclick="choisProgramListSearch('<c:out value="${result.progrmFileNm}"/>'); return false;"><font color="#FFF"><c:out value="${result.progrmFileNm}"/></font></a></td>
												<td><font color="#FFF"><c:out value="${result.progrmKoreanNm}"/></font></td>
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

