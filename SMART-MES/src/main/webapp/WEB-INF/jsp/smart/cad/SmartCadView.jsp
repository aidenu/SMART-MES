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
<title><spring:message code="smart.cad.partlist.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>

<style>
	th, td {
		text-align: center;
	}
</style>

<script>
	
	var addIdx = 0;
	
	$(document).ready(function() {
		
		/**
			. 매뉴얼 추가 버튼
		*/
		$("#btn_add").click(function() {
			
			var addHtml = "";
			
			addHtml += "<tr id='"+addIdx+"'>";
			addHtml += "	<td><input class='form-control' id='"+addIdx+"_partgroupno' name='"+addIdx+"_partgroupno''></td>";
			addHtml += "	<td><input class='form-control' id='"+addIdx+"_partgroupname' name='"+addIdx+"_partgroupname'></td>";
			addHtml += "	<td><input class='form-control' id='"+addIdx+"_partgroupsize' name='"+addIdx+"_partgroupsize'></td>";
			addHtml += "	<td><input class='form-control' id='"+addIdx+"_partgroupmaterial' name='"+addIdx+"_partgroupmaterial'></td>";
			addHtml += "	<td><input class='form-control' id='"+addIdx+"_partgroupcount' name='"+addIdx+"_partgroupcount' onkeyup='onlyNum(this);'></td>";
			addHtml += "	<td>";
			addHtml += "		<select class='form-control' id='"+addIdx+"_partgroupgubun' name='"+addIdx+"_partgroupgubun'>";
			addHtml += "			<option value='<spring:message code="smart.common.process" />'><spring:message code="smart.common.process" /></option>";
			addHtml += "			<option value='<spring:message code="smart.common.purchase" />'><spring:message code="smart.common.purchase" /></option>";
			addHtml += "		</select>";
			addHtml += "	</td>";
			addHtml += "	<td></td>";
			addHtml += "	<td><div class='btn btn-green btn-sm' id='"+addIdx+"_regist'><spring:message code="smart.common.button.add" /></div></td>";
			addHtml += "	<td>";
			addHtml += "		<div class='btn btn-yellow btn-sm' id='"+addIdx+"_cancel'><spring:message code="smart.common.button.cancel" /></div>";
			addHtml += "	</td>";
			addHtml += "</tr>";
			
			$("#data_table_tbody").append(addHtml);
			$("#"+addIdx+"_partgroupno").focus();
			addIdx++;
		});
		
		//Close Button Click
		$("#btn_close").click(function() {
			self.close();
		});
		
		
		/**
			. 설계 작업 시작 Button Click
			. parameter
			  - modelid
		*/
		$("#btn_start").click(function() {
			
			var modelid = $("#modelid").val();
			var actiontype = "START";
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/cad/SmartCadWorkSave.do",
				data : {"modelid":modelid, "actiontype":actiontype},
				type : "POST",
				datatype : "text",
				success : function(data) {

					if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="space.common.saveerror" /> :: " + data);
					} else {
						$("#btn_start").css("display", "none");
						$("#singleDateDivstartdate span").html(data);
						$("#singleDateDivstartdate").css("display", "");
						$("#startdate").val(data);
					}
					
				}
				
			});	//ajax
			
		});	//btn_start Click
		
		/**
			. 설계 작업 완료 Button Click
			. parameter
			  - modelid
		*/
		$("#btn_end").click(function() {
			
			var modelid = $("#modelid").val();
			var actiontype = "END";
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/cad/SmartCadWorkSave.do",
				data : {"modelid":modelid, "actiontype":actiontype},
				type : "POST",
				datatype : "text",
				success : function(data) {

					if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="space.common.saveerror" /> :: " + data);
					} else {
						$("#btn_end").css("display", "none");
						$("#singleDateDivenddate span").html(data);
						$("#singleDateDivenddate").css("display", "");
						$("#enddate").val(data);
						
						$("#btn_worksave").css("display", "");
					}
					
				}
				
			});	//ajax
			
		});	//btn_start Click
		
		/**
			. 작업시간 변경 Button Click
		*/
		$("#btn_worksave").click(function() {
			
			var modelid = $("#modelid").val();
			var startdate = $("#startdate").val();
			var enddate = $("#enddate").val();
			
			if(startdate.replace("-", "") > enddate.replace("-", "")) {
				alert("<spring:message code="smart.common.date.validation.startend" />");
				return;
			}
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/cad/SmartCadWorkChange.do",
				data : {"modelid":modelid, "startdate":startdate, "enddate":enddate},
				type : "POST",
				datatype : "text",
				success : function(data) {

					if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="space.common.saveerror" /> :: " + data);
					}
					
				}
			});	//ajax
			
		});	//btn_worksave Click
		
	});	//$(document).ready()
	
	
	/**
		. Cancel Button Click
		. 매뉴얼 추가 이후 cancel
	*/
	$(document).on("click", "div[id$='_cancel']", function() {
		
		var trid = this.id.replace("_cancel", "");
		$("#"+trid).remove();
		
	});
	
	/*
		. REGIST Button Click : 부품 매뉴얼 추가 등록
		. Parameter : 
			- partgroupno, partgroupname, partgroupsize, partgroupmaterial, partgroupcount, partgroupgubun
		. validation : 
			- 각 항목 입력 유무
			- 품번 기등록 유무
	*/
	
	$(document).on("click", "div[id$='_regist']", function() {
		var trid = this.id.replace("_regist", "");
		var modelid = $("#modelid").val();
		var partgroupno = $("#"+trid+"_partgroupno").val();
		var partgroupname = $("#"+trid+"_partgroupname").val();
		var partgroupsize = $("#"+trid+"_partgroupsize").val();
		var partgroupmaterial = $("#"+trid+"_partgroupmaterial").val();
		var partgroupcount = $("#"+trid+"_partgroupcount").val();
		var partgroupgubun = $("#"+trid+"_partgroupgubun").val();
		
		if(partgroupno == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupno" />을 입력하세요.");
			$("#"+trid+"_partgroupno").focus();
			return;
		}
		
		if(partgroupname == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupname" />을 입력하세요.");
			$("#"+trid+"_partgroupname").focus();
			return;
		}
		
		if(partgroupsize == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupsize" />를 입력하세요.");
			$("#"+trid+"_partgroupsize").focus();
			return;
		}
		
		if(partgroupmaterial == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupmaterial" />을 입력하세요.");
			$("#"+trid+"_partgroupmaterial").focus();
			return;
		}
		
		if(partgroupcount == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupcount" />을 입력하세요.");
			$("#"+trid+"_partgroupcount").focus();
			return;
		}
		
		if(partgroupgubun == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupgubun" />을 선택하세.");
			$("#"+trid+"_partgroupgubun").focus();
			return;
		}
		
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/cad/SmartCadPartRegist.do",
			data : {"modelid":modelid, "partgroupno":partgroupno, "partgroupname":partgroupname, "partgroupsize":partgroupsize, 
				"partgroupmaterial":partgroupmaterial, "partgroupcount":partgroupcount, "partgroupgubun":partgroupgubun},
			type : "POST",
			datatype : "text",
			success : function(data) {
				if(data == "OK") {
					alert("<spring:message code="smart.common.save.ok" />");
					
					$.ajax({
						url : "${pageContext.request.contextPath}/smart/cad/SmartCadPartData.do",
						data : {"modelid":modelid},
						type : "POST",
						datatype : "json",
						success : function(data) {
							$('#dataTable').dataTable().fnClearTable();
							$('#dataTable').dataTable().fnDestroy();
							
							$.each(data, function(index, value){
								var strHtml = "";
								
								strHtml += "<tr>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_no' name='"+value.PART_GROUP_ID+"_no' value='"+value.PART_GROUP_NO+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_name' name='"+value.PART_GROUP_ID+"_name' value='"+value.PART_GROUP_NAME+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_size' name='"+value.PART_GROUP_ID+"_size' value='"+value.PART_GROUP_SIZE+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_material' name='"+value.PART_GROUP_ID+"_material' value='"+value.PART_GROUP_MATERIAL+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_count' name='"+value.PART_GROUP_ID+"_count' value='"+value.PART_GROUP_COUNT+"' onkeyup='onlyNum(this);'></td>";
								strHtml += "	<td>";
								strHtml += "		<select class='form-control' id='"+value.PART_GROUP_ID+"_gubun' name='"+value.PART_GROUP_ID+"_gubun'>";
								if(value.PART_GROUP_GUBUN == "<spring:message code="smart.common.process" />") {
									strHtml += "			<option value='<spring:message code="smart.common.process" />' selected><spring:message code="smart.common.process" /></option>";
									strHtml += "			<option value='<spring:message code="smart.common.purchase" />'><spring:message code="smart.common.purchase" /></option>";
								} else {
									strHtml += "			<option value='<spring:message code="smart.common.process" />'><spring:message code="smart.common.process" /></option>";
									strHtml += "			<option value='<spring:message code="smart.common.purchase" />' selected><spring:message code="smart.common.purchase" /></option>";
								}
								strHtml += "		</select>";
								strHtml += "	</td>";
								strHtml += "	<td>";
								if(value.ORDER_DATE == null && value.STOCK_DATE == null) {
									strHtml += "		<div class='form-group' style='margin-bottom: 0px;'>";
									strHtml += "			<select class='form-control form-control-solid' id='"+value.PART_GROUP_ID+"_orderorg' name='"+value.PART_GROUP_ID+"_orderorg'>";
									strHtml += "				<option value=''>-select-</option>";
										<c:forEach var="resultBasic" items="${resultBasic }" varStatus="basicStatus">
	    									<c:if test="${resultBasic.KEY == 'ORDER_ORG' }">
	    										strHtml += "	<option value='${resultBasic.VALUE }'>${resultBasic.VALUE }</option>";
	    									</c:if>
	    								</c:forEach>
	    							strHtml += "			</select>";
	    							strHtml += "		</div>";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_orderActionPurchase'><spring:message code="smart.common.order" /></div>";
								} else if(value.ORDER_DATE != null && value.STOCK_DATE == null) {
									strHtml += "		"+value.ORDER_ORG+"";
									strHtml += "		<br>";
									strHtml += "		"+value.ORDER_DATE+"";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_orderCancelPurchase'><spring:message code="smart.common.order.cancel" /></div>";
									strHtml += " 		/ ";
									strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_stockActionPurchase'><spring:message code="smart.common.stock" /></div>";
								} else if(value.ORDER_DATE != null && value.STOCK_DATE != null) {
									strHtml += "		"+value.ORDER_ORG+"";
									strHtml += "		<br>";
									strHtml += "		"+value.ORDER_DATE+" / "+value.STOCK_DATE+"";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_stockCancelPurchase'><spring:message code="smart.common.stock.cancel" /></div>";
								}
								strHtml += "	</td>";
								strHtml += "	<td>"+value.REG_DATE+"</td>";
								strHtml += "	<td>";
								strHtml += "		<div class='btn btn-red btn-sm' id='"+value.PART_GROUP_ID+"_delete'><spring:message code="smart.common.button.delete" /></div>";
								strHtml += "	</td>";
								strHtml += "</tr>";
								$("#data_table_tbody").append(strHtml);
							});	//$.each
							
							$('#dataTable').DataTable();	//jquery dataTable Plugin reload
							feather.replace();	//data-feather reload
						}
					});
					
				} else if(data.indexOf("ERROR") > -1) {
					alert("<spring:message code="smart.common.save.error" /> \n ["+data+"]");
				}
			}
		});
		
	});
	
	
	$(document).on("click", "div[id$='_save']", function() {
		var trid = this.id.replace("_save", "");
		var modelid = $("#modelid").val();
		var partgroupid = trid;
		var partgroupno = $("#"+trid+"_no").val();
		var partgroupname = $("#"+trid+"_name").val();
		var partgroupsize = $("#"+trid+"_size").val();
		var partgroupmaterial = $("#"+trid+"_material").val();
		var partgroupcount = $("#"+trid+"_count").val();
		var partgroupgubun = $("#"+trid+"_gubun").val();
		var orderorg = $("#"+trid+"_orderorg").val();
		
		if(partgroupno == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupno" />을 입력하세요.");
			$("#"+trid+"_partgroupno").focus();
			return;
		}
		
		if(partgroupname == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupname" />을 입력하세요.");
			$("#"+trid+"_partgroupname").focus();
			return;
		}
		
		if(partgroupsize == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupsize" />를 입력하세요.");
			$("#"+trid+"_partgroupsize").focus();
			return;
		}
		
		if(partgroupmaterial == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupmaterial" />을 입력하세요.");
			$("#"+trid+"_partgroupmaterial").focus();
			return;
		}
		
		if(partgroupcount == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupcount" />을 입력하세요.");
			$("#"+trid+"_partgroupcount").focus();
			return;
		}
		
		if(partgroupgubun == "") {
			alert("<spring:message code="smart.cad.partlist.partgroupgubun" />을 선택하세.");
			$("#"+trid+"_partgroupgubun").focus();
			return;
		}
		
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/cad/SmartCadPartSave.do",
			data : {"modelid":modelid, "partgroupid":partgroupid, "partgroupno":partgroupno, "partgroupname":partgroupname, "partgroupsize":partgroupsize, 
				"partgroupmaterial":partgroupmaterial, "partgroupcount":partgroupcount, "partgroupgubun":partgroupgubun},
			type : "POST",
			datatype : "text",
			success : function(data) {
				if(data == "OK") {
					alert("<spring:message code="smart.common.save.ok" />");
					
					$.ajax({
						url : "${pageContext.request.contextPath}/smart/cad/SmartCadPartData.do",
						data : {"modelid":modelid},
						type : "POST",
						datatype : "json",
						success : function(data) {
							$('#dataTable').dataTable().fnClearTable();
							$('#dataTable').dataTable().fnDestroy();
							
							$.each(data, function(index, value){
								var strHtml = "";
								
								strHtml += "<tr>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_no' name='"+value.PART_GROUP_ID+"_no' value='"+value.PART_GROUP_NO+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_name' name='"+value.PART_GROUP_ID+"_name' value='"+value.PART_GROUP_NAME+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_size' name='"+value.PART_GROUP_ID+"_size' value='"+value.PART_GROUP_SIZE+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_material' name='"+value.PART_GROUP_ID+"_material' value='"+value.PART_GROUP_MATERIAL+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_count' name='"+value.PART_GROUP_ID+"_count' value='"+value.PART_GROUP_COUNT+"' onkeyup='onlyNum(this);'></td>";
								strHtml += "	<td>";
								strHtml += "		<select class='form-control' id='"+value.PART_GROUP_ID+"_gubun' name='"+value.PART_GROUP_ID+"_gubun'>";
								if(value.PART_GROUP_GUBUN == "<spring:message code="smart.common.process" />") {
									strHtml += "			<option value='<spring:message code="smart.common.process" />' selected><spring:message code="smart.common.process" /></option>";
									strHtml += "			<option value='<spring:message code="smart.common.purchase" />'><spring:message code="smart.common.purchase" /></option>";
								} else {
									strHtml += "			<option value='<spring:message code="smart.common.process" />'><spring:message code="smart.common.process" /></option>";
									strHtml += "			<option value='<spring:message code="smart.common.purchase" />' selected><spring:message code="smart.common.purchase" /></option>";
								}
								strHtml += "		</select>";
								strHtml += "	</td>";
								strHtml += "	<td>";
								if(value.ORDER_DATE == null && value.STOCK_DATE == null) {
									strHtml += "		<div class='form-group' style='margin-bottom: 0px;'>";
									strHtml += "			<select class='form-control form-control-solid' id='"+value.PART_GROUP_ID+"_orderorg' name='"+value.PART_GROUP_ID+"_orderorg'>";
									strHtml += "				<option value=''>-select-</option>";
										<c:forEach var="resultBasic" items="${resultBasic }" varStatus="basicStatus">
	    									<c:if test="${resultBasic.KEY == 'ORDER_ORG' }">
	    										strHtml += "	<option value='${resultBasic.VALUE }'>${resultBasic.VALUE }</option>";
	    									</c:if>
	    								</c:forEach>
	    							strHtml += "			</select>";
	    							strHtml += "		</div>";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_orderActionPurchase'><spring:message code="smart.common.order" /></div>";
								} else if(value.ORDER_DATE != null && value.STOCK_DATE == null) {
									strHtml += "		"+value.ORDER_ORG+"";
									strHtml += "		<br>";
									strHtml += "		"+value.ORDER_DATE+"";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_orderCancelPurchase'><spring:message code="smart.common.order.cancel" /></div>";
									strHtml += " 		/ ";
									strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_stockActionPurchase'><spring:message code="smart.common.stock" /></div>";
								} else if(value.ORDER_DATE != null && value.STOCK_DATE != null) {
									strHtml += "		"+value.ORDER_ORG+"";
									strHtml += "		<br>";
									strHtml += "		"+value.ORDER_DATE+" / "+value.STOCK_DATE+"";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_stockCancelPurchase'><spring:message code="smart.common.stock.cancel" /></div>";
								}
								strHtml += "	</td>";
								strHtml += "	<td>"+value.REG_DATE+"</td>";
								strHtml += "	<td>";
								strHtml += "		<div class='btn btn-red btn-sm' id='"+value.PART_GROUP_ID+"_delete'><spring:message code="smart.common.button.delete" /></div>";
								strHtml += "	</td>";
								strHtml += "</tr>";
								$("#data_table_tbody").append(strHtml);
							});	//$.each
							
							$('#dataTable').DataTable();	//jquery dataTable Plugin reload
							feather.replace();	//data-feather reload
						}
					});
					
				} else if(data.indexOf("ERROR") > -1) {
					alert("<spring:message code="smart.common.save.error" /> \n ["+data+"]");
				}
			}
		});
		
	});
	
	
	$(document).on("click", "div[id$='_delete']", function() {
		var modelid = $("#modelid").val();
		var trid = this.id.replace("_delete", "");
		var msg = "<spring:message code="smart.common.delete.is" />";
		if(confirm(msg)) {
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/cad/SmartCadPartDelete.do",
				data : {"partgroupid":trid},
				type : "POST",
				datatype : "text",
				success : function(data) {
					if(data == "OK") {
						alert("<spring:message code="smart.common.delete.ok" />");
						
						$.ajax({
							url : "${pageContext.request.contextPath}/smart/cad/SmartCadPartData.do",
							data : {"modelid":modelid},
							type : "POST",
							datatype : "json",
							success : function(data) {
								$('#dataTable').dataTable().fnClearTable();
								$('#dataTable').dataTable().fnDestroy();
								
								$.each(data, function(index, value){
									var strHtml = "";
									
									strHtml += "<tr>";
									strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_no' name='"+value.PART_GROUP_ID+"_no' value='"+value.PART_GROUP_NO+"'></td>";
									strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_name' name='"+value.PART_GROUP_ID+"_name' value='"+value.PART_GROUP_NAME+"'></td>";
									strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_size' name='"+value.PART_GROUP_ID+"_size' value='"+value.PART_GROUP_SIZE+"'></td>";
									strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_material' name='"+value.PART_GROUP_ID+"_material' value='"+value.PART_GROUP_MATERIAL+"'></td>";
									strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_count' name='"+value.PART_GROUP_ID+"_count' value='"+value.PART_GROUP_COUNT+"' onkeyup='onlyNum(this);'></td>";
									strHtml += "	<td>";
									strHtml += "		<select class='form-control' id='"+value.PART_GROUP_ID+"_gubun' name='"+value.PART_GROUP_ID+"_gubun'>";
									if(value.PART_GROUP_GUBUN == "<spring:message code="smart.common.process" />") {
										strHtml += "			<option value='<spring:message code="smart.common.process" />' selected><spring:message code="smart.common.process" /></option>";
										strHtml += "			<option value='<spring:message code="smart.common.purchase" />'><spring:message code="smart.common.purchase" /></option>";
									} else {
										strHtml += "			<option value='<spring:message code="smart.common.process" />'><spring:message code="smart.common.process" /></option>";
										strHtml += "			<option value='<spring:message code="smart.common.purchase" />' selected><spring:message code="smart.common.purchase" /></option>";
									}
									strHtml += "		</select>";
									strHtml += "	</td>";
									strHtml += "	<td>";
									if(value.ORDER_DATE == null && value.STOCK_DATE == null) {
										strHtml += "		<div class='form-group' style='margin-bottom: 0px;'>";
										strHtml += "			<select class='form-control form-control-solid' id='"+value.PART_GROUP_ID+"_orderorg' name='"+value.PART_GROUP_ID+"_orderorg'>";
										strHtml += "				<option value=''>-select-</option>";
											<c:forEach var="resultBasic" items="${resultBasic }" varStatus="basicStatus">
		    									<c:if test="${resultBasic.KEY == 'ORDER_ORG' }">
		    										strHtml += "	<option value='${resultBasic.VALUE }'>${resultBasic.VALUE }</option>";
		    									</c:if>
		    								</c:forEach>
		    							strHtml += "			</select>";
		    							strHtml += "		</div>";
										strHtml += "		<br>";
										strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_orderActionPurchase'><spring:message code="smart.common.order" /></div>";
									} else if(value.ORDER_DATE != null && value.STOCK_DATE == null) {
										strHtml += "		"+value.ORDER_ORG+"";
										strHtml += "		<br>";
										strHtml += "		"+value.ORDER_DATE+"";
										strHtml += "		<br>";
										strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_orderCancelPurchase'><spring:message code="smart.common.order.cancel" /></div>";
										strHtml += " 		/ ";
										strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_stockActionPurchase'><spring:message code="smart.common.stock" /></div>";
									} else if(value.ORDER_DATE != null && value.STOCK_DATE != null) {
										strHtml += "		"+value.ORDER_ORG+"";
										strHtml += "		<br>";
										strHtml += "		"+value.ORDER_DATE+" / "+value.STOCK_DATE+"";
										strHtml += "		<br>";
										strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_stockCancelPurchase'><spring:message code="smart.common.stock.cancel" /></div>";
									}
									strHtml += "	</td>";
									strHtml += "	<td>"+value.REG_DATE+"</td>";
									strHtml += "	<td>";
									strHtml += "		<div class='btn btn-red btn-sm' id='"+value.PART_GROUP_ID+"_delete'><spring:message code="smart.common.button.delete" /></div>";
									strHtml += "	</td>";
									strHtml += "</tr>";
									$("#data_table_tbody").append(strHtml);
								});	//$.each
								
								$('#dataTable').DataTable();	//jquery dataTable Plugin reload
								feather.replace();	//data-feather reload
							}
						});
						
					} else if(data.indexOf("ERROR") > -1) {
						alert("<spring:message code="smart.common.delete.error" /> \n ["+data+"]");
					}
				}
			});
		}
		
	});
	
	
	$(document).on("click", "div[id$='Purchase']", function() {
		
		var trid = this.id;
		var partgroupid = "";
		var actiontype = "";
		var orderorg = "";
		
		if(trid.indexOf("_orderActionPurchase") > -1) {
			actiontype = "ORDER";
			partgroupid = trid.replace("_orderActionPurchase", "");
			orderorg = $("#"+partgroupid+"_orderorg").val();
			
			if(orderorg == "") {
				alert("발주업체를 선택하세요.");
				return;
			}
			
		} else if(trid.indexOf("_stockActionPurchase") > -1) {
			actiontype = "STOCK";
			partgroupid = trid.replace("_stockActionPurchase", "");
			orderorg = "";
		} else if(trid.indexOf("_orderCancelPurchase") > -1) {
			actiontype = "ORDER_CANCEL";
			partgroupid = trid.replace("_orderCancelPurchase", "");
			orderorg = "";
		} else if(trid.indexOf("_stockCancelPurchase") > -1) {
			actiontype = "STOCK_CANCEL";
			partgroupid = trid.replace("_stockCancelPurchase", "");
			orderorg = "";
		}
		
		var modelid = $("#modelid").val();
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/cad/SmartCadPartOrderSave.do",
			data : {"partgroupid":partgroupid, "actiontype":actiontype, "orderorg":orderorg},
			type : "POST",
			datatype : "text",
			success : function(data) {
				
				if(data == "OK") {
					
					if(actiontype == "ORDER") {
						alert("<spring:message code="smart.purchase.order" />");
					} else if(actiontype == "STOCK") {
						alert("<spring:message code="smart.purchase.stock" />");
					} else if(actiontype == "ORDER_CANCEL") {
						alert("<spring:message code="smart.purchase.order.cancel" />");
					} else if(actiontype == "STOCK_CANCEL") {
						alert("<spring:message code="smart.purchase.stock.cancel" />");
					}
					
					
					$.ajax({
						url : "${pageContext.request.contextPath}/smart/cad/SmartCadPartData.do",
						data : {"modelid":modelid},
						type : "POST",
						datatype : "json",
						success : function(data) {
							$('#dataTable').dataTable().fnClearTable();
							$('#dataTable').dataTable().fnDestroy();
							
							$.each(data, function(index, value){
								var strHtml = "";
								
								strHtml += "<tr>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_no' name='"+value.PART_GROUP_ID+"_no' value='"+value.PART_GROUP_NO+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_name' name='"+value.PART_GROUP_ID+"_name' value='"+value.PART_GROUP_NAME+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_size' name='"+value.PART_GROUP_ID+"_size' value='"+value.PART_GROUP_SIZE+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_material' name='"+value.PART_GROUP_ID+"_material' value='"+value.PART_GROUP_MATERIAL+"'></td>";
								strHtml += "	<td><input class='form-control' id='"+value.PART_GROUP_ID+"_count' name='"+value.PART_GROUP_ID+"_count' value='"+value.PART_GROUP_COUNT+"' onkeyup='onlyNum(this);'></td>";
								strHtml += "	<td>";
								strHtml += "		<select class='form-control' id='"+value.PART_GROUP_ID+"_gubun' name='"+value.PART_GROUP_ID+"_gubun'>";
								if(value.PART_GROUP_GUBUN == "<spring:message code="smart.common.process" />") {
									strHtml += "			<option value='<spring:message code="smart.common.process" />' selected><spring:message code="smart.common.process" /></option>";
									strHtml += "			<option value='<spring:message code="smart.common.purchase" />'><spring:message code="smart.common.purchase" /></option>";
								} else {
									strHtml += "			<option value='<spring:message code="smart.common.process" />'><spring:message code="smart.common.process" /></option>";
									strHtml += "			<option value='<spring:message code="smart.common.purchase" />' selected><spring:message code="smart.common.purchase" /></option>";
								}
								strHtml += "		</select>";
								strHtml += "	</td>";
								strHtml += "	<td>";
								if(value.ORDER_DATE == null && value.STOCK_DATE == null) {
									strHtml += "		<div class='form-group' style='margin-bottom: 0px;'>";
									strHtml += "			<select class='form-control form-control-solid' id='"+value.PART_GROUP_ID+"_orderorg' name='"+value.PART_GROUP_ID+"_orderorg'>";
									strHtml += "				<option value=''>-select-</option>";
										<c:forEach var="resultBasic" items="${resultBasic }" varStatus="basicStatus">
	    									<c:if test="${resultBasic.KEY == 'ORDER_ORG' }">
	    										strHtml += "	<option value='${resultBasic.VALUE }'>${resultBasic.VALUE }</option>";
	    									</c:if>
	    								</c:forEach>
	    							strHtml += "			</select>";
	    							strHtml += "		</div>";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_orderActionPurchase'><spring:message code="smart.common.order" /></div>";
								} else if(value.ORDER_DATE != null && value.STOCK_DATE == null) {
									strHtml += "		"+value.ORDER_ORG+"";
									strHtml += "		<br>";
									strHtml += "		"+value.ORDER_DATE+"";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_orderCancelPurchase'><spring:message code="smart.common.order.cancel" /></div>";
									strHtml += " 		/ ";
									strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_stockActionPurchase'><spring:message code="smart.common.stock" /></div>";
								} else if(value.ORDER_DATE != null && value.STOCK_DATE != null) {
									strHtml += "		"+value.ORDER_ORG+"";
									strHtml += "		<br>";
									strHtml += "		"+value.ORDER_DATE+" / "+value.STOCK_DATE+"";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_stockCancelPurchase'><spring:message code="smart.common.stock.cancel" /></div>";
								}
								strHtml += "	</td>";
								strHtml += "	<td>"+value.REG_DATE+"</td>";
								strHtml += "	<td>";
								strHtml += "		<div class='btn btn-red btn-sm' id='"+value.PART_GROUP_ID+"_delete'><spring:message code="smart.common.button.delete" /></div>";
								strHtml += "	</td>";
								strHtml += "</tr>";
								$("#data_table_tbody").append(strHtml);
							});	//$.each
							
							$('#dataTable').DataTable();	//jquery dataTable Plugin reload
							feather.replace();	//data-feather reload
						}
					});
					
				} else if(data.indexOf("ERROR") > -1) {
					alert("<spring:message code="smart.common.save.error" /> \n ["+data+"]");
				}
				
			}
			
		});
		
	});
	
</script>
</head>
<body class="nav-fixed">

		
		<form name="dataForm" method="post" >
			<input type="hidden" name="modelid" id="modelid" value="${modelid }">
			<div class="card mb-4">
				<div class="card card-header-actions">
					 <div class="card-header">
				    	<spring:message code="smart.cad.partlist" />
				    	<div>
				    		<div class="btn btn-outline-teal btn-sm" id="btn_start"><spring:message code="smart.cad.work.start" /></div>
			    			<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivstartdate">
							    <i class="mr-2 text-primary" data-feather="calendar"></i>
							    <span></span>
							    <input type="hidden" name="startdate" id="startdate">
							    <i class="ml-1" data-feather="chevron-down"></i>
							</div>
					    	&nbsp;
					    	~
					    	&nbsp;
				    		<div class="btn btn-outline-teal btn-sm" id="btn_end"><spring:message code="smart.cad.work.end" /></div>
				    		<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivenddate">
							    <i class="mr-2 text-primary" data-feather="calendar"></i>
							    <span></span>
							    <input type="hidden" name="enddate" id="enddate">
							    <i class="ml-1" data-feather="chevron-down"></i>
							</div>
							&nbsp;
							<div class="btn btn-outline-teal btn-sm" id="btn_worksave"><spring:message code="smart.common.button.work.save" /></div>
					    	&nbsp;
					    	&nbsp;
				    		<div class="btn btn-primary btn-sm" id="btn_add"><spring:message code="smart.common.button.add" /></div>
					    	&nbsp;
					    	<div class="btn btn-primary btn-sm" id="btn_close"><spring:message code="smart.common.button.close" /></div>
				    	</div>
				    </div>
				    
				    <div class="card-body">
						<div class="datatable table-responsive">
							<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
					    		<thead>
					    			<tr>
					    				<th style="width:6%;"><spring:message code="smart.cad.partlist.partgroupno" /></th>
					    				<th><spring:message code="smart.cad.partlist.partgroupname" /></th>
					    				<th><spring:message code="smart.cad.partlist.partgroupsize" /></th>
					    				<th><spring:message code="smart.cad.partlist.partgroupmaterial" /></th>
					    				<th style="width:6%;"><spring:message code="smart.cad.partlist.partgroupcount" /></th>
					    				<th style="width:9%;"><spring:message code="smart.cad.partlist.partgroupgubun" /></th>
					    				<th style="width:15%;"><spring:message code="smart.common.order" /></th>
					    				<th style="width:10%;"><spring:message code="smart.cad.partlist.regdate" /></th>
					    				<th style="width:6%;"></th>
					    			</tr>
					    		</thead>
					    		<tfoot>
					    			<tr>
					    				<th><spring:message code="smart.cad.partlist.partgroupno" /></th>
					    				<th><spring:message code="smart.cad.partlist.partgroupname" /></th>
					    				<th><spring:message code="smart.cad.partlist.partgroupsize" /></th>
					    				<th><spring:message code="smart.cad.partlist.partgroupmaterial" /></th>
					    				<th><spring:message code="smart.cad.partlist.partgroupcount" /></th>
					    				<th><spring:message code="smart.cad.partlist.partgroupgubun" /></th>
					    				<th><spring:message code="smart.common.order" /></th>
					    				<th><spring:message code="smart.cad.partlist.regdate" /></th>
					    				<th></th>
					    			</tr>
					    		</tfoot>
					    		<tbody id="data_table_tbody">
					    			<c:forEach var="result" items="${result }" varStatus="status">
					    				<tr>
						    				<td><input class="form-control" id="${result.PART_GROUP_ID}_no" name="${result.PART_GROUP_ID }_no" value="${result.PART_GROUP_NO }"></td>
						    				<td><input class="form-control" id="${result.PART_GROUP_ID}_name" name="${result.PART_GROUP_ID }_name" value="${result.PART_GROUP_NAME }"></td>
						    				<td><input class="form-control" id="${result.PART_GROUP_ID}_size" name="${result.PART_GROUP_ID }_size" value="${result.PART_GROUP_SIZE }"></td>
						    				<td><input class="form-control" id="${result.PART_GROUP_ID}_material" name="${result.PART_GROUP_ID }_material" value="${result.PART_GROUP_MATERIAL }"></td>
						    				<td><input class="form-control" id="${result.PART_GROUP_ID}_count" name="${result.PART_GROUP_ID }_count" value="${result.PART_GROUP_COUNT }" onkeyup="onlyNum(this);"></td>
						    				<td>
						    					<select class="form-control" id="${result.PART_GROUP_ID}_gubun" name="${result.PART_GROUP_ID }_gubun">
						    						<c:set var="process"><spring:message code="smart.common.process" /></c:set>
						    						<c:set var="purchase"><spring:message code="smart.common.purchase" /></c:set>
						    						<c:choose>
						    							<c:when test="${result.PART_GROUP_GUBUN == process}">
						    								<option value="<spring:message code="smart.common.process" />" selected><spring:message code="smart.common.process" /></option>
						    								<option value="<spring:message code="smart.common.purchase" />"><spring:message code="smart.common.purchase" /></option>
						    							</c:when>
						    							<c:otherwise>
						    								<option value="<spring:message code="smart.common.process" />"><spring:message code="smart.common.process" /></option>
						    								<option value="<spring:message code="smart.common.purchase" />" selected><spring:message code="smart.common.purchase" /></option>
						    							</c:otherwise>
						    						</c:choose>
						    					</select>
						    				</td>
						    				<td>
						    					<c:choose>
						    						<c:when test="${result.ORDER_DATE eq null && result.STOCK_DATE eq null }">
						    							<div class="form-group" style="margin-bottom: 0px;">
							    							<select class="form-control form-control-solid" id="${result.PART_GROUP_ID }_orderorg" name="${result.PART_GROUP_ID }_orderorg">
							    								<option value="">-select-</option>
							    								<c:forEach var="resultBasic" items="${resultBasic }" varStatus="basicStatus">
							    									<c:if test="${resultBasic.KEY == 'ORDER_ORG' }">
							    										<option value="${resultBasic.VALUE }">${resultBasic.VALUE }</option>
							    									</c:if>
							    								</c:forEach>
							    							</select>
						    							</div>
						    							<br>
						    							<div class="btn btn-green btn-sm" id="${result.PART_GROUP_ID }_orderActionPurchase"><spring:message code="smart.common.order" /></div>
						    						</c:when>
						    						<c:when test="${result.ORDER_DATE ne null && result.STOCK_DATE eq null }">
						    							${result.ORDER_ORG }<br>
						    							${result.ORDER_DATE }<br>
						    							<div class="btn btn-orange btn-sm" id="${result.PART_GROUP_ID }_orderCancelPurchase"><spring:message code="smart.common.order.cancel" /></div> / 
						    							<div class="btn btn-green btn-sm" id="${result.PART_GROUP_ID }_stockActionPurchase"><spring:message code="smart.common.stock" /></div> 
						    						</c:when>
						    						<c:when test="${result.ORDER_DATE ne null && result.STOCK_DATE ne null }">
						    							${result.ORDER_ORG }<br>
						    							${result.ORDER_DATE } / ${result.STOCK_DATE }<br>
						    							<div class="btn btn-orange btn-sm" id="${result.PART_GROUP_ID }_stockCancelPurchase"><spring:message code="smart.common.stock.cancel" /></div>
						    						</c:when>
						    					</c:choose>
						    					
						    				</td>
						    				<td>${result.REG_DATE }</td>
						    				<td>
						    					<div class="btn btn-green btn-sm" id="${result.PART_GROUP_ID }_save"><spring:message code="smart.common.button.save" /></div>
						    					<br style="display:block;margin:10px;content:'';">
						    					<div class="btn btn-red btn-sm" id="${result.PART_GROUP_ID }_delete"><spring:message code="smart.common.button.delete" /></div>
						    				</td>
						    			</tr>
					    			</c:forEach>
			                     </tbody>
					    	</table>
					    </div>
				    </div>
			    
			    </div>
			</div>
		
		</form>
		   
		    
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smartscripts.js'/>"></script>
<script src="<c:url value='/js/smart/datatables.js'/>"></script>
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
		<c:choose>
			<c:when test="${CAD_START_DATE eq null }">
				$("#btn_start").css("display", "");
				$("#singleDateDivstartdate").css("display", "none");
				$("#btn_worksave").css("display", "none");
			</c:when>
			<c:otherwise>
				$("#btn_start").css("display", "none");
				$("#singleDateDivstartdate span").html("${CAD_START_DATE}");
				$("#singleDateDivstartdate").css("display", "");
				$("#startdate").val("${CAD_START_DATE}");
				$("#btn_worksave").css("display", "none");
			</c:otherwise>
		</c:choose>
		
		
		<c:choose>
			<c:when test="${CAD_END_DATE eq null }">
				$("#btn_end").css("display", "");
				$("#singleDateDivenddate").css("display", "none");
				$("#btn_worksave").css("display", "none");
			</c:when>
			<c:otherwise>
				$("#btn_end").css("display", "none");
				$("#singleDateDivenddate span").html("${CAD_END_DATE}");
				$("#singleDateDivenddate").css("display", "");
				$("#enddate").val("${CAD_END_DATE}");
				$("#btn_worksave").css("display", "");
			</c:otherwise>
		</c:choose>
	});
</script>
<iframe name="hiddenFrame" width="0" height="0" style="visibility:hidden"></iframe>
</body>
</html>