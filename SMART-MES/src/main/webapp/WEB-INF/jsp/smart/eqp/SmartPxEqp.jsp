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
<title><spring:message code="smart.eqp.status.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<link href="<c:url value='/css/jquery/Chart.min.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>
<script type="text/javascript" src="<c:url value="/js/amcharts/core.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/amcharts/charts.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/amcharts/amtheme/animated.js"/>"/></script>

<style>

	.eqp-tab-cls {
		padding-top: 0px !important;
		padding0-bottom: 0px !important;
	}
</style>

<script>
	
	var stopFlag = ["0"];
	var activeFlag = ["3"];
	//var readyFlag = ["1", "4", "5", "6", "7", "20", "21", "30", "90"];		//active, error 상태 외에는 전부 ready
	var errorFlag = ["2"];
	
	var eqpArray = new Array();
	
	var headerHtml = "";
	var bodyHtml = "";

	function getHeaderData() {
		
		$.ajax({
			url : "${pageContext.request.contextPath}/smart/eqp/SmartPxEqpHeaderData.do",
			data : "",
			type : "POST",
			datatype : "json",
			success : function(data) {
				
				headerHtml += "<div class='nav nav-pills nav-justified flex-column flex-xl-row nav-wizard' id='cardTab' role='tablist'>";
				$.each(data, function(index, value){
					
					if(index == 0) {
						headerHtml += "		<a class='nav-item nav-link active' id='"+value.EQP_NAME+"-tab' href='#"+value.EQP_NAME+"' data-toggle='tab' role='tab' aria-controls='wizard1' aria-selected='true'>";
					} else {
						headerHtml += "		<a class='nav-item nav-link' id='"+value.EQP_NAME+"-tab' href='#"+value.EQP_NAME+"' data-toggle='tab' role='tab' aria-controls='wizard1' aria-selected='true'>";
					}
					
					if(activeFlag.indexOf(value.EQP_FLAG) > -1) {
						headerHtml += "			<i class='fas fa-circle fa-2x mr-1 text-green'></i>";
					} else if(errorFlag.indexOf(value.EQP_FLAG) > -1) {
						headerHtml += "			<i class='fas fa-circle fa-2x mr-1 text-red'></i>";
					} else if(stopFlag.indexOf(value.EQP_FLAG) > -1) {
						headerHtml += "			<i class='fas fa-circle fa-2x mr-1 text-gray'></i>";
					} else{
						headerHtml += "			<i class='fas fa-circle fa-2x mr-1 text-yellow'></i>";
					}
					
					headerHtml += "			<div class='wizard-step-text'>";
					headerHtml += "				<div class='wizard-step-text-name'>"+value.EQP_NAME+"</div>";
					headerHtml += "			</div>";
					headerHtml += "		</a>";
					
					eqpArray.push(value.EQP_NAME);
					
				});	//$.each
				headerHtml += "</div>";
				

				$("#data_header").empty();
				$("#data_header").append(headerHtml);
				
				
				bodyHtml += "<div class='tab-content' id='cardTabContent'>";
				$.each(data, function(index, value) {
					
					bodyHtml += "	<div class='eqp-tab-cls tab-pane py-5 py-xl-10 fade show active' id='"+value.EQP_NAME+"' role='tabpanel' aria-labelledby='"+value.EQP_NAME+"-tab'>";
					bodyHtml += "	    <div class='row justify-content-center'>";
					bodyHtml += "	        <div class='col-xxl-11 col-xl-12'>";
					bodyHtml += "				<h3 class='text-primary'>"+value.EQP_NAME+"</h3>";
					bodyHtml += "				<div class='row'>";

					bodyHtml += "					<div class='col-lg-4'>";
		            bodyHtml += "						<div class='card mb-4'>";
		       		bodyHtml += "							<div class='card-header'><spring:message code="smart.eqp.status.pie.title" /></div>";
					bodyHtml += "							<div class='card-body'>";
					bodyHtml += "								<div class='chart-pie' id='"+value.EQP_NAME+"_pie'></div>";
					bodyHtml += "							</div>";
					bodyHtml += "							<div class='card-footer small text-muted'></div>";
					bodyHtml += "						</div>";
					bodyHtml += "					</div>";
					
					bodyHtml += "					<div class='col-lg-8'>";
					bodyHtml += "						<div class='card mb-4'>";
		       		bodyHtml += "							<div class='card-header'><spring:message code="smart.eqp.status.timeline.title" /></div>";
					bodyHtml += "							<div class='card-body'>";
					bodyHtml += "								<div class='chart-bar' id='"+value.EQP_NAME+"_timeline'></div>";
					bodyHtml += "							</div>";
					bodyHtml += "							<div class='card-footer small text-muted'></div>";
					bodyHtml += "						</div>";
					bodyHtml += "					</div>";
					
				    bodyHtml += "				</div>";
				    bodyHtml += "	        </div>";
					bodyHtml += "	    </div>";	//<div class='row justify-content-center'
					bodyHtml += "	</div>";	//<div class='tab-pane'
					
				});	//$.each
				bodyHtml += "</div>";	//<div class='tab-content' id='cardTabContent'>

				parent.$("#data_body").empty();
				parent.$("#data_body").append(bodyHtml);
				
			},	//success
			complete : function() {
				getStackData();
			}
		});	//$.ajax
		
		
	}
	
	function getStackData() {
		
		$.ajax({
			url : "${pageContext.request.contextPath}/smart/eqp/SmartPxEqpStackData.do",
			data : "",
			type : "POST",
			datatype : "json",
			success : function(data) {
				
				
				for(var i=0; i<eqpArray.length; i++) {
					
					// Themes begin
					am4core.useTheme(am4themes_animated);
					// Themes end

					// Create chart instance
					var chart = am4core.create(eqpArray[i]+"_pie", am4charts.PieChart);
					
					//chart.data json 형태로 변환
					var chartData = [];
					$.each(data, function(index, value){
						
						if(eqpArray[i] == value.EQP_NAME_VIEW) {
							
							if(value.ACTIVE_TIME != 0) {
								chartData.push({
									"STATUS": "ACTIVE",
			 					    "TIME": value.ACTIVE_TIME,
			 					    "color": "#00AC69"
								});
							}
							
							if(value.READY_TIME != 0) {
								chartData.push({
									"STATUS": "READY",
			 					    "TIME": value.READY_TIME,
			 					    "color": "#F4A100"
								});
							}
							
							if(value.ERROR_TIME != 0) {
								chartData.push({
									"STATUS": "ERROR",
			 					    "TIME": value.ERROR_TIME,
			 					    "color": "#E81500"
								});
							}
							
							if(value.STOP_TIME != 0) {
								chartData.push({
									"STATUS": "STOPPED",
			 					    "TIME": value.STOP_TIME,
			 					    "color": "#687281"
								});
							}
							
						}
					});
					chart.data = chartData;
					
					// Add and configure Series
					var pieSeries = chart.series.push(new am4charts.PieSeries());
					pieSeries.dataFields.value = "TIME";
					pieSeries.dataFields.category = "STATUS";
					pieSeries.slices.template.propertyFields.fill = "color";

					// Let's cut a hole in our Pie chart the size of 30% the radius
					chart.innerRadius = am4core.percent(30);

					// Put a thick white border around each Slice
					pieSeries.slices.template.stroke = am4core.color("#fff");
					pieSeries.slices.template.strokeWidth = 2;
					pieSeries.slices.template.strokeOpacity = 1;
					pieSeries.slices.template
					  // change the cursor on hover to make it apparent the object can be interacted with
					  .cursorOverStyle = [
					    {
					      "property": "cursor",
					      "value": "pointer"
					    }
					  ];
					
					
					pieSeries.ticks.template.disabled = true;
					pieSeries.alignLabels = false;
					pieSeries.labels.template.text = "{value.value}H";
					pieSeries.labels.template.radius = am4core.percent(-40);
					pieSeries.labels.template.fill = "#FFFFFF";

					pieSeries.labels.template.adapter.add("radius", function(radius, target) {
					  if (target.dataItem && (target.dataItem.values.value.percent < 10)) {
					    return 0;
					  }
					  return radius;
					});

					pieSeries.labels.template.adapter.add("fill", function(color, target) {
					  if (target.dataItem && (target.dataItem.values.value.percent < 10)) {
					    return am4core.color("#000000");
					  }
					  return color;
					});
					
					// Create a base filter effect (as if it's not there) for the hover to return to
					var shadow = pieSeries.slices.template.filters.push(new am4core.DropShadowFilter);
					shadow.opacity = 0;

					// Create hover state
					var hoverState = pieSeries.slices.template.states.getKey("hover"); // normally we have to create the hover state, in this case it already exists

					// Slightly shift the shadow and make it more prominent on hover
					var hoverShadow = hoverState.filters.push(new am4core.DropShadowFilter);
					hoverShadow.opacity = 0.7;
					hoverShadow.blur = 5;

					// Add a legend
// 					chart.legend = new am4charts.Legend();

				}	//for(var i=0; i<eqpArray.length; i++)
				
			},	//success
			complete : function() {
				getTimelineData();
			}
			
		});	//$.ajax
		
	}
	
	function getTimelineData() {
		
		$.ajax({
			url : "${pageContext.request.contextPath}/smart/eqp/SmartPxEqpTimelinekData.do",
			data : "",
			type : "POST",
			datatype : "json",
			success : function(data) {
				var today = new Date();
				var year = today.getFullYear();
				var month = today.getMonth();
				var day = today.getDate();
				
				for(var i=0; i<eqpArray.length; i++) {

					var activeCnt = 0;
					var readyCnt = 0;
					var errorCnt = 0;
					var stopCnt = 0;
					
					//chart.data json 형태로 변환
					var colorSet = new am4core.ColorSet();
					colorSet.saturation = 0.4;
					
					var chartData = [];
					$.each(data, function(index, value){
						
						if(eqpArray[i] == value.EQP_NAME) {
							
							if(value.EQP_STATUS == "ACTIVE") {
								chartData.push({
									"name": value.EQP_STATUS,
			 					    "fromDate": value.BEFORE_EVENT_TIME,
			 					    "toDate": value.EVENT_TIME,
									"color": "#00AC69"
								});
								activeCnt++;
							} else if(value.EQP_STATUS == "READY") {
								chartData.push({
									"name": value.EQP_STATUS,
			 					    "fromDate": value.BEFORE_EVENT_TIME,
			 					    "toDate": value.EVENT_TIME,
									"color": "#F4A100"
								});
								readyCnt++;
							} else if(value.EQP_STATUS == "ERROR") {
								chartData.push({
									"name": value.EQP_STATUS,
			 					    "fromDate": value.BEFORE_EVENT_TIME,
			 					    "toDate": value.EVENT_TIME,
									"color": "#E81500"
								});
								errorCnt++;
							} else if(value.EQP_STATUS == "STOPPED") {
								chartData.push({
									"name": value.EQP_STATUS,
			 					    "fromDate": value.BEFORE_EVENT_TIME,
			 					    "toDate": value.EVENT_TIME,
									"color": "#687281"
								});
								stopCnt++;
							} else {
								chartData.push({
									"name": value.EQP_STATUS,
			 					    "fromDate": value.BEFORE_EVENT_TIME,
			 					    "toDate": value.EVENT_TIME,
									"color": "#FFFFFF"
								});
							}
							
						}
						
					});

					if(activeCnt == 0) {
						chartData.push({
							"name": "ACTIVE",
	 					    "fromDate": year+"-"+(month+1)+"-"+day+" 00:00",
	 					    "toDate": year+"-"+(month+1)+"-"+day+" 00:00",
							"color": "#00AC69"
						});
					}
					
					if(readyCnt == 0) {
						chartData.push({
							"name": "READY",
	 					    "fromDate": year+"-"+(month+1)+"-"+day+" 00:00",
	 					    "toDate": year+"-"+(month+1)+"-"+day+" 00:00",
							"color": "#F4A100"
						});
					}
					
					if(errorCnt == 0) {
						chartData.push({
							"name": "ERROR",
	 					    "fromDate": year+"-"+(month+1)+"-"+day+" 00:00",
	 					    "toDate": year+"-"+(month+1)+"-"+day+" 00:00",
							"color": "#E81500"
						});
					}
					
					if(stopCnt == 0) {
						chartData.push({
							"name": "STOPPED",
	 					    "fromDate": year+"-"+(month+1)+"-"+day+" 00:00",
	 					    "toDate": year+"-"+(month+1)+"-"+day+" 00:00",
							"color": "#687281"
						});
					}
					
					am4core.useTheme(am4themes_animated);

					var chart = am4core.create(eqpArray[i]+"_timeline", am4charts.XYChart);
					chart.hiddenState.properties.opacity = 0; // this creates initial fade-in

					chart.paddingRight = 30;
					chart.dateFormatter.inputDateFormat = "yyyy-MM-dd HH:mm";
					
					chart.data = chartData;
					
					//Y Axis
					var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
					categoryAxis.dataFields.category = "name";
					categoryAxis.renderer.grid.template.location = 0;
					categoryAxis.renderer.labels.template.disabled = true;
					categoryAxis.renderer.inversed = true;
					
					//X Axis
					var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
					dateAxis.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm";
					dateAxis.renderer.minGridDistance = 80;
					dateAxis.baseInterval = { count: 30, timeUnit: "minute" };
					dateAxis.max = new Date(year, month, day, 24, 0, 0, 0).getTime();
					dateAxis.strictMinMax = true;
					dateAxis.renderer.tooltipLocation = 0;
					
					//
					var series1 = chart.series.push(new am4charts.ColumnSeries());
					series1.columns.template.width = am4core.percent(80);
					series1.columns.template.tooltipText = "{name}: {openDateX} - {dateX}";
					series1.dataFields.openDateX = "fromDate";
					series1.dataFields.dateX = "toDate";
					series1.dataFields.categoryY = "name";
					series1.columns.template.propertyFields.fill = "color"; // get color from data
					series1.columns.template.propertyFields.stroke = "color";
					series1.columns.template.strokeOpacity = 1;

				}
				removeTab();
			}	//success
		});	//$.ajax
		
	}

	function removeTab(){
		for(var i=0; i<eqpArray.length; i++) {
			if(i != 0) {
				$("#"+eqpArray[i]).removeClass("show");
				$("#"+eqpArray[i]).removeClass("active");
			}
		}
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
										<div class="page-header-icon"><i data-feather="cpu"></i></div>
										<span><spring:message code="smart.eqp.status.title" /></span>
									</h1>
									&nbsp; &nbsp; &nbsp;<img src="<c:url value='/'/>images/smart/progressdisc.gif" width="15" height="15" border="0">
									<span id="reloadTime"></span>
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
							<div class="card-header" id="data_header">
								
							</div>
							<div class="card-body" id="data_body">
								
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
	
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/components/prism-core.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/date-range-picker.js'/>"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js" crossorigin="anonymous"></script>

<script>
	$(document).ready(function() {
		getHeaderData();
		setInterval(function() {
			reloadTimer();
		  }, 1000);
	})
	
	var startTimer = 60;
	var timer = 60;
	
	function reloadTimer() {
		
		if(timer == 0) {
			getData();
			
			timer = startTimer;
		}
		

		timer = timer -1;	    
	    document.getElementById('reloadTime').innerText = timer+"s";
		
	}
</script>

</body>
</html>