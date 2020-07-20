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
		
		
		
		$("#btn_add").click(function() {
			
			var addHtml = "";
			
			addHtml += "<tr id='"+addIdx+"'>";
			addHtml += "	<td><input class='form-control' id='partgroupno name='partgroupno''></td>";
			addHtml += "	<td><input class='form-control' id='partgroupname' name='partgroupname'></td>";
			addHtml += "	<td><input class='form-control' id='partgroupsize' name='partgroupsize'></td>";
			addHtml += "	<td><input class='form-control' id='partgroupmaterial' name='partgroupmaterial'></td>";
			addHtml += "	<td><input class='form-control' id='partgroupcount' name='partgroupcount' onkeyup='onlyNum(this);'></td>";
			addHtml += "	<td>";
			addHtml += "		<select class='form-control' id='partgroupsize'>";
			addHtml += "			<option value='<spring:message code="smart.common.process" />'><spring:message code="smart.common.process" /></option>";
			addHtml += "			<option value='<spring:message code="smart.common.purchase" />'><spring:message code="smart.common.purchase" /></option>";
			addHtml += "		</select>";
			addHtml += "	</td>";
			addHtml += "	<td></td>";
			addHtml += "	<td><div class='btn btn-green btn-sm' id='"+addIdx+"_add'><spring:message code="smart.common.button.add" /></div></td>";
			addHtml += "	<td>";
			addHtml += "		<div class='btn btn-yellow btn-sm' id='"+addIdx+"_cancel'><spring:message code="smart.common.button.cancel" /></div>";
			addHtml += "	</td>";
			addHtml += "</tr>";
			
			$("#data_table_tbody").append(addHtml);
			
			addIdx++;
		});
		
		//Close Button Click
		$("#btn_close").click(function() {
			self.close();
		});
		
	});
	
	//Cancel Button Click
	$(document).on("click", "div[id$='_cancel']", function() {
		
		var trid = this.id.replace("_cancel", "");
		$("#"+trid).remove();
		
	});

</script>
</head>
<body class="nav-fixed">

		
		<form name="dataForm" method="post" >
			<input type="hidden" name="modelid" id="modelid">
			<div class="card mb-4">
				<div class="card card-header-actions">
					 <div class="card-header">
				    	<spring:message code="smart.cad.partlist" />
				    	<div>
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
					    				<th style="width:6%;">품번</th>
					    				<th>품명</th>
					    				<th>사이즈</th>
					    				<th>재질</th>
					    				<th style="width:6%;">수량</th>
					    				<th style="width:9%;">구분</th>
					    				<th>발주</th>
					    				<th>등록일</th>
					    				<th style="width:6%;"></th>
					    			</tr>
					    		</thead>
					    		<tfoot>
					    			<tr>
					    				<th>품번</th>
					    				<th>품명</th>
					    				<th>사이즈</th>
					    				<th>재질</th>
					    				<th>수량</th>
					    				<th>구분</th>
					    				<th>발주</th>
					    				<th>등록일</th>
					    				<th></th>
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
						    				<td>${result.PART_GROUP_GUBUN }</td>
						    				<td>
						    					${result.ORDER_DATE }/${result.STOCK_DATE }
						    					<br>
						    					<button class="btn btn-success btn-sm" type="button">발주</button>
						    				</td>
						    				<td>${result.REG_DATE }</td>
						    				<td><div class="btn btn-red btn-sm" id="${result.PART_GROUP_ID }_delete"><spring:message code="smart.common.button.delete" /></div></td>
						    			</tr>
					    			</c:forEach>
					    			<tr>
					    				<td>001</td>
					    				<td>몰드베이스</td>
					    				<td>---</td>
					    				<td>-</td>
					    				<td>1</td>
					    				<td>가공</td>
					    				<td><button class="btn btn-success btn-sm" type="button">발주</button></td>
					    				<td>2020-01-03</td>
					    				<td><div class="btn btn-red btn-sm" id="123_delete"><spring:message code="smart.common.button.delete" /></div></td>
					    			</tr>
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

<iframe name="hiddenFrame" width="0" height="0" style="visibility:hidden"></iframe>
</body>
</html>