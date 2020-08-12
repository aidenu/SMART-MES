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
<title><spring:message code="smart.assembly.work.title" /></title>
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
		
		//Close Button Click
		$("#btn_close").click(function() {
			self.close();
		});
		
		/**
			. 조립 작업 시작 Button Click
			. parameter
			  - modelid
		*/
		$("#btn_start").click(function() {
			
			var modelid = $("#modelid").val();
			var actiontype = "START";
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/assembly/SmartAssemblyWorkSave.do",
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
			. 조립 작업 완료 Button Click
			. parameter
			  - modelid
		*/
		$("#btn_end").click(function() {
			
			var modelid = $("#modelid").val();
			var actiontype = "END";
			
			$.ajax({
				
				url : "${pageContext.request.contextPath}/smart/assembly/SmartAssemblyWorkSave.do",
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
				url : "${pageContext.request.contextPath}/smart/assembly/SmartAssemblyWorkChange.do",
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
				    		<div class="btn btn-outline-teal btn-sm" id="btn_start"><spring:message code="smart.assembly.work.start" /></div>
			    			<div class="btn btn-light btn-sm line-height-normal p-2 singleDatePicker" id="singleDateDivstartdate">
							    <i class="mr-2 text-primary" data-feather="calendar"></i>
							    <span></span>
							    <input type="hidden" name="startdate" id="startdate">
							    <i class="ml-1" data-feather="chevron-down"></i>
							</div>
					    	&nbsp;
					    	~
					    	&nbsp;
				    		<div class="btn btn-outline-teal btn-sm" id="btn_end"><spring:message code="smart.assembly.work.end" /></div>
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
					    				<th style="width:15%;"><spring:message code="smart.assembly.part.status" /></th>
					    				<th style="width:10%;"><spring:message code="smart.cad.partlist.regdate" /></th>
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
					    				<th><spring:message code="smart.assembly.part.status" /></th>
					    				<th><spring:message code="smart.cad.partlist.regdate" /></th>
					    			</tr>
					    		</tfoot>
					    		<tbody id="data_table_tbody">
					    			<c:forEach var="result" items="${result }" varStatus="status">
					    				<tr>
						    				<td>${result.PART_GROUP_NO }</td>
						    				<td>${result.PART_GROUP_NAME }</td>
						    				<td>${result.PART_GROUP_SIZE }</td>
						    				<td>${result.PART_GROUP_MATERIAL }</td>
						    				<td>${result.PART_GROUP_COUNT }</td>
						    				<td>	${result.PART_GROUP_GUBUN }</td>
						    				<c:choose>
						    					<c:when test="${result.STATUS == 'COMPLETE' }">
						    						<td class="bg-teal text-white">	${result.PART_STATUS }</td>
						    					</c:when>
						    					<c:when test="${result.STATUS == 'ING' }">
						    						<td class="bg-yellow text-white">	${result.PART_STATUS }</td>
						    					</c:when>
						    					<c:otherwise>
						    						<td>	${result.PART_STATUS }</td>
						    					</c:otherwise>
						    				</c:choose>
						    				<td>${result.REG_DATE }</td>
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
			<c:when test="${ASSEMBLY_START_DATE eq null }">
				$("#btn_start").css("display", "");
				$("#singleDateDivstartdate").css("display", "none");
				$("#btn_worksave").css("display", "none");
			</c:when>
			<c:otherwise>
				$("#btn_start").css("display", "none");
				$("#singleDateDivstartdate span").html("${ASSEMBLY_START_DATE}");
				$("#singleDateDivstartdate").css("display", "");
				$("#startdate").val("${ASSEMBLY_START_DATE}");
				$("#btn_worksave").css("display", "none");
			</c:otherwise>
		</c:choose>
		
		
		<c:choose>
			<c:when test="${ASSEMBLY_END_DATE eq null }">
				$("#btn_end").css("display", "");
				$("#singleDateDivenddate").css("display", "none");
				$("#btn_worksave").css("display", "none");
			</c:when>
			<c:otherwise>
				$("#btn_end").css("display", "none");
				$("#singleDateDivenddate span").html("${ASSEMBLY_END_DATE}");
				$("#singleDateDivenddate").css("display", "");
				$("#enddate").val("${ASSEMBLY_END_DATE}");
				$("#btn_worksave").css("display", "");
			</c:otherwise>
		</c:choose>
	});
</script>

<iframe name="hiddenFrame" width="0" height="0" style="visibility:hidden"></iframe>
</body>
</html>