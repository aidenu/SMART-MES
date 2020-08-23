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
<title><spring:message code="smart.process.procmanage.title" /></title>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value='/assets/img/favicon.png'/>">
<link rel="stylesheet" href="<c:url value='/css/smart/smartstyles.css'/>">
<link href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" rel="stylesheet" crossorigin="anonymous" />
<link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
<link rel="stylesheet" href="<c:url value='/css/smart/frappe-gantt.css'/>" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-3.5.1.min.js"/>"/></script>
<script data-search-pseudo-elements defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js" crossorigin="anonymous"></script>
<script src="<c:url value='/js/smart/frappe-gantt.js'/>"></script>
<script src="<c:url value='/js/smart/smartutil.js'/>"></script>
<style>

	#dataTable thead,
	#dataTable tfoot {
	  color: #0061f2;
	  text-align: center;
	}
	
	#addProcLayer {
		display: none;
		position: absolute;
		width: 500px;
	}
	
	div[class^='gantt_'] {
		width: 100%;
		display: grid;
	}
</style>
<script>
	
	var worklist = new Map();
	
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
				url : "${pageContext.request.contextPath}/smart/process/SmartProcManageData.do",
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
						
						if(value.CURRENT_STATUS == "DELAY") {
							strHtml += "	<tr class='bg-orange text-white'>";
						} else if(value.CURRENT_STATUS == "COMPLETE") {
							strHtml += "	<tr class='bg-blue text-white'>";
						} else {
							strHtml += "	<tr>";
						}
						strHtml += "	<td>"+value.MODEL_NO+"</td>";
						strHtml += "	<td>"+value.PRODUCT_NO+"</td>";
						strHtml += "	<td>"+value.PRODUCT_NAME+"</td>";
						strHtml += "	<td>"+value.ORDER_DATE+"</td>";
						strHtml += "	<td>"+value.DUE_DATE+"</td>";
						strHtml += "	<td>";
						strHtml += "		<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+value.MODEL_ID+"_schedule' title='<spring:message code="smart.process.procmanage.schedule" />'>";
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
		
		
		/**
			. 각 금형의 부품별 세부 가공공정 수립
			. parameter
			  - modelid
		*/
		$(document).on("click", "div[id$='_schedule']", function() {
			var modelid = this.id.replace("_schedule", "");
			var modelno = $("#"+modelid+"_modelno").val();
			
			$.ajax({
				url : "${pageContext.request.contextPath}/smart/process/SmartProcManageSched.do",
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
					$('#dataTable').dataTable().fnClearTable();
					$('#dataTable').dataTable().fnDestroy();
					$("#dataTable").empty();
					var strHtml = "";
					
					strHtml += "<colgroup>";
					strHtml += "	<col width='10%'>";
					strHtml += "	<col width='15%'>";
					strHtml += "	<col width='5%'>";
					strHtml += "	<col>";
					strHtml += "	<col width='5%'>";
					strHtml += "</colgroup>";
					
					strHtml += "<thead>";
					strHtml += "	<tr>";
					strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupno" /></th>";
					strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupname" /></th>";
					strHtml += "		<th scope='col'><spring:message code="smart.cad.partlist.partgroupcount" /></th>";
					strHtml += "		<th scope='col'><spring:message code="smart.process.procmanage.schedule" /></th>";
					strHtml += "		<th scope='col'>Detail</th>";
					strHtml += "	</tr>";
					strHtml += "</thead>";
					strHtml += "<tfoot>";
					strHtml += "	<tr>";
					strHtml += "		<th><spring:message code="smart.cad.partlist.partgroupno" /></th>";
					strHtml += "		<th><spring:message code="smart.cad.partlist.partgroupname" /></th>";
					strHtml += "		<th><spring:message code="smart.cad.partlist.partgroupcount" /></th>";
					strHtml += "		<th><spring:message code="smart.process.procmanage.schedule" /></th>";
					strHtml += "		<th>Detail</th>";
					strHtml += "	</tr>";
					strHtml += "</tfoot>";
					strHtml += "<tbody id='data_table_tbody'>";
					
					$.each(data, function(index, value){
						strHtml += "	<tr>";
						strHtml += "		<td>"+value.PART_GROUP_NO+"</td>";
						strHtml += "		<td>"+value.PART_GROUP_NAME+"</td>";
						strHtml += "		<td>"+value.PART_GROUP_COUNT+"</td>";
						strHtml += "		<td><div class='gantt_"+value.PART_GROUP_ID+"'></div></td>";
						strHtml += "		<td>";
						strHtml += "			<div class='btn btn-datatable btn-icon btn-transparent-dark mr-2' id='"+value.PART_GROUP_ID+"_add' title='<spring:message code="smart.process.procmanage.schedule.add" />'>";
						strHtml += "				<input type='hidden' id='"+value.PART_GROUP_ID+"_partgroupid' name='"+value.PART_GROUP_ID+"_partgroupid' value='"+value.PART_GROUP_ID+"'>";
						strHtml += "				<input type='hidden' id='"+value.PART_GROUP_ID+"_partgroupname' name='"+value.PART_GROUP_ID+"_partgroupname' value='"+value.PART_GROUP_NAME+"'>";
						strHtml += "				<i data-feather='plus-square'></i>";
						strHtml += "			</div>";
						strHtml += "		</td>";
						strHtml += "	</tr>";
					});	//$.each
					
					strHtml += "</tbody>";
					
					$("#dataTable").html(strHtml);
					
// 					$('#dataTable').DataTable();	//jquery dataTable Plugin reload
					feather.replace();	//data-feather reload
					/******** dataTable Area Setting End *********/
					
					//각 부품별 일정 데이터 호출
					$("#modelid").val(modelid);
					getPartSchedule();
					
				}	//success
			});
			
		});
		
		
		/**
			. 부품별 세부 가공공정 일정 조회
		*/
		function getPartSchedule() {
			
			var modelid = $("#modelid").val();
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSched.do",
				data : {"modelid":modelid, "partgroupid":"ALL"},
				type : "POST",
				datatype : "json",
				success : function(data) {
					
					var tasks = [];
					var partgroupid = "";
					worklist = new Map();
					
					$.each(data, function(index, value) {
						
						worklist.put(value.WORK_ID, value.PART_GROUP_ID);
						
						if(partgroupid != "" && partgroupid != value.PART_GROUP_ID) {

							var gantt_chart = new Gantt(".gantt_"+partgroupid, tasks, {
								 custom_popup_html: function(task, start, end) {
									// the task object will contain the updated
									// dates and progress value
									var temp_start_date = task._start;
									var temp_end_date = task._end;
									temp_end_date.setDate(temp_end_date.getDate()-1);
									var start_date = "";
									var end_date = "";
									var progressRate = "";
									var id = "";
									var divQuery = "";

									start_date = temp_start_date.getFullYear().toString().substr(-2) + "-" + ("00"+(temp_start_date.getMonth()+1)).slice(-2) + "-" + ("00"+temp_start_date.getDate()).slice(-2);
									end_date = temp_end_date.getFullYear().toString().substr(-2) + "-" + ("00"+(temp_end_date.getMonth()+1)).slice(-2) + "-" + ("00"+temp_end_date.getDate()).slice(-2);
									progressRate = task.progress;
									
									id = task.id;
									
									if(id != "0") {
										divQuery = "<div class='details-container' style='width:170px;text-align:center;'>"+
															"	<div class='title'>"+
															"		"+task.name+
															"	</div>"+
													        "   <div class='subtitle'>"+
													        "    	"+start_date+" ~ "+end_date+
													  		"        <br style='display:block;margin:10px;content:\"\";' >"+
													  		"        <div class='btn btn-outline-light btn-xs' id='"+id+"_del'>"+
													  		"			삭제"+
													  		"		</div>"+
													        "    </div>"+
															"</div>";
									} else {
										divQuery = "<div class='details-container' style='width:170px;text-align:center;'>"+
															"	<div class='title'>"+
															"		"+task.name+
															"	</div>"+
													        "   <div class='subtitle'>"+
													        "    	"+start_date+" ~ "+end_date+
													        "    </div>"+
															"</div>";
									}
									
									return divQuery;
								},
								on_date_change: function(task, start, end) {
									var workid = task.id;
									var start_date = start.getFullYear().toString() + "-" + ("00"+(start.getMonth()+1)).slice(-2) + "-" + ("00"+start.getDate()).slice(-2);
									var end_date = end.getFullYear().toString() + "-" + ("00"+(end.getMonth()+1)).slice(-2) + "-" + ("00"+end.getDate()).slice(-2);
									$.ajax({
										
										url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSchedChg.do",
										type : "POST",
										data : {"workid":workid, "startdate":start_date, "enddate":end_date},
										datatype : "text",
										success : function(data) {
											if(data.indexOf("ERROR") > -1) {
												alert("<spring:message code="smart.common.save.error" /> :: " + data);
											}
										}
										
									});
								},
								view_mode: 'Day',
								language: 'kr'
							});
							
							tasks = [];
						}
						
						tasks.push({
							start: value.PLAN_START_DATE,
							end: value.PLAN_END_DATE,
							name: value.WORK_NAME,
							id: value.WORK_ID,
							dependencies : value.DEPEND_WORK,
							progress : 0
						});
						
						partgroupid = value.PART_GROUP_ID;
						
					});	//each
					
					var gantt_chart = new Gantt(".gantt_"+partgroupid, tasks, {
						 custom_popup_html: function(task, start, end) {
							// the task object will contain the updated
							// dates and progress value
							var temp_start_date = task._start;
							var temp_end_date = task._end;
							temp_end_date.setDate(temp_end_date.getDate()-1);
							var start_date = "";
							var end_date = "";
							var progressRate = "";
							var id = "";
							var divQuery = "";

							start_date = temp_start_date.getFullYear().toString().substr(-2) + "-" + ("00"+(temp_start_date.getMonth()+1)).slice(-2) + "-" + ("00"+temp_start_date.getDate()).slice(-2);
							end_date = temp_end_date.getFullYear().toString().substr(-2) + "-" + ("00"+(temp_end_date.getMonth()+1)).slice(-2) + "-" + ("00"+temp_end_date.getDate()).slice(-2);
							progressRate = task.progress;
							
							id = task.id;
							
							if(id != "0") {
								divQuery = "<div class='details-container' style='width:170px;text-align:center;'>"+
													"	<div class='title'>"+
													"		"+task.name+
													"	</div>"+
											        "   <div class='subtitle'>"+
											        "    	"+start_date+" ~ "+end_date+
											  		"        <br style='display:block;margin:10px;content:\"\";' >"+
											  		"        <div class='btn btn-outline-light btn-xs' id='"+id+"_del'>"+
											  		"			삭제"+
											  		"		</div>"+
											        "    </div>"+
													"</div>";
							} else {
								divQuery = "<div class='details-container' style='width:170px;text-align:center;'>"+
													"	<div class='title'>"+
													"		"+task.name+
													"	</div>"+
											        "   <div class='subtitle'>"+
											        "    	"+start_date+" ~ "+end_date+
											        "    </div>"+
													"</div>";
							}
							
							return divQuery;
						},
						on_date_change: function(task, start, end) {
							var workid = task.id;
							var start_date = start.getFullYear().toString() + "-" + ("00"+(start.getMonth()+1)).slice(-2) + "-" + ("00"+start.getDate()).slice(-2);
							var end_date = end.getFullYear().toString() + "-" + ("00"+(end.getMonth()+1)).slice(-2) + "-" + ("00"+end.getDate()).slice(-2);
							$.ajax({
								
								url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSchedChg.do",
								type : "POST",
								data : {"workid":workid, "startdate":start_date, "enddate":end_date},
								datatype : "text",
								success : function(data) {
									if(data.indexOf("ERROR") > -1) {
										alert("<spring:message code="smart.common.save.error" /> :: " + data);
									}
								}
								
							});
						},
						view_mode: 'Day',
						language: 'kr'
					});
					
				}	//success
				
			});
			
		}
		
		
		/**
		. Add Button Click
		. 일정 추가 Layer view
		*/
		$(document).on("click", "div[id$='_add']", function() {
			
			$("#addProcLayer").css({
				"top": (($(window).height()-$("#addProcLayer").outerHeight())/2+$(window).scrollTop())+"px",
				"left": (($(window).width()-$("#addProcLayer").outerWidth())/2+$(window).scrollLeft())+"px"
			});
			
			$("#addProcLayer").show();
			$("#addProcName").focus();
			
			var partgroupid = this.id.replace("_add", "");
			var partgroupname = $("#"+partgroupid+"_partgroupname").val();
			$("#addPartgroupname").html(partgroupname);
			$("#addPartgroupid").val(partgroupid);
		});
		
		
		/**
			.Layer Insert Button Click
			. 일정 추가
			. parameter
			  - modelid, partgroupid, addProcName(workname), startdate, enddate
		*/
		$("#addProcLayerInsert").click(function() {
			
			var modelid = $("#modelid").val();
			var partgroupid = $("#addPartgroupid").val();
			var workname = $("#addProcName").val();
			var workgubun = $("#addWorkGubun").val();
			var startdate = $("#startdate").val();
			var enddate = $("#enddate").val();
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSchedAdd.do",
				data : {"modelid":modelid, "partgroupid":partgroupid, "workname":workname, "workgubun":workgubun,
						"startdate":startdate, "enddate":enddate},
				type : "POST",
				datatype : "text",
				success : function(data) {
					
					if(data == "OK") {
						alert("<spring:message code="smart.process.procmanage.partschedule.add.ok" />");
						$("#addProcLayerClose").trigger("click");
						
						$.ajax({
							url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSched.do",
							data : {"modelid":modelid, "partgroupid":partgroupid},
							type : "POST",
							datatype : "json",
							success : function(data) {
								var tasks = [];
								worklist = new Map();
								
								$.each(data, function(index, value) {
									worklist.put(value.WORK_ID, value.PART_GROUP_ID);
									
									tasks.push({
										start: value.PLAN_START_DATE,
										end: value.PLAN_END_DATE,
										name: value.WORK_NAME,
										id: value.WORK_ID,
										dependencies : value.DEPEND_WORK,
										progress : 0
									});
									
								});	//each
								
								var gantt_chart = new Gantt(".gantt_"+partgroupid, tasks, {
									 custom_popup_html: function(task, start, end) {
										// the task object will contain the updated
										// dates and progress value
										var temp_start_date = task._start;
										var temp_end_date = task._end;
										temp_end_date.setDate(temp_end_date.getDate()-1);
										var start_date = "";
										var end_date = "";
										var progressRate = "";
										var id = "";
										var divQuery = "";

										start_date = temp_start_date.getFullYear().toString().substr(-2) + "-" + ("00"+(temp_start_date.getMonth()+1)).slice(-2) + "-" + ("00"+temp_start_date.getDate()).slice(-2);
										end_date = temp_end_date.getFullYear().toString().substr(-2) + "-" + ("00"+(temp_end_date.getMonth()+1)).slice(-2) + "-" + ("00"+temp_end_date.getDate()).slice(-2);
										progressRate = task.progress;
										
										id = task.id;
										
										divQuery = "<div class='details-container' style='width:170px;text-align:center;'>"+
													"	<div class='title'>"+
													"		"+task.name+
													"	</div>"+
											        "   <div class='subtitle'>"+
											        "    	"+start_date+" ~ "+end_date+
											  		"        <br style='display:block;margin:10px;content:\"\";' >"+
											  		"        <div class='btn btn-outline-light btn-xs' id='"+id+"_del'>"+
											  		"			삭제"+
											  		"		</div>"+
											        "    </div>"+
													"</div>";
										
										return divQuery;
									},
									on_date_change: function(task, start, end) {
										var workid = task.id;
										var start_date = start.getFullYear().toString() + "-" + ("00"+(start.getMonth()+1)).slice(-2) + "-" + ("00"+start.getDate()).slice(-2);
										var end_date = end.getFullYear().toString() + "-" + ("00"+(end.getMonth()+1)).slice(-2) + "-" + ("00"+end.getDate()).slice(-2);
										$.ajax({
											
											url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSchedChg.do",
											type : "POST",
											data : {"workid":workid, "startdate":start_date, "enddate":end_date},
											datatype : "text",
											success : function(data) {
												if(data.indexOf("ERROR") > -1) {
													alert("<spring:message code="smart.common.save.error" /> :: " + data);
												}
											}
											
										});
									},
									view_mode: 'Day',
									language: 'kr'
								});
								
							}	//success
						});	//ajax
						
						
					} else if(data.indexOf("ERROR") > -1){
						alert("<spring:message code="smart.process.procmanage.partschedule.add.error" /> ");
					}
					
				}	//success
				
			});	//ajax
			
		});
		
		
		/**
			. Part Schedule Task Delete Button Click
			. parameter
			  - modelid, partgroupid, workid
		*/
		$(document).on("click", "div[id$='_del']", function() {
			
			var msg = "<spring:message code="smart.process.procmanage.partschedule.del" />";
			var modelid = $("#modelid").val();
			var workid = this.id.replace("_del", "");
			var partgroupid = worklist.get(workid);
			
			if(confirm(msg)) {
				$.ajax({
					
					url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSchedDel.do",
					data : {"modelid":modelid, "partgroupid":partgroupid, "workid":workid},
					type : "POST",
					datatype : "text",
					success : function(data) {
						
						if(data == "OK") {
							alert("<spring:message code="smart.process.procmanage.partschedule.del.ok" />");
							$("#addProcLayerClose").trigger("click");
							
							$.ajax({
								url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSched.do",
								data : {"modelid":modelid, "partgroupid":partgroupid},
								type : "POST",
								datatype : "json",
								success : function(data) {
									var tasks = [];
									worklist = new Map();
									
									$.each(data, function(index, value) {
										worklist.put(value.WORK_ID, value.PART_GROUP_ID);
										
										tasks.push({
											start: value.PLAN_START_DATE,
											end: value.PLAN_END_DATE,
											name: value.WORK_NAME,
											id: value.WORK_ID,
											dependencies : value.DEPEND_WORK,
											progress : 0
										});
										
									});	//each
									$(".gantt_"+partgroupid).empty();
									
									var gantt_chart = new Gantt(".gantt_"+partgroupid, tasks, {
										 custom_popup_html: function(task, start, end) {
											// the task object will contain the updated
											// dates and progress value
											var temp_start_date = task._start;
											var temp_end_date = task._end;
											temp_end_date.setDate(temp_end_date.getDate()-1);
											var start_date = "";
											var end_date = "";
											var progressRate = "";
											var id = "";
											var divQuery = "";

											start_date = temp_start_date.getFullYear().toString().substr(-2) + "-" + ("00"+(temp_start_date.getMonth()+1)).slice(-2) + "-" + ("00"+temp_start_date.getDate()).slice(-2);
											end_date = temp_end_date.getFullYear().toString().substr(-2) + "-" + ("00"+(temp_end_date.getMonth()+1)).slice(-2) + "-" + ("00"+temp_end_date.getDate()).slice(-2);
											progressRate = task.progress;
											
											id = task.id;
											
											divQuery = "<div class='details-container' style='width:170px;text-align:center;'>"+
														"	<div class='title'>"+
														"		"+task.name+
														"	</div>"+
												        "   <div class='subtitle'>"+
												        "    	"+start_date+" ~ "+end_date+
												  		"        <br style='display:block;margin:10px;content:\"\";' >"+
												  		"        <div class='btn btn-outline-light btn-xs' id='"+id+"_del'>"+
												  		"			삭제"+
												  		"		</div>"+
												        "    </div>"+
														"</div>";
											
											return divQuery;
										},
										on_date_change: function(task, start, end) {
											var workid = task.id;
											var start_date = start.getFullYear().toString() + "-" + ("00"+(start.getMonth()+1)).slice(-2) + "-" + ("00"+start.getDate()).slice(-2);
											var end_date = end.getFullYear().toString() + "-" + ("00"+(end.getMonth()+1)).slice(-2) + "-" + ("00"+end.getDate()).slice(-2);
											$.ajax({
												
												url : "${pageContext.request.contextPath}/smart/process/SmartProcManagePartSchedChg.do",
												type : "POST",
												data : {"workid":workid, "startdate":start_date, "enddate":end_date},
												datatype : "text",
												success : function(data) {
													if(data.indexOf("ERROR") > -1) {
														alert("<spring:message code="smart.common.save.error" /> :: " + data);
													}
												}
												
											});
										},
										view_mode: 'Day',
										language: 'kr'
									});
									
								}	//success
							});	//ajax
							
							
						} else if(data.indexOf("ERROR") > -1){
							alert("<spring:message code="smart.process.procmanage.partschedule.del.error" /> ");
						}
						
					}	//success
					
				});	//ajax
			}
			
		});
		
			
		/**
		. Layer Close Button Click
		. 일정 Layer hidden
		*/
		$("#addProcLayerClose").click(function() {
			
			$("#addProcName").val('');
			$("#addPartgroupid").val('');
			$("#addPartgroupname").val('');
			
			var date = new Date();
			var today = "";
			if(date.getMonth() < 10) {
				today = date.getFullYear() + "-" + "0" + (date.getMonth()+1) + "-" + date.getDate();
			} else {
				today = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate();
			}
			$("#singleDateDivstartdate span").html(today);
			$("#startdate").val(today);
			
			$("#singleDateDivenddate span").html(today);
			$("#enddate").val(today);
			
			$("#addProcLayer").hide();
		});
			
		/**
			.선택한 금형의 가공공정 계획수립 화면에서 뒤로가기 버튼 클릭
		*/
		$(document).on("click", "#btn_back", function() {
			$("#subtitle").empty();
			$("#modelid").val('');
			$("#btn_search").trigger("click");
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
										<span><spring:message code="smart.process.procmanage.title" /></span>
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
					<form name="dataForm" id="dataForm" method="post" enctype="multipart/form-data">
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
								</div>
							</div>
						</div>
					</form>
				</div>
				
				<!-- Schedule Add layer-->
				<div class="col-lg-6" id="addProcLayer">
					<div class="card bg-dark text-center pricing-detailed-behind">
						<div class="card-header justify-content-center py-4">
							<h5 class="mb-0 text-white"><span id="addPartgroupname"></span>&nbsp;<spring:message code="smart.process.procmanage.schedule.add" /></h5>
						</div>
						<div class="card-body text-white-50 p-5">
							<input type="hidden" id="addPartgroupid" name="addPartgroupid">
							<div class="form-group" style="margin-bottom: 0px;">
		    					<select class="form-control form-control-solid" id="addProcName" name="addProcName">
		    						<option value=""> -- 선택 -- </option>
		    						<c:forEach var="resultProc" items="${resultProc }" varStatus="procStatus">
		    							<c:if test="${resultProc.PROCESS_GUBUN == '가공' }">
		    								<option value="${resultProc.PROCESS_NAME }">${resultProc.PROCESS_NAME }</option>
		    							</c:if>
		    						</c:forEach>
	    						</select>
	    					</div>
<%-- 							<input class="form-control" id="addProcName" name="addProcName" placeholder="<spring:message code="smart.process.procmanage" />"> --%>
							&nbsp;
							<div class="form-group" style="margin-bottom: 0px;">
		    					<select class="form-control form-control-solid" id="addWorkGubun" name="addWorkGubun">
		    						<option value="SITE">사내가공</option>
		    						<option value="OUT">외주가공</option>
	    						</select>
	    					</div>
							<br>
							<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivstartdate">
							    <i class="mr-2 text-primary" data-feather="calendar"></i>
							    <span></span>
							    <input type="hidden" name="startdate" id="startdate">
							    <i class="ml-1" data-feather="chevron-down"></i>
							</div>
							~
							<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivenddate">
							    <i class="mr-2 text-primary" data-feather="calendar"></i>
							    <span></span>
							    <input type="hidden" name="enddate" id="enddate">
							    <i class="ml-1" data-feather="chevron-down"></i>
							</div>
						</div>
						<div class="card-footer bg-gray-800 text-white d-flex align-items-center justify-content-center">
							<div class="btn btn-outline-light" id="addProcLayerInsert"><spring:message code="smart.common.button.add" /></div>
							&nbsp;&nbsp;
							<div class="btn btn-outline-light" id="addProcLayerClose"><spring:message code="smart.common.button.close" /></div>
						</div>
					</div>
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
	});
</script>

</body>
</html>