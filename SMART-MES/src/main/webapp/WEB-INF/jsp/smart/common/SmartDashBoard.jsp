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

	$(document).ready(function() {
		//MODEL STATUS
		getModelStatusData();
		
		//Summary Model Status
		getModelSummaryData();
		
		
	});
	
	
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
			async : false,
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
					} else if(value.SUMMARY_GUBUN == "WORK_ING") {
						$("#ingWorkCount").html(value.COUNT);
					} else if(value.SUMMARY_GUBUN == "WORK_READY") {
						$("#readyWorkCount").html(value.COUNT);
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
			async : false,
			success : function(data) {
				$('#dataTable').dataTable().fnClearTable();		//가공작업 상세 페이지 Span으로 인해 처리 안됨
				$('#dataTable').dataTable().fnDestroy();
				$("#dataTable").empty();
				
				var strHtml = "";
				strHtml += "<colgroup>";
				strHtml += "	<col width='15%'>";
				strHtml += "	<col width='15%'>";
				strHtml += "	<col width='16%'>";
				strHtml += "	<col width='9%'>";
				strHtml += "	<col width='9%'>";
				strHtml += "	<col width='10%'>";
				strHtml += "	<col width='16%'>";
				strHtml += "	<col width='10%'>";
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
				strHtml += "		<th scope='col'><spring:message code="smart.assembly" /></th>";
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
				strHtml += "		<th scope='col'><spring:message code="smart.assembly" /></th>";
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
					
					strHtml += "</tr>";
					$("#data_table_tbody").append(strHtml);
				});	//$.each
				
				$('#dataTable').DataTable();	//jquery dataTable Plugin reload
				feather.replace();	//data-feather reload
			}	//success
			
		});	//$.ajax
	}
	
	
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
                                <div class="page-header-subtitle">Example dashboard overview and content summary</div>
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid mt-n10">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">Area Chart Example</div>
                                    <div class="card-body">
                                        <div class="chart-area"><canvas id="myAreaChart" width="100%" height="30"></canvas></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">Bar Chart Example</div>
                                    <div class="card-body">
                                        <div class="chart-bar"><canvas id="myBarChart" width="100%" height="30"></canvas></div>
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
                                                <div class="small font-weight-bold text-primary mb-1"><spring:message code="smart.dashboard.model.ing.count" /></div>
                                                <div class="h5">
                                                	<span id="ingModelCount">5</span>
                                                </div>
                                            </div>
                                            <div class="ml-2"><i class="fas fa-dollar-sign fa-2x text-gray-200"></i></div>
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
                                                <div class="small font-weight-bold text-red mb-1"><spring:message code="smart.dashboard.model.delay.count" /></div>
                                                <div class="h5">
                                                	<span id="delayModelCount"></span>
                                                </div>
                                            </div>
                                            <div class="ml-2"><i class="fas fa-tag fa-2x text-gray-200"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <!-- Dashboard info widget 3 진행중인 가공 건수-->
                                <div class="card border-top-0 border-bottom-0 border-right-0 border-left-lg border-success h-100">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="small font-weight-bold text-success mb-1"><spring:message code="smart.dashboard.work.ing.count" /></div>
                                                <div class="h5">
                                                	<span id="ingWorkCount"></span>
                                                </div>
                                            </div>
                                            <div class="ml-2"><i class="fas fa-mouse-pointer fa-2x text-gray-200"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <!-- Dashboard info widget 4 대기중인 가공 건수-->
                                <div class="card border-top-0 border-bottom-0 border-right-0 border-left-lg border-info h-100">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="small font-weight-bold text-info mb-1"><spring:message code="smart.dashboard.work.ready.count" /></div>
                                                <div class="h5">
                                                	<span id="readyWorkCount"></span>
                                                </div>
                                            </div>
                                            <div class="ml-2"><i class="fas fa-percentage fa-2x text-gray-200"></i></div>
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
												<th><spring:message code="smart.assembly" /></th>
												<th>Detail</th>
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
												<th><spring:message code="smart.assembly" /></th>
												<th>Detail</th>
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
</body>
</html>