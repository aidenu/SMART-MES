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
<title><spring:message code="smart.status.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>
<style>
	
	#dataTable thead,
	#dataTable tfoot {
	  color: #0061f2;
	  text-align: center;
	}
	
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
				url : "${pageContext.request.contextPath}/smart/status/SmartModelStatusModelData.do",
				data : {"startDate":startDate, "endDate":endDate},
				type : "POST",
				datatype : "json",
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
							strHtml += "		<h4 class='small font-weight-bolder text-blue'>실행 : <br><br></h4>";
						} else if(value.CAD_STATUS == 'BEFORE_START'){
							strHtml += "		<div class='progress'><div class='progress-bar' role='progressbar' style='width: 0%;' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'></div></div>";
							strHtml += "		<h4 class='small font-weight-bolder text-blue'>실행 : <br><br></h4>";
						} else if(value.CAD_STATUS == 'ING') {
							strHtml += "		<div class='progress'><div class='progress-bar bg-green' role='progressbar' style='width: 50%;' aria-valuenow='50' aria-valuemin='0' aria-valuemax='100'></div></div>";
							strHtml += "		<h4 class='small font-weight-bolder text-blue'>실행 : <br>"+chknull(value.CAD_WORK_DATE)+"</h4>";
						} else if(value.CAD_STATUS == 'COMPLETE') {
							strHtml += "		<div class='progress'><div class='progress-bar bg-blue' role='progressbar' style='width: 100%;' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100'></div></div>";
							strHtml += "		<h4 class='small font-weight-bolder text-blue'>실행 : <br>"+chknull(value.CAD_WORK_DATE)+"</h4>";
						}
						if(value.CAD_STATUS == 'DELAY') {
							strHtml += "		<h4 class='small font-weight-bolder text-red blink'>";
							strHtml += "			계획 : <br>"+chknull(value.PLAN_CAD_DATE)+"";
							strHtml += "		</h4>";
						} else {
							strHtml += "		<h4 class='small'>";
							strHtml += "			계획 : <br>"+chknull(value.PLAN_CAD_DATE)+"";
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
							strHtml += "		<h4 class='small font-weight-bolder text-blue'>실행 : <br><br></h4>";
						} else if(value.ASSEMBLY_STATUS == 'BEFORE_START'){
							strHtml += "		<div class='progress'><div class='progress-bar' role='progressbar' style='width: 0%;' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100'></div></div>";
							strHtml += "		<h4 class='small font-weight-bolder text-blue'>실행 : <br><br></h4>";
						} else if(value.ASSEMBLY_STATUS == 'ING') {
							strHtml += "		<div class='progress'><div class='progress-bar bg-green' role='progressbar' style='width: 50%;' aria-valuenow='50' aria-valuemin='0' aria-valuemax='100'></div></div>";
							strHtml += "		<h4 class='small font-weight-bolder text-blue'>실행 : <br>"+chknull(value.ASSEMBLY_WORK_DATE)+"</h4>";
						} else if(value.ASSEMBLY_STATUS == 'COMPLETE') {
							strHtml += "		<div class='progress'><div class='progress-bar bg-blue' role='progressbar' style='width: 100%;' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100'></div></div>";
							strHtml += "		<h4 class='small font-weight-bolder text-blue'>실행 : <br>"+chknull(value.ASSEMBLY_WORK_DATE)+"</h4>";
						}
						
						if(value.ASSEMBLY_STATUS == 'DELAY') {
							strHtml += "		<h4 class='small font-weight-bolder text-red blink'>";
							strHtml += "			계획 : <br>"+chknull(value.PLAN_ASSEMBLY_DATE)+"";
							strHtml += "		</h4>";
						} else {
							strHtml += "		<h4 class='small'>";
							strHtml += "			계획 : <br>"+chknull(value.PLAN_ASSEMBLY_DATE)+"";
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
			
		});	//$("#btn_search").click
		
	});
	
	
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
				<header class="page-header page-header-dark bg-gradient-primary-to-secondary mb-4" id="headerTitle">
					<div class="container-fluid">
						<div class="page-header-content pt-4">
							<div class="row align-items-center justify-content-between">
								<div class="col-auto mt-4">
									<h1 class="page-header-title">
										<div class="page-header-icon"><i data-feather="database"></i></div>
										<span><spring:message code="smart.status.title" /></span>
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

<script>
	$(document).ready(function() {
		$("#btn_search").trigger("click");
	})
</script>

</body>
</html>