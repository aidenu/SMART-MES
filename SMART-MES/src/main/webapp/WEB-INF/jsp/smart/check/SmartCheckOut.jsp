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
<title><spring:message code="smart.check.out.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>
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
				url : "${pageContext.request.contextPath}/smart/check/SmartCheckOutModelData.do",
				data : {"startDate":startDate, "endDate":endDate},
				type : "POST",
				datatype : "json",
				success : function(data) {
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
					strHtml += "		<th><spring:message code="smart.check.out.desc" /></th>";
					strHtml += "		<th><spring:message code="smart.check.out.end" /></th>";
					strHtml += "	</tr>";
					strHtml += "</thead>";
					strHtml += "<tfoot>";
					strHtml += "	<tr>";
					strHtml += "		<th><spring:message code="smart.business.modelno" /></th>";
					strHtml += "		<th><spring:message code="smart.business.productno" /></th>";
					strHtml += "		<th><spring:message code="smart.business.productname" /></th>";
					strHtml += "		<th><spring:message code="smart.business.orderdate" /></th>";
					strHtml += "		<th><spring:message code="smart.business.duedate" /></th>";
					strHtml += "		<th><spring:message code="smart.check.out.desc" /></th>";
					strHtml += "		<th><spring:message code="smart.check.out.end" /></th>";
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
						
						strHtml += "	<td>"+chkNull(value.PRODUCT_NO)+"</td>";
						strHtml += "	<td>"+chkNull(value.PRODUCT_NAME)+"</td>";
						strHtml += "	<td>"+chkNull(value.ORDER_DATE)+"</td>";
						strHtml += "	<td>"+chkNull(value.DUE_DATE)+"</td>";
						strHtml += "	<td>";
						strHtml += "		<div class='mb-0'>";
						strHtml += "			<textarea class='form-control' name='check_desc' id='"+value.MODEL_ID+"_desc' modelid='"+value.MODEL_ID+"' rows='2'>"+chkNull(value.CHECK_DESC)+"</textarea>";
						strHtml += "		</div>";
						strHtml += "	</td>";
						strHtml += "	<td>";
						
						if(value.CURRENT_STATUS != "COMPLETE") {
							strHtml += "		<button type='button' class='btn btn-outline-green btn-sm' name='btn_end' id='"+value.MODEL_ID+"_end' modelid='"+value.MODEL_ID+"'>";
							strHtml += "			납품";
							strHtml += "		</button>";
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
		
		
		/**
		*	납품처리
		*/
		$(document).on("click", "button[name=btn_end]", function() {
			
			const modelid = $(this).attr("modelid");
			const msg = "납품처리 하시겠습니까?";
			
			if(confirm(msg)) {
				
				$.ajax({
					url: "${pageContext.request.contextPath}/smart/check/SmartCheckOutModelEnd.do",
					data: {"modelid":modelid},
					type: "POST",
					datatype: "text",
					success: function(data) {
						
						if(data.indexOf("ERROR") > -1) {
							alert("<spring:message code="smart.common.save.error" /> :: " + data);
						} else {
							$("#btn_search").trigger("click");
						}
						
					}
				});
				
			}
			
		});
		
		
		/**
		*	저장
		*/
		$("#btn_save").click(function() {
			
			let modelid = "";
			let check_desc = "";
			let strHtml = ""; 
			
			$("textarea[name=check_desc]").each(function() {
				
				modelid = $(this).attr("modelid");
				check_desc = $(this).val();
				
				strHtml += modelid + "♬";
				strHtml += check_desc + "♩";
				
			});
			
			strHtml = strHtml.substring(0, strHtml.length-1);
			
			
			$.ajax({
				
				url: "${pageContext.request.contextPath}/smart/check/SmartCheckOutModelSave.do",
				data: {"arraystr":strHtml},
				type: "POST",
				datatype: "text",
				success: function(data) {
					
					if(data == "OK") {
						alert("<spring:message code="smart.common.save.ok" />");
					} else if(data.indexOf("ERROR")) {
						alert("<spring:message code="smart.common.save.error" /> :: " + data);
					}
					
				}
				
			});
			
		});
		
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
										<span><spring:message code="smart.check.out.title" /></span>
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
								&nbsp;
								<div class="btn btn-outline-success" id="btn_save"><spring:message code="smart.common.button.save" /></div>
							</div>
							<div class="card-body">
								<div class="datatable table-responsive">
									<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
										<colgroup>
											<col width="15%">
											<col width="15%">
											<col width="15%">
											<col width="10%">
											<col width="10%">
											<col width="27%">
											<col width="8%">
										</colgroup>
										<thead>
											<tr>
												<th scope="col"><spring:message code="smart.business.modelno" /></th>
												<th scope="col"><spring:message code="smart.business.productno" /></th>
												<th scope="col"><spring:message code="smart.business.productname" /></th>
												<th scope="col"><spring:message code="smart.business.orderdate" /></th>
												<th scope="col"><spring:message code="smart.business.duedate" /></th>
												<th scope="col"><spring:message code="smart.check.out.desc" /></th>
												<th scope="col"><spring:message code="smart.check.out.end" /></th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th scope="col"><spring:message code="smart.business.modelno" /></th>
												<th scope="col"><spring:message code="smart.business.productno" /></th>
												<th scope="col"><spring:message code="smart.business.productname" /></th>
												<th scope="col"><spring:message code="smart.business.orderdate" /></th>
												<th scope="col"><spring:message code="smart.business.duedate" /></th>
												<th scope="col"><spring:message code="smart.check.out.desc" /></th>
												<th scope="col"><spring:message code="smart.check.out.end" /></th>
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