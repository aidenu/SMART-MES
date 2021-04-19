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
<title><spring:message code="smart.dashboard.title" /></title>
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
<style>
	.progress {
		cursor: pointer;
		margin-bottom: 0.5rem;
	}
	
	.blink {
		animation: blink 1s linear infinite;
	}
	
	@keyframes blink{
		0%{opacity: 0;}
		50%{opacity: .5;}
		100%{opacity: 1;}
	}
</style>
<script>
	
	function getData() {
		//MODEL STATUS
		getModelStatusData();
		
		//Summary Model Status
		getModelSummaryData();
		
		//Sodic Eqp Status
// 		getSodicStatusData();
		
		//Tiz(Px) Eqp Status
		getPxStatusData();
		
		//Tiz(Px) Eqp Stack
		getPxStackData();
	}
	
	/**
		.금형 진행 상태 Summary
		.진행중인 금형 건수, 지연되고 있는 금형 건수, 진행중인 가공 건수, 대기중인 가공 건
	*/
	function getModelSummaryData() {
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/common/SmartDashBoardModelSummary.do",
			type : "POST",
			data : "",
			datatype : "json",
			success : function(data) {
				$("#ingModelCount").empty();
				$("#delayModelCount").empty();
				$("#ingWorkCount").empty();
				$("#readyWorkCount").empty();
				
				$.each(data, function(index, value){
					
					if(value.SUMMARY_GUBUN == "MODEL_ING") {
						$("#ingModelCount").html(value.COUNT);
					} else if(value.SUMMARY_GUBUN == "MODEL_DELAY") {
						$("#delayModelCount").html(value.COUNT);
					} else if(value.SUMMARY_GUBUN == "WORK_SITE_ING") {
						$("#ingSiteWorkCount").html(value.COUNT);
					} else if(value.SUMMARY_GUBUN == "WORK_OUT_ING") {
						$("#ingOutWorkcount").html(value.COUNT);
					}
					
				});	//$.each(data)
				
			}	//success
			
		}); //$.ajax
	}
	
	
	/**
		.진행중인 금형 List 조회
		.현재 등록되어 진행중인 모든 금형 List
	*/
	function getModelStatusData() {
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/common/SmartDashBoardModelStatus.do",
			data : {"startDate":"", "endDate":"", "gubun":"DASHBOARD"},
			type : "POST",
			datatype: "json",
			success : function(data) {
				$('#dataTable').dataTable().fnClearTable();		//가공작업 상세 페이지 Span으로 인해 처리 안됨
				$('#dataTable').dataTable().fnDestroy();
				$("#dataTable").empty();
				
				var strHtml = "";
				strHtml += "<colgroup>";
				strHtml += "	<col width='16%'>";
				strHtml += "	<col width='16%'>";
				strHtml += "	<col width='17%'>";
				strHtml += "	<col width='10%'>";
				strHtml += "	<col width='10%'>";
				strHtml += "	<col width='11%'>";
				strHtml += "	<col width='20%'>";
// 				strHtml += "	<col width='10%'>";
				strHtml += "</colgroup>";
				
				strHtml += "<thead>";
				strHtml += "	<tr>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.modelno" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.productno" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.productname" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.orderdate" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.duedate" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work" /></th>";
// 				strHtml += "		<th scope='col'><spring:message code="smart.assembly" /></th>";
				strHtml += "	</tr>";
				strHtml += "</thead>";
				strHtml += "<tfoot>";
				strHtml += "	<tr>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.modelno" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.productno" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.productname" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.orderdate" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.business.duedate" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work" /></th>";
// 				strHtml += "		<th scope='col'><spring:message code="smart.assembly" /></th>";
				strHtml += "	</tr>";
				strHtml += "</tfoot>";
				strHtml += "<tbody id='data_table_tbody'>";
                strHtml += "</tbody>";
                $("#dataTable").append(strHtml);
                
				
				$.each(data, function(index, value){
					
					strHtml = "";
					
					strHtml += "	<tr>";
					if(value.CURRENT_STATUS == "DELAY") {
						strHtml += "	<td class='bg-orange text-white'>"+value.MODEL_NO+"</td>";
					} else if(value.CURRENT_STATUS == "COMPLETE") {
						strHtml += "	<td class='bg-blue text-white'>"+value.MODEL_NO+"</td>";
					} else {
						strHtml += "	<td>"+value.MODEL_NO+"</td>";
					}
					strHtml += "	<td>"+value.PRODUCT_NO+"</td>";
					strHtml += "	<td>"+value.PRODUCT_NAME+"</td>";
					strHtml += "	<td>"+value.ORDER_DATE+"</td>";
					strHtml += "	<td>"+value.DUE_DATE+"</td>";
					
					//설계 진행상태
					strHtml += "	<td>";
					
					if(value.CAD_STATUS == 'DELAY') {
						strHtml += "		<div class='progress'><div class='progress-bar bg-red' role='progressbar' style='width: 0%;' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'></div></div>";
						strHtml += "		<h4 class='small font-weight-bolder text-blue'><spring:message code="smart.status.work.action" /> : <br><br></h4>";
					} else if(value.CAD_STATUS == 'BEFORE_START'){
						strHtml += "		<div class='progress'><div class='progress-bar' role='progressbar' style='width: 0%;' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'></div></div>";
						strHtml += "		<h4 class='small font-weight-bolder text-blue'><spring:message code="smart.status.work.action" /> : <br><br></h4>";
					} else if(value.CAD_STATUS == 'ING') {
						strHtml += "		<div class='progress'><div class='progress-bar bg-green' role='progressbar' style='width: 50%;' aria-valuenow='50' aria-valuemin='0' aria-valuemax='100'></div></div>";
						strHtml += "		<h4 class='small font-weight-bolder text-blue'><spring:message code="smart.status.work.action" /> : <br>"+chknull(value.CAD_WORK_DATE)+"</h4>";
					} else if(value.CAD_STATUS == 'COMPLETE') {
						strHtml += "		<div class='progress'><div class='progress-bar bg-blue' role='progressbar' style='width: 100%;' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100'></div></div>";
						strHtml += "		<h4 class='small font-weight-bolder text-blue'><spring:message code="smart.status.work.action" /> : <br>"+chknull(value.CAD_WORK_DATE)+"</h4>";
					}
					if(value.CAD_STATUS == 'DELAY') {
						strHtml += "		<h4 class='small font-weight-bolder text-red blink'>";
						strHtml += "			<spring:message code="smart.status.work.plan" /> : <br>"+chknull(value.PLAN_CAD_DATE)+"";
						strHtml += "		</h4>";
					} else {
						strHtml += "		<h4 class='small'>";
						strHtml += "			<spring:message code="smart.status.work.plan" /> : <br>"+chknull(value.PLAN_CAD_DATE)+"";
						strHtml += "		</h4>";
					}
					strHtml += "	</td>";
					
					//가공 진행상태
					strHtml += "	<td>";
					strHtml += "		<div class='progress' id='"+value.MODEL_ID+"_progress'>";
					strHtml += "       		<div class='progress-bar bg-green' role='progressbar' style='width: "+value.PROGRESS_RATE+"%' aria-valuenow='"+value.PROGRESS_RATE+"' aria-valuemin='0' aria-valuemax='100'>"+value.PROGRESS_RATE+"%</div>";
					strHtml += "		</div>";
					strHtml += "		<br><br><br>";
					strHtml += "	</td>";
					
					//조립 진행상태
					/*
					//조립 상태 비활성
					strHtml += "	<td>";
					if(value.ASSEMBLY_STATUS == 'DELAY') {
						strHtml += "		<div class='progress'><div class='progress-bar bg-red' role='progressbar' style='width: 0%;' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'></div></div>";
						strHtml += "		<h4 class='small font-weight-bolder text-blue'><spring:message code="smart.status.work.action" /> : <br><br></h4>";
					} else if(value.ASSEMBLY_STATUS == 'BEFORE_START'){
						strHtml += "		<div class='progress'><div class='progress-bar' role='progressbar' style='width: 0%;' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'></div></div>";
						strHtml += "		<h4 class='small font-weight-bolder text-blue'><spring:message code="smart.status.work.action" /> : <br><br></h4>";
					} else if(value.ASSEMBLY_STATUS == 'ING') {
						strHtml += "		<div class='progress'><div class='progress-bar bg-green' role='progressbar' style='width: 50%;' aria-valuenow='50' aria-valuemin='0' aria-valuemax='100'></div></div>";
						strHtml += "		<h4 class='small font-weight-bolder text-blue'><spring:message code="smart.status.work.action" /> : <br>"+chknull(value.ASSEMBLY_WORK_DATE)+"</h4>";
					} else if(value.ASSEMBLY_STATUS == 'COMPLETE') {
						strHtml += "		<div class='progress'><div class='progress-bar bg-blue' role='progressbar' style='width: 100%;' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100'></div></div>";
						strHtml += "		<h4 class='small font-weight-bolder text-blue'><spring:message code="smart.status.work.action" /> : <br>"+chknull(value.ASSEMBLY_WORK_DATE)+"</h4>";
					}
					
					if(value.ASSEMBLY_STATUS == 'DELAY') {
						strHtml += "		<h4 class='small font-weight-bolder text-red blink'>";
						strHtml += "			<spring:message code="smart.status.work.plan" /> : <br>"+chknull(value.PLAN_ASSEMBLY_DATE)+"";
						strHtml += "		</h4>";
					} else {
						strHtml += "		<h4 class='small'>";
						strHtml += "			<spring:message code="smart.status.work.plan" /> : <br>"+chknull(value.PLAN_ASSEMBLY_DATE)+"";
						strHtml += "		</h4>";
					}
					strHtml += "	</td>";
					*/
					
					strHtml += "</tr>";
					$("#data_table_tbody").append(strHtml);
				});	//$.each
				
				$('#dataTable').DataTable();	//jquery dataTable Plugin reload
				feather.replace();	//data-feather reload
			}	//success
			
		});	//$.ajax
	}
	
	
	function getSodicStatusData() {
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/common/SmartDashBoardSodicStatus.do",
			type : "POST",
			data : "",
			datatype : "json",
			success : function(data) {
				$("#eqpStatus").empty();
				console.log("STEP1 :: " + data);
				var strHtml = "";
				
				strHtml += "<div class='nav nav-pills nav-justified flex-column flex-xl-row nav-wizard' id='cardTab' role='tablist'>";
				$.each(data, function(index, value){
					
					if(index == 0) {
						strHtml += "		<a class='nav-item nav-link active' id='"+value.EQP_NAME+"-tab' href='#"+value.EQP_NAME+"' data-toggle='tab' role='tab' aria-controls='wizard1' aria-selected='true'>";
					} else {
						strHtml += "		<a class='nav-item nav-link' id='"+value.EQP_NAME+"-tab' href='#"+value.EQP_NAME+"' data-toggle='tab' role='tab' aria-controls='wizard1' aria-selected='true'>";
					}
					
					if(value.EQP_STATUS == "ACTIVE") {
						strHtml += "			<i class='fas fa-circle fa-2x mr-1 text-green'></i>";
					} else if(value.EQP_STATUS == "READY") {
						strHtml += "			<i class='fas fa-circle fa-2x mr-1 text-yellow'></i>";
					} else if(value.EQP_STATUS == "ERROR") {
						strHtml += "			<i class='fas fa-circle fa-2x mr-1 text-red'></i>";
					} else {
						strHtml += "			<i class='fas fa-circle fa-2x mr-1 text-gray'></i>";
					}
					
					strHtml += "			<div class='wizard-step-text'>";
					strHtml += "				<div class='wizard-step-text-name'>"+value.EQP_NAME+"</div>";
					strHtml += "				<div class='wizard-step-text-details'>"+value.EQP_PROGRAM+"</div>";
					strHtml += "			</div>";
					strHtml += "		</a>";
					
				});	//$.each(data)
				strHtml += "</div>";
				$("#eqpStatus").append(strHtml);
			}	//success
			
		});	//$.ajax
		
		
	}
	
	var stopFlag = ["0"];
	var activeFlag = ["3"];
	//var readyFlag = ["1", "4", "5", "6", "7", "20", "21", "30", "90"];		//active, error 상태 외에는 전부 ready
	var errorFlag = ["2"];
	function getPxStatusData() {
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/common/SmartDashBoardPxStatus.do",
			type : "POST",
			data : "",
			datatype : "json",
			success : function(data) {
				$("#eqpStatus").empty();

				var strHtml = "";
				
				strHtml += "<div class='nav nav-pills nav-justified flex-column flex-xl-row nav-wizard' id='cardTab' role='tablist'>";
				$.each(data, function(index, value){
					
					strHtml += "		<a class='nav-item nav-link' id='"+value.EQP_NAME+"-tab'>";
					
					if(activeFlag.indexOf(value.EQP_FLAG) > -1) {
						strHtml += "			<i class='fas fa-circle fa-2x mr-1 text-green'></i>";
					} else if(errorFlag.indexOf(value.EQP_FLAG) > -1) {
						strHtml += "			<i class='fas fa-circle fa-2x mr-1 text-red'></i>";
					} else if(stopFlag.indexOf(value.EQP_FLAG) > -1) {
						strHtml += "			<i class='fas fa-circle fa-2x mr-1 text-gray'></i>";
					} else{
						strHtml += "			<i class='fas fa-circle fa-2x mr-1 text-yellow'></i>";
					}
					
					strHtml += "			<div class='wizard-step-text'>";
					strHtml += "				<div class='wizard-step-text-name'>"+value.EQP_NAME+"</div>";
					strHtml += "			</div>";
					strHtml += "		</a>";
					
				});	//$.each(data)
				strHtml += "</div>";
				$("#eqpStatus").append(strHtml);
			}	//success
			
		});	//$.ajax
		
	}
	
	
	function getPxStackData() {
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/common/SmartDashBoardPxTimeline.do",
			type : "POST",
			data : "",
			datatype : "json",
			success : function(data) {
				var today = new Date();
				var year = today.getFullYear();
				var month = today.getMonth();
				var day = today.getDate();
				var chartData = [];
				
				$.each(data, function(index, value) {
					
					if(value.EQP_STATUS == "ACTIVE") {
						chartData.push({
							"name": value.EQP_NAME,
							  "fromDate": value.BEFORE_EVENT_TIME,
							  "toDate": value.EVENT_TIME,
							  "color": "#00AC69",
							  "task": "ACTIVE"
						});
					} else if(value.EQP_STATUS == "READY") {
						chartData.push({
							"name": value.EQP_NAME,
							  "fromDate": value.BEFORE_EVENT_TIME,
							  "toDate": value.EVENT_TIME,
							  "color": "#F4A100",
							  "task": "READY"
						});
					} else if(value.EQP_STATUS == "ERROR") {
						chartData.push({
							"name": value.EQP_NAME,
							  "fromDate": value.BEFORE_EVENT_TIME,
							  "toDate": value.EVENT_TIME,
							  "color": "#E81500",
							  "task": "ERROR"
						});
					} else if(value.EQP_STATUS == "STOPPED") {
						chartData.push({
							"name": value.EQP_NAME,
							  "fromDate": value.BEFORE_EVENT_TIME,
							  "toDate": value.EVENT_TIME,
							  "color": "#687281",
							  "task": "STOPPED"
						});
					} else {
						chartData.push({
							"name": value.EQP_NAME,
							  "fromDate": value.BEFORE_EVENT_TIME,
							  "toDate": value.EVENT_TIME,
							  "color": "#FFFFFF",
							  "task": ""
						});
					}
					
				});
				
				// Themes begin
				am4core.useTheme(am4themes_animated);
				// Themes end
				
				var chart = am4core.create("eqpStack", am4charts.XYChart);
				chart.hiddenState.properties.opacity = 0; // this creates initial fade-in

				chart.paddingRight = 30;
				chart.dateFormatter.inputDateFormat = "yyyy-MM-dd HH:mm";

				chart.data = chartData;

				var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
				categoryAxis.dataFields.category = "name";
				categoryAxis.renderer.grid.template.location = 0;
				categoryAxis.renderer.inversed = true;

				var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
				dateAxis.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm";
				dateAxis.renderer.minGridDistance = 80;
				dateAxis.baseInterval = { count: 30, timeUnit: "minute" };
				dateAxis.max = new Date(year, month, day, 24, 0, 0, 0).getTime();
				dateAxis.strictMinMax = true;
				dateAxis.renderer.tooltipLocation = 0;

				var series1 = chart.series.push(new am4charts.ColumnSeries());
				series1.columns.template.height = am4core.percent(80);
				series1.columns.template.tooltipText = "{task}: [bold]{openDateX}[/] - [bold]{dateX}[/]";

				series1.dataFields.openDateX = "fromDate";
				series1.dataFields.dateX = "toDate";
				series1.dataFields.categoryY = "name";
				series1.columns.template.propertyFields.fill = "color"; // get color from data
				series1.columns.template.propertyFields.stroke = "color";
				series1.columns.template.strokeOpacity = 1;
			}	//success
			
		});	//$.ajax
		
	}
	
	
	/**
		.Work Progress Bar Click
		.parameter
		 - modelid
	*/
	$(document).on("click", "div[id$='_progress']", function() {
		
		var modelid = this.id.replace("_progress", "");
		window.open("<c:url value='/smart/status/SmartModelStatusDetail.do?modelid="+modelid+"'/>", "statusPop", "scrollbars=yes,toolbar=no,resizable=yes,left=200,top=200,width=1400,height=850");
		
	});		//$(documewnt).on("click", "div[id$='_progress']", function() {}
	
	
	function chknull(val) {
		var returnVal = "";
		
		if(val == null) {
			return returnVal;
		} else {
			return val;
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
                    <div class="page-header pb-10 page-header-dark bg-gradient-primary-to-secondary">
                        <div class="container-fluid">
                            <div class="page-header-content">
                                <h1 class="page-header-title">
                                    <div class="page-header-icon"><i data-feather="activity"></i></div>
                                    <span><spring:message code="smart.dashboard.title" /></span>
                                </h1>
                                &nbsp; &nbsp; &nbsp;<img src="<c:url value='/'/>images/smart/progressdisc.gif" width="15" height="15" border="0">
								<span id="reloadTime"></span>
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid mt-n10">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header"><spring:message code="smart.dashboard.eqp.status" /></div>
                                    <div class="card-body">
                                        <div class="eqpStatus" id="eqpStatus"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header"><spring:message code="smart.dashboard.eqp.stack" /></div>
                                    <div class="card-body">
                                        <div class="chart-bar" id="eqpStack"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                        	<div class="col-xl-3 col-md-6 mb-4">
                                <!-- Dashboard info widget 1 진행중인 금형 건수-->
                                <div class="card border-top-0 border-bottom-0 border-right-0 border-left-lg border-primary h-100">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="small font-weight-bold text-primary mb-1 text-lg font-weight-800"><spring:message code="smart.dashboard.model.ing.count" /></div>
                                                <div class="h5">
                                                	<span class="text-xl" id="ingModelCount">5</span>
                                                </div>
                                            </div>
                                            <div class="ml-2"><i class="fas fa-clipboard-list fa-2x text-gray-200"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <!-- Dashboard info widget 2 지연되고 있는 금형 건-->
                                <div class="card border-top-0 border-bottom-0 border-right-0 border-left-lg border-red h-100">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="small font-weight-bold text-red mb-1 text-lg font-weight-800"><spring:message code="smart.dashboard.model.delay.count" /></div>
                                                <div class="h5">
                                                	<span class="text-xl" id="delayModelCount"></span>
                                                </div>
                                            </div>
                                            <div class="ml-2"><i class="fas fa-bomb fa-2x text-gray-200"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <!-- Dashboard info widget 3 진행중인 사내가공 건수-->
                                <div class="card border-top-0 border-bottom-0 border-right-0 border-left-lg border-success h-100">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="small font-weight-bold text-success mb-1 text-lg font-weight-800"><spring:message code="smart.dashboard.work.site.ing.count" /></div>
                                                <div class="h5">
                                                	<span class="text-xl" id="ingSiteWorkCount"></span>
                                                </div>
                                            </div>
                                            <div class="ml-2"><i class="far fa-calendar-alt fa-2x text-gray-200"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <!-- Dashboard info widget 4 진행중인 외주가공 건수-->
                                <div class="card border-top-0 border-bottom-0 border-right-0 border-left-lg border-info h-100">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="small font-weight-bold text-info mb-1 text-lg font-weight-800"><spring:message code="smart.dashboard.work.out.ing.count" /></div>
                                                <div class="h5">
                                                	<span class="text-xl" id="ingOutWorkcount"></span>
                                                </div>
                                            </div>
                                            <div class="ml-2"><i class="fas fa-calendar-alt fa-2x text-gray-200"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-4">
                            <div class="card-header"><spring:message code="smart.dashboard.model.status.title" /></div>
                            <div class="card-body">
                                <div class="datatable table-responsive">
                                    <table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
                                        <thead>
											<tr>
												<th><spring:message code="smart.business.modelno" /></th>
												<th><spring:message code="smart.business.productno" /></th>
												<th><spring:message code="smart.business.productname" /></th>
												<th><spring:message code="smart.business.orderdate" /></th>
												<th><spring:message code="smart.business.duedate" /></th>
												<th><spring:message code="smart.cad" /></th>
												<th><spring:message code="smart.work" /></th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th><spring:message code="smart.business.modelno" /></th>
												<th><spring:message code="smart.business.productno" /></th>
												<th><spring:message code="smart.business.productname" /></th>
												<th><spring:message code="smart.business.orderdate" /></th>
												<th><spring:message code="smart.business.duedate" /></th>
												<th><spring:message code="smart.cad" /></th>
												<th><spring:message code="smart.work" /></th>
											</tr>
	                                    </tfoot>
	                                    <tbody id="data_table_tbody">
	                                    	<tr>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
	                                    </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <footer class="footer mt-auto footer-light">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-6 small">Copyright &copy; <spring:message code="smart.header.title" /></div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js" crossorigin="anonymous"></script>

<script>
	
$(document).ready(function() {
	getData();
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