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
<title><spring:message code="smart.stock.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<style>
	.addTable {
		width: 100%;
	}
</style>
<script>

	$(document).ready(function() {
		
		/**
			. 조회 버튼 클릭
			. parameter none
		*/
		$("#btn_search").click(function() {
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/stock/SmartStockData.do",
				data : "",
				type : "POST",
				datatype : "json",
				success : function(data) {
					$('#dataTable').dataTable().fnClearTable();
					$('#dataTable').dataTable().fnDestroy();
					
					var strHtml = "";
					
					$.each(data, function(index, value){
						
						strHtml += "<tr>";
						strHtml += "		<td>"+value.STOCK_NAME+"</td>";
						strHtml += "		<td>"+value.STOCK_SIZE+"</td>";
						strHtml += "		<td>"+value.STOCK_COUNT+"</td>";
						strHtml += "		<td>"+value.STOCK_SAFE_COUNT+"</td>";
						strHtml += "		<td>"+value.STOCK_PRICE+"</td>";
						strHtml += "		<td>";
						strHtml += "			<input class='form-control' id='"+value.STOCK_ID+"_ordercount' name='"+value.STOCK_ID+"_ordercount' onkeyup='onlyNum(this);' style='width: 40%;float: left;' placeholder='수량 입력'>";
						strHtml += "			&nbsp;";
						strHtml += "			<div class='btn btn-green btn-sm' id='"+value.STOCK_ID+"_instock'>입고</div>";
						strHtml += "			<div class='btn btn-yellow btn-sm' id='"+value.STOCK_ID+"_outstock'>출고</div>";
						strHtml += "		</td>";
						strHtml += "		<td>";
						strHtml += "			<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+value.STOCK_ID+"_detail'>";
						strHtml += "				<i data-feather='edit'></i>";
						strHtml += "			</div>";
						strHtml += "			<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+value.STOCK_ID+"_delete'>";
						strHtml += "				<i data-feather='trash-2'></i>";
						strHtml += "			</div>";
						strHtml += "		</td>";
						strHtml += "</tr>";
						
					});	//$.each

					$("#data_table_tbody").append(strHtml);
					$('#dataTable').DataTable();	//jquery dataTable Plugin reload
					feather.replace();	//data-feather reload
				}	//success
			});	//$.ajax
			
		});	//$("#btn_search").click
		
		
		/**
			. 신규 데이터 등록 버튼 클릭
			. parameter
			  - stockname
			  - stocksize
			  - stockcount
			  - stockprice
			  - safecount
		*/
		$("#btn_save").click(function() {
			
			var stockname = $("#add_stockname").val();
			var stocksize = $("#add_stocksize").val();
			var stockcount = $("#add_stockcount").val();
			var stockprice = $("#add_stockprice").val();
			var safecount = $("#add_safecount").val();
			var gubun = "ADD";
			
			if(stockname == "") {
				alert("부품명을 입력하세요");
				return;
			}
			if(stocksize == "") {
				alert("부품 사이즈를 입력하세요");
				return;
			}
			if(stockcount == "") {
				alert("수량을 입력하세요");
				return;
			}
			if(stockprice == "") {
				stockprice = 0;
			}
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/stock/SmartStockDataSave.do",
				type : "POST",
				data : {"stockname":stockname, "stocksize":stocksize, "stockcount":stockcount, "stockprice":stockprice, "safecount":safecount, "gubun":gubun},
				datatype : "text",
				success : function(data) {

					if("EXIST" == data) {
						alert("이미 존재하는 부품입니다.");
					} else if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="smart.common.save.error" /> :: " + data);
					} else {
						$("#add_stockname").val("");
						$("#add_stocksize").val("");
						$("#add_stockcount").val("");
						$("#add_stockprice").val("");
						$("#add_safecount").val("");
						
						$('#addModalLayer').modal("hide");
						$("#btn_search").trigger("click");
					}
				}	//success
				
			});	//$.ajax
			
		});	//btn_save click
		
		
		
		/**
			. 삭제 버튼 클릭
			. parameter
			  - stockid
		*/
		$(document).on("click", "div[id$='_delete']", function() {
			
			var stockid = this.id.replace("_delete", "");
			var msg = "<spring:message code="smart.common.delete.is" />";
			
			if(confirm(msg)) {
				$.ajax({
					
					url : "${pageContext.request.contextPath}/smart/stock/SmartStockDataDelete.do",
					data : {"stockid":stockid},
					type : "POST",
					datatype : "text",
					success : function(data) {
						
						if(data == "OK") {
							$("#btn_search").trigger("click");
						} else if(data.indexOf("ERROR")) {
							alert("<spring:message code="smart.common.save.error" /> \n ["+data+"]");
						}
						
					}	//success
					
				});	//$.ajax
			}
			
		});	//click _delete
		
		
		/**
			. 입/출고 버튼 클릭
			. parameter
			  - stockid
			  - ordercount
		*/
		$(document).on("click", "div[id$='_instock']", function() {
			var stockid = this.id.replace("_instock", "");
			var ordercount = $("#"+stockid+"_ordercount").val();
			var gubun = "IN";
			inoutStock(stockid, ordercount, gubun);
		});	//click 입고
		$(document).on("click", "div[id$='_outstock']", function() {
			var stockid = this.id.replace("_outstock", "");
			var ordercount = $("#"+stockid+"_ordercount").val();
			var gubun = "OUT";
			inoutStock(stockid, ordercount, gubun);
		});	//click 출고
		
		
		/**
			. 입/출고 버튼 클릭 function
			. parameter
			  - stockid
			  - ordercount
			  - gubun
		*/
		function inoutStock(stockid, ordercount, gubun) {
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/stock/SmartStockDataOrder.do",
				data : {"stockid":stockid, "ordercount":ordercount, "gubun":gubun},
				type : "POST",
				datatype : "text",
				success : function(data) {
					
					if(data == "OK") {
						alert("<spring:message code="smart.common.save.ok" />");
						$("#btn_search").trigger("click");
					} else if(data.indexOf("ERROR")) {
						alert("<spring:message code="smart.common.save.error" /> \n ["+data+"]");
					}
					
				}	//success
				
			});	//$.ajax
			
		}	//inoutStock
		
		
		
		/**
			. 상세보기 버튼 클릭
			. parameter
			  - stockid 
		*/
		$(document).on("click", "div[id$='_detail']", function() {
			
			var stockid = this.id.replace("_detail", "");
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/stock/SmartStockDataDetail.do",
				data : {"stockid":stockid},
				type : "POST",
				datatype : "json",
				success : function(data) {
					
					$.each(data, function(index, value){
						
						$('#modifyModalLayer').modal("show");
						$("#modify_stockid").val(stockid);
						
						$("#modify_stockname").val(value.STOCK_NAME);
						$("#modify_stocksize").val(value.STOCK_SIZE);
						$("#modify_stockcount").val(value.STOCK_COUNT);
						$("#modify_stockprice").val(value.STOCK_PRICE);
						$("#modify_safecount").val(value.STOCK_SAFE_COUNT);
						
					});	//$.each
					
				}	//success
				
			});	//$.ajax
			
			
		});	//_detail click
		
		
		/**
			. 상세보기 수정 버튼 클릭
			. parameter
			  - stockid
			  - stockname
			  - stocksize
			  - stockcount
			  - stockprice
			  - safecount
		*/
		$("#btn_modify").click(function() {
			
			var stockid =  $("#modify_stockid").val();
			var stockname =  $("#modify_stockname").val();
			var stocksize =  $("#modify_stocksize").val();
			var stockcount =  $("#modify_stockcount").val();
			var stockprice =  $("#modify_stockprice").val();
			var safecount =  $("#modify_safecount").val();
			
			if(stocksize == "") {
				alert("부품 사이즈를 입력하세요");
				return;
			}
			
			if(stockprice == "") {
				stockprice = 0;
			}
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/stock/SmartStockDataModify.do",
				type : "POST",
				data : {"stockname":stockname, "stocksize":stocksize, "stockcount":stockcount, "stockprice":stockprice, "safecount":safecount, "stockid":stockid},
				datatype : "text",
				success : function(data) {

					 if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="smart.common.save.error" /> :: " + data);
					} else {
						$('#modifyModalLayer').modal("hide");
						$("#btn_search").trigger("click");
					}
				}	//success
				
			});	//$.ajax
			
		});	//btn_modify click
		
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
										<span><spring:message code="smart.stock.title" /></span>
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
							<div class="card-header">
								<div class="btn btn-outline-primary" id="btn_search"><spring:message code="smart.common.button.search" /></div>
								&nbsp;
								<div class="btn btn-outline-primary" id="btn_add" data-toggle="modal" data-target="#addModalLayer"><spring:message code="smart.common.button.add" /></div>
								
								<!-- Modal -->
								<div class="modal fade" id="addModalLayer" tabindex="-1" role="dialog" aria-labelledby="addModalLayerTitle" aria-hidden="true">
								    <div class="modal-dialog modal-dialog-centered" role="document">
								        <div class="modal-content">
								            <div class="modal-header">
								                <h5 class="modal-title" id="addModalLayerTitle"><spring:message code="smart.stock.part.add" /></h5>
								                <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
								            </div>
								            <div class="modal-body">
								                <table class="addTable">
								                	<tr>
								                		<td><spring:message code="smart.stock.part.name" /></td>
								                		<td><input class="form-control" id="add_stockname" name="add_stockname"></td>
								                	</tr>
								                	<tr>
								                		<td><spring:message code="smart.stock.part.size" /></td>
								                		<td><input class="form-control" id="add_stocksize" name="add_stocksize"></td>
								                	</tr>
								                	<tr>
								                		<td><spring:message code="smart.stock.part.count" /></td>
								                		<td><input class="form-control" id="add_stockcount" name="add_stockcount" onkeyup="onlyNum(this);"></td>
								                	</tr>
								                	<tr>
								                		<td><spring:message code="smart.stock.part.price" /></td>
								                		<td><input class="form-control" id="add_stockprice" name="add_stockprice" onkeyup="onlyNum(this);this.value=this.value.comma();"></td>
								                	</tr>
								                	<tr>
								                		<td><spring:message code="smart.stock.part.safe.count" /></td>
								                		<td><input class="form-control" id="add_safecount" name="add_safecount" onkeyup="onlyNum(this);"></td>
								                	</tr>
								                </table>
								            </div>
								            <div class="modal-footer">
								            	<div class="btn btn-secondary" data-dismiss="modal">닫기</div>
								            	<div class="btn btn-primary" id="btn_save">저장</div>
								            </div>
								        </div>
								    </div>
								</div>
								<!-- Modal -->
								
							</div>
							<div class="card-body">
								<div class="datatable table-responsive">
									<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
										<colgroup>
											<col width="15%">
											<col width="20%">
											<col width="10%">
											<col width="10%">
											<col width="10%">
											<col width="25%">
											<col width="10%">
										</colgroup>
										<thead>
											<tr>
												<th scope="col"><spring:message code="smart.stock.part.name" /></th>
												<th scope="col"><spring:message code="smart.stock.part.size" /></th>
												<th scope="col"><spring:message code="smart.stock.part.current.count" /></th>
												<th scope="col"><spring:message code="smart.stock.part.safe.count" /></th>
												<th scope="col"><spring:message code="smart.stock.part.price" /></th>
												<th scope="col"></th>
												<th scope="col"></th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th scope="col"><spring:message code="smart.stock.part.name" /></th>
												<th scope="col"><spring:message code="smart.stock.part.size" /></th>
												<th scope="col"><spring:message code="smart.stock.part.current.count" /></th>
												<th scope="col"><spring:message code="smart.stock.part.safe.count" /></th>
												<th scope="col"><spring:message code="smart.stock.part.price" /></th>
												<th scope="col"></th>
												<th scope="col"></th>
											</tr>
	                                    </tfoot>
	                                    <tbody id="data_table_tbody">
	                                    	<c:forEach var="result" items="${result }" varStatus="status">
	                                    		<tr>
													<td>${result.STOCK_NAME }</td>
													<td>${result.STOCK_SIZE }</td>
													<td>${result.STOCK_COUNT }</td>
													<td>${result.STOCK_SAFE_COUNT }</td>
													<td>${result.STOCK_PRICE }</td>
													<td>
														<input class="form-control" id="${result.STOCK_ID }_ordercount" name="${result.STOCK_ID }_ordercount" onkeyup="onlyNum(this);" style="width: 40%;float: left;" placeholder="수량 입력">
														&nbsp;
														<div class="btn btn-green btn-sm" id="${result.STOCK_ID }_instock">입고</div>
														<div class="btn btn-yellow btn-sm" id="${result.STOCK_ID }_outstock">출고</div>
													</td>
													<td>
														<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id="${result.STOCK_ID }_detail">
															<i data-feather='edit'></i>
														</div>
														<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id="${result.STOCK_ID }_delete">
															<i data-feather='trash-2'></i>
														</div>
													</td>
												</tr>
	                                    	</c:forEach>
	                                    </tbody>
									</table>
									
									<!-- Modal -->
									<div class="modal fade" id="modifyModalLayer" tabindex="-1" role="dialog" aria-labelledby="modifyModalLayerTitle" aria-hidden="true">
									    <div class="modal-dialog modal-dialog-centered" role="document">
									        <div class="modal-content">
									            <div class="modal-header">
									                <h5 class="modal-title" id="modifyModalLayerTitle"><spring:message code="smart.stock.part.detail" /></h5>
									                <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
									            </div>
									            <div class="modal-body">
									            	<input type="hidden" id="modify_stockid" name="modify_stockid">
									                <table class="addTable">
									                	<tr>
									                		<td><spring:message code="smart.stock.part.name" /></td>
									                		<td><input class="form-control" id="modify_stockname" name="add_stockname" readonly></td>
									                	</tr>
									                	<tr>
									                		<td><spring:message code="smart.stock.part.size" /></td>
									                		<td><input class="form-control" id="modify_stocksize" name="add_stocksize"></td>
									                	</tr>
									                	<tr>
									                		<td><spring:message code="smart.stock.part.count" /></td>
									                		<td><input class="form-control" id="modify_stockcount" name="add_stockcount" onkeyup="onlyNum(this);" readonly></td>
									                	</tr>
									                	<tr>
									                		<td><spring:message code="smart.stock.part.price" /></td>
									                		<td><input class="form-control" id="modify_stockprice" name="add_stockprice" onkeyup="onlyNum(this);this.value=this.value.comma();"></td>
									                	</tr>
									                	<tr>
									                		<td><spring:message code="smart.stock.part.safe.count" /></td>
									                		<td><input class="form-control" id="modify_safecount" name="add_safecount" onkeyup="onlyNum(this);"></td>
									                	</tr>
									                </table>
									            </div>
									            <div class="modal-footer">
									            	<div class="btn btn-secondary" data-dismiss="modal">닫기</div>
									            	<div class="btn btn-primary" id="btn_modify">저장</div>
									            </div>
									        </div>
									    </div>
									</div>
									<!-- Modal -->
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