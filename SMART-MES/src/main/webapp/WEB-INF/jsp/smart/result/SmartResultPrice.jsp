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
<title><spring:message code="smart.result.price.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>

<style>
	.detailTable {
		border-spacing: 10px;
		border-collapse: separate;
	}
	
	.modal-dialog {
		max-width: 400px !important;
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
				url : "${pageContext.request.contextPath}/smart/result/SmartResultPriceModelData.do",
				data : {"startDate":startDate, "endDate":endDate},
				type : "POST",
				datatype : "json",
				success : function(data) {
					
					var totalPrice = 0;
					var avgPrice = 0;
					var dataCnt = 0;
					
					$('#dataTable').dataTable().fnClearTable();
					$('#dataTable').dataTable().fnDestroy();
					$("#dataTable").empty();
					
					var strHtml = "";
					
					strHtml += "<thead>";
					strHtml += "	<tr>";
					strHtml += "		<th><spring:message code="smart.business.modelno" /></th>";
					strHtml += "		<th><spring:message code="smart.business.productno" /></th>";
					strHtml += "		<th><spring:message code="smart.business.productname" /></th>";
					strHtml += "		<th><spring:message code="smart.business.orderdate" /></th>";
					strHtml += "		<th><spring:message code="smart.business.duedate" /></th>";
					strHtml += "		<th><spring:message code="smart.business.enddate" /></th>";
					strHtml += "		<th><spring:message code="smart.result.price.title" /></th>";
					strHtml += "		<th>Detail</th>";
					strHtml += "	</tr>";
					strHtml += "</thead>";
					strHtml += "<tfoot>";
					strHtml += "	<tr>";
					strHtml += "		<th><spring:message code="smart.business.modelno" /></th>";
					strHtml += "		<th><spring:message code="smart.business.productno" /></th>";
					strHtml += "		<th><spring:message code="smart.business.productname" /></th>";
					strHtml += "		<th><spring:message code="smart.business.orderdate" /></th>";
					strHtml += "		<th><spring:message code="smart.business.duedate" /></th>";
					strHtml += "		<th><spring:message code="smart.business.enddate" /></th>";
					strHtml += "		<th><spring:message code="smart.result.price.title" /></th>";
					strHtml += "		<th>Detail</th>";
					strHtml += "	</tr>";
					strHtml += "</tfoot>";
					strHtml += "<tbody id='data_table_tbody'>";
	                strHtml += "</tbody>";
	                $("#dataTable").append(strHtml);
	                
					
					$.each(data, function(index, value){
						
						strHtml = "";
						
						strHtml += "<tr>";
						strHtml += "	<td class='bg-blue text-white'>"+value.MODEL_NO+"</td>";
						strHtml += "	<td>"+chkNull(value.PRODUCT_NO)+"</td>";
						strHtml += "	<td>"+chkNull(value.PRODUCT_NAME)+"</td>";
						strHtml += "	<td>"+chkNull(value.ORDER_DATE)+"</td>";
						strHtml += "	<td>"+chkNull(value.DUE_DATE)+"</td>";
						strHtml += "	<td>"+chkNull(value.END_DATE)+"</td>";
						strHtml += "	<td>"+chkNull(value.TOTAL_PRICE)+"</td>";
						strHtml += "	<td>";
						strHtml += "		<input type='hidden' id='"+value.MODEL_ID+"_detailworkingprice' value='"+value.TOTAL_WORKING_PRICE+"'>";
						strHtml += "		<input type='hidden' id='"+value.MODEL_ID+"_detailoutprice' value='"+value.TOTAL_OUT_PRICE+"'>";
						strHtml += "		<input type='hidden' id='"+value.MODEL_ID+"_detailorderprice' value='"+value.TOTAL_ORDER_PRICE+"'>";
						strHtml += "		<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+value.MODEL_ID+"_price'>";
						strHtml += "			<i data-feather='edit'></i>";
						strHtml += "		</div>";
						strHtml += "	</td>";
						strHtml += "</tr>";
						$("#data_table_tbody").append(strHtml);
						
						totalPrice += Number(value.TOTAL_PRICE_NUM);
						dataCnt++;
						
					});	//$.each
					
					if(dataCnt == 0) {
						avgPrice = 0;
					} else {
						avgPrice = Math.round(totalPrice / dataCnt);
					}
					
					$('#dataTable').DataTable();	//jquery dataTable Plugin reload
					feather.replace();	//data-feather reload

					$("#totalPrice").empty();
					$("#totalPrice").append(totalPrice.toLocaleString()+"원");
					$("#avgPrice").empty();
					$("#avgPrice").append(avgPrice.toLocaleString()+"원");
					
				}	//success
			});	//$.ajax
			
		});	//$("#btn_search").click
		
		
		$('#detailPriceLayer').on('shown.bs.modal', function () {
		   $('#detail_workprice').focus();
		});

		$('#detailPriceLayer').on('hide.bs.modal', function () {
			$("#detail_workprice").val("");
			$("#detail_outprice").val("");
			$("#detail_orderprice").val("");
		});
		
		
		$(document).on("click", "div[id$='_price']", function() {

			$('#detailPriceLayer').modal("show");
			var modelid = this.id.replace("_price", "");
			var workingprice = $("#"+modelid+"_detailworkingprice").val();
			var outprice = $("#"+modelid+"_detailoutprice").val();
			var orderprice = $("#"+modelid+"_detailorderprice").val();
			
			$("#detail_workprice").val(chkNull(workingprice));
			$("#detail_outprice").val(chkNull(outprice));
			$("#detail_orderprice").val(chkNull(orderprice));
				
		});	//_price click
		
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
			<main>
				<header class="page-header page-header-dark bg-gradient-primary-to-secondary mb-4" id="headerTitle">
					<div class="container-fluid">
						<div class="page-header-content pt-4">
							<div class="row align-items-center justify-content-between">
								<div class="col-auto mt-4">
									<h1 class="page-header-title">
										<div class="page-header-icon"><i data-feather="database"></i></div>
										<span><spring:message code="smart.result.price.title" /></span>
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
										<spring:message code="smart.result.price.total" /> : 
										<span id="totalPrice"></span>,
										<spring:message code="smart.result.price.average" /> : 
										<span id="avgPrice"></span>
									</div>
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
													<th><spring:message code="smart.business.enddate" /></th>
													<th><spring:message code="smart.result.price.title" /></th>
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
													<th><spring:message code="smart.business.enddate" /></th>
													<th><spring:message code="smart.result.price.title" /></th>
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
												</tr>
		                                    </tbody>
										</table>
										
										<!-- Modal -->
										<div class="modal fade" id="detailPriceLayer" tabindex="-1" role="dialog" aria-labelledby="detailPriceLayerTitle" aria-hidden="true">
										    <div class="modal-dialog modal-dialog-centered" role="document">
										        <div class="modal-content">
										            <div class="modal-header">
										                <h5 class="modal-title" id="detailPriceLayerTitle"><spring:message code="smart.result.price.detail.modal.layer" /></h5>
										                <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
										            </div>
										            <div class="modal-body">
										                <table class="detailTable">
										                	<tr>
										                		<td><spring:message code="smart.result.price.work.price" /></td>
										                		<td><input class="form-control" id="detail_workprice" name="detail_workprice" readonly></td>
										                	</tr>
										                	<tr>
										                		<td><spring:message code="smart.result.price.outwork.price" /></td>
										                		<td><input class="form-control" id="detail_outprice" name="detail_outprice" readonly></td>
										                	</tr>
										                	<tr>
										                		<td><spring:message code="smart.result.price.purchase.price" /></td>
										                		<td><input class="form-control" id="detail_orderprice" name="detail_orderprice" readonly></td>
										                	</tr>
										                </table>
										            </div>
										            <div class="modal-footer">
										            	<div class="btn btn-secondary" data-dismiss="modal">닫기</div>
										            </div>
										        </div>
										    </div>
										</div>
										<!-- Modal -->
										
									</div>
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