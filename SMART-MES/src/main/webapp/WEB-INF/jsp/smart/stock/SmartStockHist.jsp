<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title><spring:message code="smart.stock.hist.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<style>
.main_table {
  width			   : 100%;
  border           : 1px solid #e3e6ec;
  border-collapse  : separate !important;
  border-spacing   : 0;
  text-align       : center;
  font-size        : 12pt;
  table-layout     : fixed;
  word-break       : break-all;
}
.main_table tr td {
  
  border           : 1px solid #e3e6ec;
  border-collapse  : separate !important;
  border-spacing   : 0;
  
}
 
.TIT_CONT_GRAY_A { font-size: 10pt; color: #000000; background-color: #FCE2A0; line-height: 14pt; font-weight: bold; text-align: center;}
.TIT_CONT_GRAY_B { font-size: 10pt; color: #000000; background-color: #D5D5AA; line-height: 14pt; font-weight: bold; text-align: center;}
.TIT_CONT_GRAY_C { font-size: 10pt; color: #000000; background-color: #95CAFF; line-height: 14pt; font-weight: bold; text-align: center;}
.BG_WHITE_C { font-size: 10pt; color: #000000; background-color: #FFFFFF; line-height: 14pt; text-align: center; ; text-decoration: none}
.BG_WHITE_LEFT   { font-size: 10pt; color: #000000; background-color: #FFFFFF; text-align: left; ; line-height: 14pt; text-decoration: none}
.BG_WHITE_RIGHT  {  font-size: 10pt; text-decoration: none; color: #000000; line-height: 12pt; background-color: #FFFFFF; text-align: right}

.BG_GRAY_C { font-size: 10pt; color: #000000; background-color: #DDDDDD; line-height: 14pt; text-align: center; ; text-decoration: none}
.BG_YELLOW_C { font-size: 10pt; color: #000000; background-color: #FFFFD4; line-height: 14pt; text-align: center; ; text-decoration: none}

</style>
<script>

	$(document).ready(function() {
		
		
		/**
			. 조회 버튼
			. parameter
			  - startDate -> searchStart
			  - endDate -> searchEnd
		*/
		$("#btn_search").click(function() {
			
			var startDate = document.dataForm.startDate.value.replace(/-/g,"");
			var endDate = document.dataForm.endDate.value.replace(/-/g,"");
			
			if(endDate < startDate)
			{
				alert("<spring:message code="space.common.alert.date.search.validate" />");
				return;
			}
			
			startDate = $("#startDate").val();
			endDate = $("#endDate").val();
			
			document.dataForm.searchStart.value = startDate.substring(0, startDate.lastIndexOf("-"));
			document.dataForm.searchEnd.value = endDate.substring(0, endDate.lastIndexOf("-"));
			
			document.dataForm.action="${pageContext.request.contextPath}/smart/stock/SmartStockHistData.do";
			document.dataForm.target = "dataFrame";
			document.dataForm.submit();
			
		});	//$("#btn_search").click
		
		
		
	});
	
	function scrollX() {
	    document.all.mainDisplayRock.scrollLeft = document.all.bottomLine.scrollLeft;
	    document.all.topLine.scrollLeft = document.all.bottomLine.scrollLeft;
	}

	function scrollY() {
	    document.all.leftDisplay.scrollTop = document.all.mainDisplayRock.scrollTop;
	    document.all.mainDisplayRock.scrollTop = document.all.leftDisplay.scrollTop;
	}
	
	function listMouseOver(obj) {
		$(obj).children("td").css("backgroundColor", "#FFD47F");
	}
	function listMouseOut(obj) {
		$(obj).children("td").css("backgroundColor", "");
	}
	
</script>
</head>
<body class="nav-fixed">
	<div>
		<div id="header"><c:import url="/EgovPageLink.do?link=main/nav/SmartHeaderNav" /></div>
	</div>
	<div id="layoutSidenav">
		<div>
			<div id="sidenav"><c:import url="/sym/mms/EgovMainSideNav.do" /></div>
		</div>
		<div id="layoutSidenav_content">
			<main>
				<header class="page-header page-header-dark bg-gradient-primary-to-secondary mb-4" id="headerTitle">
					<div class="container-fluid">
						<div class="page-header-content pt-4">
							<div class="row align-items-center justify-content-between">
								<div class="col-auto mt-4">
									<h1 class="page-header-title">
										<div class="page-header-icon"><i data-feather="database"></i></div>
										<span><spring:message code="smart.stock.hist.title" /></span>
									</h1>
								</div>
							</div>
						</div>
					</div>
				</header>
				<div class="container-fluid" id="dataContainer">
					<div class="btn btn-datatable btn-icon btn-transparent-dark mr-2" id="headerHide"><i data-feather="chevrons-up"></i></div>
					<div class="btn btn-datatable btn-icon btn-transparent-dark mr-2" id="headerView" style="display:none;"><i data-feather="chevrons-down"></i></div>
					<form name="dataForm" method="post">
						<input type="hidden" name="searchStart">
						<input type="hidden" name="searchEnd">
						<div class="card mb-4">
							<div class="card-header">
								<div class="btn btn-light btn-sm line-height-normal p-3" id="dateRange">
								    <i class="mr-2 text-primary" data-feather="calendar"></i>
								    <span></span>
								    <input type="hidden" name="startDate" id="startDate">
								    <input type="hidden" name="endDate" id="endDate">
								    <i class="ml-1" data-feather="chevron-down"></i>
								</div>
								&nbsp;
								<div class="btn btn-outline-primary" id="btn_search"><spring:message code="smart.common.button.search" /></div>
							</div>
							<div class="card-body">
								<div class="datatable table-responsive" style="float: left;width:35%;">
									<table id="data_table_head" cellpadding="0" cellspacing="0" border="0" style="width:100%;"> 
										
									</table>
								</div>
								<div class="datatable table-responsive" style="overflow-x: scroll;width:65%;">
									<table id="data_table_main" cellpadding="0" cellspacing="0" border="0" style="width:100%;"> 
										
									</table>
								</div>
							</div>
						</div>
					</form>
				</div>
			</main>
			<footer class="footer mt-auto footer-light">
				<div class="container-fluid">
					<div class="row">
						<c:import url="/EgovPageLink.do?link=main/nav/SmartFooter" />
					</div>
				</div>
			</footer>
		</div>
	</div>
	
<iframe name="dataFrame" width="0" height="0" style="visibility:hidden"></iframe>
	
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/datatables.js'/>"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-core.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/date-range-picker.js'/>"></script>

</body>
</html>