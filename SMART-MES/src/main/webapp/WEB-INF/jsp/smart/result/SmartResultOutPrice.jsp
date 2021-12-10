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
<title><spring:message code="smart.result.outprice.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>

<style type="text/css">


.modal-dialog {
	max-width: 600px !important;
}

</style>

<script>

	$(document).ready(function() {
		
		/**
			. 조회 버튼 클릭
			. parameter none
		*/
		$("#btn_search").click(function() {
			
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			var avgOutPrice = 0;
			var totalOutPrice= 0;
			var rowCnt = 0;
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/result/SmartResultOutPriceData.do",
				data : {"startDate":startDate, "endDate":endDate},
				type : "POST",
				datatype : "json",
				success : function(data) {
					$('#dataTable').dataTable().fnClearTable();
					$('#dataTable').dataTable().fnDestroy();
					
					var strHtml = "";
					
					$.each(data, function(index, value){
						
						let {
							MODEL_ID : modelid,
							MODEL_NO : modelno,
							PRODUCT_NO : productno,
							PRODUCT_NAME : productname,
							ORDER_DATE : orderdate,
							DUE_DATE : duedate,
							END_DATE : enddate,
							OUT_PRICE : outprice
							
						} = value;
						
						strHtml += "<tr>";
						strHtml += "	<td class='bg-blue text-white'>"+chkNull(modelno)+"</td>";
						strHtml += "	<td>"+chkNull(productno)+"</td>";
						strHtml += "	<td>"+chkNull(productname)+"</td>";
						strHtml += "	<td>"+chkNull(orderdate)+"</td>";
						strHtml += "	<td>"+chkNull(duedate)+"</td>";
						strHtml += "	<td>"+chkNull(enddate)+"</td>";
						strHtml += "	<td>"+outprice.toLocaleString()+"원</td>";
						strHtml += "	<td>";
						strHtml += "		<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+modelid+"_price'>";
						strHtml += "			<i data-feather='edit'></i>";
						strHtml += "		</div>";
						strHtml += "	</td>";
						strHtml += "</tr>";
						
						rowCnt++;
						totalOutPrice += Number(outprice);
						
					});	//$.each

					$("#data_table_tbody").append(strHtml);
					$('#dataTable').DataTable();	//jquery dataTable Plugin reload
					feather.replace();	//data-feather reload
					
					if(rowCnt > 0) {
						avgOutPrice =  totalOutPrice/rowCnt;
						
						$("#avgOutPrice").empty();
						$("#avgOutPrice").append("평균외주가공비 : " + avgOutPrice.toLocaleString() + "원");
						$("#totalOutPrice").empty();
						$("#totalOutPrice").append("외주가공비 총합 : " + totalOutPrice.toLocaleString() + "원");
					}
					
					
				}	//success
			});	//$.ajax
			
		});	//$("#btn_search").click
		

		$('#detailPriceLayer').on('shown.bs.modal', function () {
// 		   $('#detail_workprice').focus();
		});

		$('#detailPriceLayer').on('hide.bs.modal', function () {
// 			$("#detail_workprice").val("");
// 			$("#detail_outprice").val("");
// 			$("#detail_orderprice").val("");
		});
		
		
		$(document).on("click", "div[id$='_price']", function() {

			$('#detailPriceLayer').modal("show");
			var modelid = this.id.replace("_price", "");
			
			$.ajax({
				
				url: "${pageContext.request.contextPath}/smart/result/SmartResultOutPriceDetail.do",
				data: {"modelid":modelid},
				type: "POST",
				datatype: "json",
				success: function(data) {
					$('#detailTable').dataTable().fnClearTable();
					$('#detailTable').dataTable().fnDestroy();
					
					
					var strHtml = "";
					
					$.each(data, function(index, value) {
						
						let {
							WORK_USER_NM : work_user_nm,
							WORK_NAME : work_name,
							OUT_PRICE : out_price
						} = value;
						
						
						strHtml += "<tr>";
						strHtml += "	<td>"+chkNull(work_user_nm)+"</td>";
						strHtml += "	<td>"+chkNull(work_name)+"</td>";
						strHtml += "	<td>"+out_price.toLocaleString()+"원</td>";
						strHtml += "</tr>";
						
					});
					
					$("#detail_table_tbody").append(strHtml);
					$('#detailTable').DataTable();	//jquery dataTable Plugin reload
					feather.replace();	//data-feather reload
				}
			});
				
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
										<span><spring:message code="smart.result.outprice.title" /></span>
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
										<span id="avgOutPrice"></span>
										&nbsp;&nbsp;
										<span id="totalOutPrice"></span>
									</div>
								</div>
								<div class="card-body">
									<div class="datatable table-responsive">
										<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
											<colgroup>
												<col width="20%">
												<col width="20%">
												<col width="20%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
											</colgroup>
											<thead>
												<tr>
													<th scope="col"><spring:message code="smart.business.modelno" /></th>
													<th scope="col"><spring:message code="smart.business.productno" /></th>
													<th scope="col"><spring:message code="smart.business.productname" /></th>
													<th scope="col"><spring:message code="smart.business.orderdate" /></th>
													<th scope="col"><spring:message code="smart.business.duedate" /></th>
													<th scope="col"><spring:message code="smart.business.enddate" /></th>
													<th scope="col"><spring:message code="smart.result.outprice.title" /></th>
													<th scope="col">Detail</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th scope="col"><spring:message code="smart.business.modelno" /></th>
													<th scope="col"><spring:message code="smart.business.productno" /></th>
													<th scope="col"><spring:message code="smart.business.productname" /></th>
													<th scope="col"><spring:message code="smart.business.orderdate" /></th>
													<th scope="col"><spring:message code="smart.business.duedate" /></th>
													<th scope="col"><spring:message code="smart.business.enddate" /></th>
													<th scope="col"><spring:message code="smart.result.outprice.title" /></th>
													<th scope="col">Detail</th>
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
										                <h5 class="modal-title" id="detailPriceLayerTitle"><spring:message code="smart.result.outprice.detail.modal.layer" /></h5>
										                <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
										            </div>
										            <div class="modal-body">
										                <table class="table table-bordered table-hover" id="detailTable" width="100%" cellspacing="0">
															<colgroup>
																<col width="35%">
																<col width="35%">
																<col width="30%">
															</colgroup>
															<thead>
																<tr>
																	<th scope="col"><spring:message code="smart.result.outprice.worker" /></th>
																	<th scope="col"><spring:message code="smart.result.outprice.process" /></th>
																	<th scope="col"><spring:message code="smart.result.outprice.price" /></th>
																</tr>
															</thead>
															<tfoot>
																<tr>
																	<th scope="col"><spring:message code="smart.result.outprice.worker" /></th>
																	<th scope="col"><spring:message code="smart.result.outprice.process" /></th>
																	<th scope="col"><spring:message code="smart.result.outprice.price" /></th>
																</tr>
						                                    </tfoot>
						                                    <tbody id="detail_table_tbody">
					                                    		<tr>
																	<td></td>
																	<td></td>
																	<td></td>
																</tr>
						                                    </tbody>
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

<script>
	$(document).ready(function() {
		$("#btn_search").trigger("click");
	});
</script>

</body>
</html>