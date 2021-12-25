<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	String[] arrHour = {"00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"};
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Language" content="ko" >
<title><spring:message code="smart.work.out.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/smartvalidate.js'/>"></script>
<script src="<c:url value='/js/smart/smartutil.js'/>"></script>
<style>
	
	#dataTable thead,
	#dataTable tfoot {
	  color: #0061f2;
	  text-align: center;
	}
	
	.start-work {
		text-align: center;
		cursor: pointer;
	}
	
	.end-work {
		text-align: center;
		cursor: pointer;
	}
	
	.modal-dialog {
		max-width: 400px !important;
	}
</style>
<script>
	
	var userlist = new Map();
	
	$(document).ready(function() {
		
		/**
			.외주 업체 ID 가져오기
		*/
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/work/SmartOutWorkUser.do",
			type : "POST",
			datatype : "json",
			success : function(data) {
				
				$.each(data, function(index, value) {
					userlist.put(value.USER_ID, value.USER_NM);
					console.log("STEP1 :: " + userlist.get(value.USER_ID));
				});
				
			}	//success
			
		});	//$.ajax
		
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
				url : "${pageContext.request.contextPath}/smart/work/SmartOutWorkModelData.do",
				data : {"startDate":startDate, "endDate":endDate},
				type : "POST",
				datatype : "json",
				success : function(data) {
// 					$('#dataTable').dataTable().fnClearTable();		//가공작업 상세 페이지 Span으로 인해 처리 안됨
// 					$('#dataTable').dataTable().fnDestroy();
					$("#dataTable").empty();
					
					var strHtml = "";
					
					strHtml += "<thead>";
					strHtml += "	<tr>";
					strHtml += "		<th><spring:message code="smart.business.modelno" /></th>";
					strHtml += "		<th><spring:message code="smart.business.productno" /></th>";
					strHtml += "		<th><spring:message code="smart.business.productname" /></th>";
					strHtml += "		<th><spring:message code="smart.business.orderdate" /></th>";
					strHtml += "		<th><spring:message code="smart.business.duedate" /></th>";
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
					strHtml += "		<th>Detail</th>";
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
						strHtml += "	<td>";
						strHtml += "		<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+value.MODEL_ID+"_work'>";
						strHtml += "			<input type='hidden' id='"+value.MODEL_ID+"_modelno' name='"+value.MODEL_ID+"_modelno' value='"+value.MODEL_NO+"'>";
						strHtml += "			<i data-feather='edit'></i>";
						strHtml += "		</div>";
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
		. Work Button Click
		. parameter
		  - modelid
	*/
	$(document).on("click", "div[id$='_work']", function() {
		
		var keys = userlist.keys();
		var modelid = this.id.replace("_work", "");
		var modelno = $("#"+modelid+"_modelno").val();
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/work/SmartOutWorkData.do",
			data : {"modelid":modelid},
			type : "POST",
			datatype : "json",
			success : function(data) {
				
				/******** subTitle Area Setting Start *********/
				var subtitleHtml = "";
				subtitleHtml += "&nbsp;&nbsp;"
				subtitleHtml += "<i data-feather='arrow-left-circle' id='btn_back' style='cursor:pointer;width:30px;height:25px;'></i>";
				subtitleHtml += "&nbsp;&nbsp;"
				subtitleHtml += modelno;
				
				$("#subtitle").html(subtitleHtml);
				feather.replace();	//data-feather reload
				/******** subTitle Area Setting End *********/
				
				/******** dataTable Area Setting Start *********/
				var partgroupid = "";
				$('#dataTable').dataTable().fnClearTable();
				$('#dataTable').dataTable().fnDestroy();
				$("#dataTable").empty();
				
				var strHtml = "";
				strHtml += "<colgroup>";
				strHtml += "	<col width='10%'>";
				strHtml += "	<col width='20%'>";
				strHtml += "	<col width='7%'>";
				strHtml += "	<col width='8%'>";
				strHtml += "	<col width='10%'>";
				strHtml += "	<col width='15%'>";
				strHtml += "	<col width='15%'>";
				strHtml += "	<col width='15%'>";
				strHtml += "</colgroup>";
				
				strHtml += "<thead>";
				strHtml += "	<tr>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupno" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupname" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupcount" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.process.procmanage" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.out.user" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.start.date" /><br>(<spring:message code="smart.work.plan.start.date" />)</th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.end.date" /><br>(<spring:message code="smart.work.plan.end.date" />)</th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.out.price" /></th>";
				strHtml += "	</tr>";
				strHtml += "</thead>";
				strHtml += "<tfoot>";
				strHtml += "	<tr>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupno" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupname" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupcount" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.process.procmanage" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.out.user" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.start.date" /><br>(<spring:message code="smart.work.plan.start.date" />)</th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.end.date" /><br>(<spring:message code="smart.work.plan.end.date" />)</th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.out.price" /></th>";
				strHtml += "	</tr>";
				strHtml += "</tfoot>";
				strHtml += "<tbody id='data_table_tbody'>";

				$.each(data, function(index, value){
					strHtml += "	<tr>";
					if(partgroupid == "" || partgroupid != value.PART_GROUP_ID) {
						strHtml += "		<td rowspan='"+value.ROWCNT+"'>"+chkNull(value.PART_GROUP_NO) + "</td>";
						strHtml += "		<td rowspan='"+value.ROWCNT+"'>"+chkNull(value.PART_GROUP_NAME)+"</td>";
						strHtml += "		<td rowspan='"+value.ROWCNT+"'>"+chkNull(value.PART_GROUP_COUNT)+"</td>";
					}
					strHtml += "		<td>"+chkNull(value.WORK_NAME);
					strHtml += "			<input type='hidden' name='"+value.WORK_ID+"_partgroupid' id='"+value.WORK_ID+"_partgroupid' value='"+value.PART_GROUP_ID+"'>";
					strHtml += " 	</td>";
// 					strHtml += "		<td>"+chkNull(value.WORK_USER_NM)+"</td>";
					strHtml += "		<td>";
					strHtml += "			<div class='form-group' style='margin-bottom: 0px;'>";
					strHtml += "				<select class='form-control form-control-solid' id='"+value.WORK_ID+"_workuser' name='"+value.WORK_ID+"_workuser'>";
					strHtml += "					<option value=''> - 선택 - </option>";
					for(var i=0; i<keys.length; i++) {
						if(userlist.get(keys[i]) == value.WORK_USER_NM) {
							strHtml += "			<option value='"+keys[i]+"' selected>"+userlist.get(keys[i])+"</option>";
						} else {
							strHtml += "			<option value='"+keys[i]+"'>"+userlist.get(keys[i])+"</option>";
						}
					}
					strHtml += "				</select>";
					strHtml += "			</div>";
					strHtml += "		</td>";
					
					if(value.WORK_START_DATE == null) {
						if(value.PLAN_START_DELAY == "DELAY") {
							strHtml += "		<td class='bg-yellow text-red font-weight-700 rounded-lg start-work' id='"+value.WORK_ID+"_start'>";
							strHtml += "			<i data-feather='mouse-pointer'></i>(Click 작업시작!)<br>("+chkNull(value.PLAN_START_DATE)+")";
							strHtml += "		</td>";
						} else {
							strHtml += "		<td class='bg-teal text-white rounded-lg start-work' id='"+value.WORK_ID+"_start'>";
							strHtml += "			<i data-feather='mouse-pointer'></i>(Click 작업시작!)<br>("+chkNull(value.PLAN_START_DATE)+")";
							strHtml += "		</td>";
						}
					} else {
						strHtml += "		<td class='end-work' name='worktime_edit' gubun='start' workid='"+value.WORK_ID+"' worktime='"+value.WORK_START_DATE+"' workhour='"+value.WORK_START_HOUR+"'>"+chkNull(value.WORK_START_DATE)+" " + chkNull(value.WORK_START_HOUR)+ "시 <i data-feather='edit'></i><br>("+chkNull(value.PLAN_START_DATE)+")</td>";
					}
						
					if(value.WORK_START_DATE != null && value.WORK_END_DATE == null) {
						if(value.PLAN_END_DELAY == "DELAY") {
							strHtml += "		<td class='bg-yellow text-red font-weight-700 rounded-lg start-work' id='"+value.WORK_ID+"_end'><i data-feather='mouse-pointer'></i>(Click 작업완료!)<br>("+chkNull(value.PLAN_END_DATE)+")</td>";
						} else {
							strHtml += "		<td class='bg-teal text-white rounded-lg start-work' id='"+value.WORK_ID+"_end'><i data-feather='mouse-pointer'></i>(Click 작업완료!)<br>("+chkNull(value.PLAN_END_DATE)+")</td>";
						}
					} else {
						strHtml += "		<td class='end-work' name='worktime_edit' gubun='end' workid='"+value.WORK_ID+"' worktime='"+value.WORK_END_DATE+"' workhour='"+value.WORK_END_HOUR+"'>"+chkNull(value.WORK_END_DATE)+" " + chkNull(value.WORK_END_HOUR)+ "시 <i data-feather='edit'></i><br>("+chkNull(value.PLAN_END_DATE)+")</td>";
					}
					strHtml += "		<td>";
					strHtml += "			<input class='form-control' id='"+value.WORK_ID+"_price' name='"+value.WORK_ID+"_price' style='width:70%;display:inherit;' value='"+chkNull(value.OUT_PRICE)+"' onkeyup='onlyNum(this);this.value=this.value.comma();'>";
					strHtml += "			&nbsp;";
					strHtml += "			<div class='btn btn-outline-teal btn-sm' id='"+value.WORK_ID+"_pricesave'><spring:message code="smart.common.button.save" /></div>";
					strHtml += "		</td>";
					strHtml += "	</tr>";
					
					partgroupid = value.PART_GROUP_ID;
				});	//$.each
				
				strHtml += "</tbody>";
				
				$("#dataTable").html(strHtml);
				
// 				$('#dataTable').DataTable();	//jquery dataTable Plugin reload		--> Span으로 인해 처리 안됨
				feather.replace();	//data-feather reload
				$("#modelid").val(modelid);
				
				/******** dataTable Area Setting End *********/
				
			}	//success
			
		});	//ajax
		
	});	//document.on click
	
	
	/**
		.선택한 금형의 가공공정 계획수립 화면에서 뒤로가기 버튼 클릭
	*/
	$(document).on("click", "#btn_back", function() {
		$("#subtitle").empty();
		$("#modelid").val('');
		$("#btn_search").trigger("click");
	});
	
	
	$(document).on("click", "td[id$='_start']", function() {
		
		var modelid = $("#modelid").val();
		var workid = this.id.replace("_start", "");
		var partgroupid = $("#"+workid+"_partgroupid").val();
		var workuser = $("#"+workid+"_workuser").val();
		var actiontype = "START";
		
		if(workuser == "") {
			alert("<spring:message code="smart.work.out.user.select.valid" />");
			return;
		}
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/work/SmartOutWorkSave.do",
			data : {"actiontype":actiontype, "modelid":modelid, "partgroupid":partgroupid, "workid":workid, "workuser":workuser},
			type : "POST",
			datatype : "text",
			success : function(data) {
				
				if(data == "OK") {
					setWorkData();
				} else if(data.indexOf("ERROR") > -1) {
					alert("<spring:message code="smart.common.save.error" /> :: " + data);
				}
				
			}	//success
			
			
		});	//ajax
		
	});	//_start click
	
	/**
		.작업완료 버튼 클릭
	*/
	$(document).on("click", "td[id$='_end']", function() {

		var modelid = $("#modelid").val();
		var workid = this.id.replace("_end", "");
		var partgroupid = $("#"+workid+"_partgroupid").val();
		var actiontype = "END";
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/work/SmartOutWorkSave.do",
			data : {"actiontype":actiontype, "modelid":modelid, "partgroupid":partgroupid, "workid":workid, },
			type : "POST",
			datatype : "text",
			success : function(data) {
				
				if(data == "OK") {
					setWorkData();
				} else if(data.indexOf("ERROR") > -1) {
					alert("<spring:message code="smart.common.save.error" /> :: " + data);
				}
				
			}	//success
			
			
		});	//ajax
		
	});	//_end click
	
	
	/**
		. 외주가공비 저장 Button Click
	*/
	$(document).on("click", "div[id$='_pricesave']", function() {
		
		var modelid = $("#modelid").val();
		var workid = this.id.replace("_pricesave", "");
		var partgroupid = $("#"+workid+"_partgroupid").val();
		var price = $("#"+workid+"_price").val();
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/work/SmartOutWorkPriceSave.do",
			data : {"price":price, "modelid":modelid, "partgroupid":partgroupid, "workid":workid, },
			type : "POST",
			datatype : "text",
			success : function(data) {
				
				if(data == "OK") {
					alert("<spring:message code="smart.common.save.ok" />");
				} else if(data.indexOf("ERROR") > -1) {
					alert("<spring:message code="smart.common.save.error" /> :: " + data);
				}
				
			}	//success
			
		});	//ajax	
		
	});	//pricesave click
	
	
	$('#modifyWorkTimeLayer').on('shown.bs.modal', function () {
		alert("shown modal");
	});

	$('#modifyWorkTimeLayer').on('hide.bs.modal', function () {
		alert("hide modal");
		$("#modifyWorkTimeLayerTitle").empty();
		$("#modify_gubun").val("");
		$("#modify_workid").val("");
		$("#modify_worktime").val("");
		$("#singleDateDivmodify_worktime span").html("");
		$("#modify_hour").val("00");
		
	});
	
	/**
		.작업시간 수정 Modal Open
		.attribute
			name : worktime_edit
			gubun : start / end
			workid : WORK_ID
		.parameter
	*/
	$(document).on("click", "td[name=worktime_edit]", function() {

		const gubun = $(this).attr("gubun");
		const workid = $(this).attr("workid");
		const worktime = $(this).attr("worktime");
		const workhour = $(this).attr("workhour");
		let title = "";
		
		if(gubun == "start") {
			title = "<spring:message code="smart.work.starttime.modify" />";
		} else {
			title = "<spring:message code="smart.work.endtime.modify" />";
		}
		
		$('#modifyWorkTimeLayer').modal("show");
		
		$("#modify_workid").val(workid);
		$("#modify_gubun").val(gubun);
		//작업시간 입력
		$("#modifyWorkTimeLayerTitle").empty();
		$("#modifyWorkTimeLayerTitle").append(title);
		$("#modify_worktime").val(worktime);
		$("#singleDateDivmodify_worktime span").html(worktime);
		$("#modify_hour").val(workhour);
		//달력 셋팅
		setSingleDateField("singleDateDivmodify_worktime", worktime);
		
	});
	
	/**
		.작업시간 수정 Action
		.parameter
			workid, worktime, workhour
	*/
	$(document).on("click", "#btn_modify", function() {
		
		const modifyGubun = $("#modify_gubun").val();
		const modifyWorkid = $("#modify_workid").val();
		const modifyWorkTime = $("#modify_worktime").val();
		const modifyWorkHour = $("#modify_hour").val();
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/work/SmartSiteWorkTimeSave.do",
			data : {"workid":modifyWorkid, "worktime":modifyWorkTime, "workhour":modifyWorkHour, "gubun":modifyGubun},
			type : "POST",
			datatype : "text",
			success : function(data) {
				if(data == "OK") {
					alert("<spring:message code="smart.common.save.ok" />");
					setWorkData();
				} else if(data.indexOf("ERROR") > -1) {
					alert("<spring:message code="smart.common.save.error" /> :: " + data);
				}
			},
			complete : function(data) {
				$('#modifyWorkTimeLayer').modal("hide");
			}
			
		});
		
	});
	
	
	function setWorkData() {
		
		var keys = userlist.keys();
		var modelid = $("#modelid").val();
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/work/SmartOutWorkData.do",
			data : {"modelid":modelid},
			type : "POST",
			datatype : "json",
			success : function(data) {
				
				/******** dataTable Area Setting Start *********/
				var partgroupid = "";
// 				$('#dataTable').dataTable().fnClearTable();
// 				$('#dataTable').dataTable().fnDestroy();
				$("#dataTable").empty();
				
				var strHtml = "";
				strHtml += "<colgroup>";
				strHtml += "	<col width='10%'>";
				strHtml += "	<col width='20%'>";
				strHtml += "	<col width='7%'>";
				strHtml += "	<col width='8%'>";
				strHtml += "	<col width='10%'>";
				strHtml += "	<col width='15%'>";
				strHtml += "	<col width='15%'>";
				strHtml += "	<col width='15%'>";
				strHtml += "</colgroup>";
				
				strHtml += "<thead>";
				strHtml += "	<tr>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupno" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupname" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupcount" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.process.procmanage" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.out.user" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.start.date" /><br>(<spring:message code="smart.work.plan.start.date" />)</th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.end.date" /><br>(<spring:message code="smart.work.plan.end.date" />)</th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.out.price" /></th>";
				strHtml += "	</tr>";
				strHtml += "</thead>";
				strHtml += "<tfoot>";
				strHtml += "	<tr>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupno" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupname" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupcount" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.process.procmanage" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.out.user" /></th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.start.date" /><br>(<spring:message code="smart.work.plan.start.date" />)</th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.end.date" /><br>(<spring:message code="smart.work.plan.end.date" />)</th>";
				strHtml += "		<th scope='col'><spring:message code="smart.work.out.price" /></th>";
				strHtml += "	</tr>";
				strHtml += "</tfoot>";
				strHtml += "<tbody id='data_table_tbody'>";

				$.each(data, function(index, value){
					strHtml += "	<tr>";
					if(partgroupid == "" || partgroupid != value.PART_GROUP_ID) {
						strHtml += "		<td rowspan='"+value.ROWCNT+"'>"+chkNull(value.PART_GROUP_NO);
						strHtml += "			<input type='hidden' name='"+value.WORK_ID+"_partgroupid' id='"+value.WORK_ID+"_partgroupid' value='"+value.PART_GROUP_ID+"'>";
						strHtml += "		</td>";
						strHtml += "		<td rowspan='"+value.ROWCNT+"'>"+chkNull(value.PART_GROUP_NAME)+"</td>";
						strHtml += "		<td rowspan='"+value.ROWCNT+"'>"+chkNull(value.PART_GROUP_COUNT)+"</td>";
					}
					strHtml += "		<td>"+chkNull(value.WORK_NAME)+"</td>";
// 					strHtml += "		<td>"+chkNull(value.WORK_USER_NM)+"</td>";
					strHtml += "		<td>";
					strHtml += "			<div class='form-group' style='margin-bottom: 0px;'>";
					strHtml += "				<select class='form-control form-control-solid' id='"+value.WORK_ID+"_workuser' name='"+value.WORK_ID+"_workuser'>";
					strHtml += "					<option value=''> - 선택 - </option>";
					for(var i=0; i<keys.length; i++) {
						if(userlist.get(keys[i]) == value.WORK_USER_NM) {
							strHtml += "			<option value='"+keys[i]+"' selected>"+userlist.get(keys[i])+"</option>";
						} else {
							strHtml += "			<option value='"+keys[i]+"'>"+userlist.get(keys[i])+"</option>";
						}
					}
					strHtml += "				</select>";
					strHtml += "			</div>";
					strHtml += "		</td>";
					
					if(value.WORK_START_DATE == null) {
						if(value.PLAN_START_DELAY == "DELAY") {
							strHtml += "		<td class='bg-yellow text-red font-weight-700 rounded-lg start-work' id='"+value.WORK_ID+"_start'>";
							strHtml += "			<i data-feather='mouse-pointer'></i>(Click 작업시작!)<br>("+chkNull(value.PLAN_START_DATE)+")";
							strHtml += "		</td>";
						} else {
							strHtml += "		<td class='bg-teal text-white rounded-lg start-work' id='"+value.WORK_ID+"_start'>";
							strHtml += "			<i data-feather='mouse-pointer'></i>(Click 작업시작!)<br>("+chkNull(value.PLAN_START_DATE)+")";
							strHtml += "		</td>";
						}
					} else {
						strHtml += "		<td class='end-work' name='worktime_edit' gubun='start' workid='"+value.WORK_ID+"' worktime='"+value.WORK_START_DATE+"' workhour='"+value.WORK_START_HOUR+"'>"+chkNull(value.WORK_START_DATE)+" " + chkNull(value.WORK_START_HOUR)+ "시 <i data-feather='edit'></i><br>("+chkNull(value.PLAN_START_DATE)+")</td>";
					}
						
					if(value.WORK_START_DATE != null && value.WORK_END_DATE == null) {
						if(value.PLAN_END_DELAY == "DELAY") {
							strHtml += "		<td class='bg-yellow text-red font-weight-700 rounded-lg start-work' id='"+value.WORK_ID+"_end'><i data-feather='mouse-pointer'></i>(Click 작업완료!)<br>("+chkNull(value.PLAN_END_DATE)+")</td>";
						} else {
							strHtml += "		<td class='bg-teal text-white rounded-lg start-work' id='"+value.WORK_ID+"_end'><i data-feather='mouse-pointer'></i>(Click 작업완료!)<br>("+chkNull(value.PLAN_END_DATE)+")</td>";
						}
					} else {
						strHtml += "		<td class='end-work' name='worktime_edit' gubun='end' workid='"+value.WORK_ID+"' worktime='"+value.WORK_END_DATE+"' workhour='"+value.WORK_END_HOUR+"'>"+chkNull(value.WORK_END_DATE)+" " + chkNull(value.WORK_END_HOUR)+ "시 <i data-feather='edit'></i><br>("+chkNull(value.PLAN_END_DATE)+")</td>";
					}
					strHtml += "		<td>";
					strHtml += "			<input class='form-control' id='"+value.WORK_ID+"_price' name='"+value.WORK_ID+"_price' style='width:70%;display:inherit;' value='"+chkNull(value.OUT_PRICE)+"' onkeyup='onlyNum(this);this.value=this.value.comma();'>";
					strHtml += "			&nbsp;";
					strHtml += "			<div class='btn btn-outline-teal btn-sm' id='"+value.WORK_ID+"_pricesave'><spring:message code="smart.common.button.save" /></div>";
					strHtml += "		</td>";
					strHtml += "	</tr>";
					
					partgroupid = value.PART_GROUP_ID;
				});	//$.each
				
				strHtml += "</tbody>";
				
				$("#dataTable").html(strHtml);
				
// 				$('#dataTable').DataTable();	//jquery dataTable Plugin reload		--> Span으로 인해 처리 안됨
				feather.replace();	//data-feather reload
				
				/******** dataTable Area Setting End *********/
				
			}	//success
			
		});	//ajax
		
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
										<span><spring:message code="smart.work.out.title" /></span>
									</h1>
									<div class="page-header-subtitle">
										<span id="subtitle">
										</span>
									</div>
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
											</tr>
	                                    </tbody>
									</table>
									
									<!-- Modal -->
									<div class="modal fade" id="modifyWorkTimeLayer" tabindex="-1" role="dialog" aria-labelledby="modifyWorkTimeLayerTitle" aria-hidden="true">
									    <div class="modal-dialog modal-dialog-centered" role="document">
									        <div class="modal-content">
									            <div class="modal-header">
									                <h5 class="modal-title" id="modifyWorkTimeLayerTitle"></h5>
									                <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
									            </div>
									            <div class="modal-body">
									            	<input type="hidden" name="modify_workid" id="modify_workid">
									            	<input type="hidden" name="modify_gubun" id="modify_gubun">
									                <div class="row">
									                	<div class="col-3">
									                		작업시간 : 
									                	</div>
						                				<div class="col-5">
								                			<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivmodify_worktime">
															    <i class="mr-2 text-primary" data-feather="calendar"></i>
															    <span></span>
															    <input type="hidden" name="modify_duedate" id="modify_worktime">
															    <i class="ml-1" data-feather="chevron-down"></i>
															</div>
														</div>
														<div class="col-3 pr-0">
															<select class="form-control form-control-solid" id="modify_hour" name="modify_hour" style="height:auto;">
									    						<c:forEach var="hour" items="<%= arrHour%>" varStatus="status">
								    								<option value="${hour }">${hour }</option>
								    							</c:forEach>
								    						</select>
														</div>
														<div class="text-lg pt-2">
															시
														</div>
													</div>
									            </div>
									            <div class="modal-footer">
									            	<div class="btn btn-success" id="btn_modify">수정</div>
									            	<div class="btn btn-secondary" data-dismiss="modal">닫기</div>
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