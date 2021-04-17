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
<title><spring:message code="smart.eqp.ratio" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>
<script type="text/javascript" src="<c:url value="/js/amcharts/core.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/amcharts/charts.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/amcharts/amtheme/animated.js"/>"/></script>

<script>
	
	var eqpCnt = 0;
	$(document).ready(function() {
		
		<c:forEach var="resultEqpInfo" items="${resultEqpInfo}" varStatus="eqpInfoStatus">
			eqpCnt++;
		</c:forEach>
		
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		
		/**
			. 조회 버튼 클릭
			. parameter
			   - startDate
			   - endDate
		*/
		$("#btn_search").click(function() {
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/eqp/SmartPxEqpRatioData.do",
				data : {"startDate":startDate, "endDate":endDate},
				type : "POST",
				datatype : "json",
				success : function(data) {
					
					// Themes begin
					am4core.useTheme(am4themes_animated);
					// Themes end

					// Create chart instance
					var chart = am4core.create("eqpRatioChart", am4charts.XYChart);
					
					var chartData = [];
					var chartTempData = [];
					var chartEqpCnt = 0;
					var chartEqpList = [];
					var chartEqpVal = [];
					$.each(data, function(index, value){
						
						chartEqpCnt++;
						
						if(chartEqpCnt == 1) {
							
							chartEqpList.push("date");
							chartEqpVal.push(value.LEGEND_DATE);
							chartEqpList.push(value.EQP_NAME);
							chartEqpVal.push(value.ACTIVE_TIME_RATE);
							
						} else if(chartEqpCnt == eqpCnt) {
							
							chartEqpList.push(value.EQP_NAME);
							chartEqpVal.push(value.ACTIVE_TIME_RATE);
							for(idx in chartEqpList) {
								chartTempData[chartEqpList[idx]] = chartEqpVal[idx];
							}
							chartData.push(chartTempData);
							
							chartEqpCnt = 0;
							chartEqpList = [];
							chartEqpVal = [];
							chartTempData = [];
						} else {
							chartEqpList.push(value.EQP_NAME);
							chartEqpVal.push(value.ACTIVE_TIME_RATE);
						}
						
						
					});
					
					for(var i=0; i<chartData.length; i++) {
						console.log(chartData[i]);
					}
					
					// Add data
					chart.data = chartData;

					// Set input format for the dates
					chart.dateFormatter.inputDateFormat = "yyyy-MM-dd";

					// Create axes
					var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
					var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
					
					<c:forEach var="resultEqpInfo" items="${resultEqpInfo}" varStatus="eqpStatus">
						
						addSeries("${resultEqpInfo.EQP_NAME}");
						
					</c:forEach>
					
					// Add chart cursor
					chart.cursor = new am4charts.XYCursor();
					chart.cursor.behavior = "zoomY";
					
					// Add legend
					chart.legend = new am4charts.Legend();
					chart.legend.itemContainers.template.events.on("over", function(event){
					  var segments = event.target.dataItem.dataContext.segments;
					  segments.each(function(segment){
					    segment.isHover = true;
					  })
					})

					chart.legend.itemContainers.template.events.on("out", function(event){
					  var segments = event.target.dataItem.dataContext.segments;
					  segments.each(function(segment){
					    segment.isHover = false;
					  })
					})

					//Value Axis Fixed Scale 
					valueAxis.min = 0;
					valueAxis.max = 100;
					
					
					function addSeries(eqpname) {
						var series = chart.series.push(new am4charts.LineSeries());
						series.dataFields.valueY = eqpname;
						series.dataFields.dateX = "date";
						series.name = eqpname;
						series.bullets.push(new am4charts.CircleBullet());
						series.tooltipText = "{dateX}: {valueY}";
						series.legendSettings.valueText = "{valueY}";
						
						let hs = series.segments.template.states.create("hover")
						hs.properties.strokeWidth = 5;
						series.segments.template.strokeWidth = 1;
					}
					
				}	//success
			});	//$.ajax
			
		});	//$("#btn_search").click
		
		
		
	});
	
		
	
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
			<main class="main-container">
				<header class="page-header page-header-dark bg-gradient-primary-to-secondary mb-4" id="headerTitle">
					<div class="container-fluid">
						<div class="page-header-content pt-4">
							<div class="row align-items-center justify-content-between">
								<div class="col-auto mt-4">
									<h1 class="page-header-title">
										<div class="page-header-icon"><i data-feather="database"></i></div>
										<span><spring:message code="smart.eqp.ratio" /></span>
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
						<input type="hidden" name="modelid" id="modelid">
						<div class="card mb-4">
							<div class="card card-header-actions">
								<div class="card-header">
									<div>
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
									&nbsp;
									<div>
										<spring:message code="smart.eqp.ratio.average" /> : 
										<span id="avgRatio"></span>
									</div>
								</div>
								<div class="card-body">
									
									<div class="chart-area" id="eqpRatioChart"></div>
									
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
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-core.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/date-range-picker.js'/>"></script>

<script>
	$(document).ready(function() {
		$("#btn_search").trigger("click");
	})
</script>

</body>
</html>