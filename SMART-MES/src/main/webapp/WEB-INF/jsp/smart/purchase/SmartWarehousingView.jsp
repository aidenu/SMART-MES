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
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.caret.min.js"/>"/></script>

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
		
		
	});	//$(document).ready()
	
	
	/**
		. 저장 버튼 클릭
		. 구매비용 입력 후 저장
	*/
	$(document).on("click", "div[id$='_save']", function() {
		
		var modelid = $("#modelid").val();
		var strHtml = "";
		
		var rowcnt = $("#data_table_tbody tr").length;
		var title = "";
		for(var i=0; i<rowcnt; i++) {
			
			title = $("#data_table_tbody tr")[i].title;
			strHtml += $("#data_table_tbody tr")[i].title + "♬";
			strHtml += document.getElementById(title+"_orderprice").value + "♩";
			
		}	//for(var i=0; i<rowcnt; i++)
		
		strHtml = strHtml.substring(0, strHtml.length-1);
		
		$.ajax({
			
			url : "${pageContext.request.contextPath}/smart/purchase/SmartPurchaseDataSave.do",
			data : {"modelid":modelid, "arraystr":strHtml},
			type : "POST",
			datatype : "text",
			success : function(data) {
				
				if(data == "OK") {
					alert("<spring:message code="smart.common.save.ok" />");
				} else if(data.indexOf("ERROR")) {
					alert("<spring:message code="smart.common.save.error" /> :: " + data);
				}
				
			}	//success
			
		});	//ajax
		
		
	});	//_save Click
	
	
	
	/**
		. 발주 관련 Button Click
		. 발주, 입고, 발주취소, 입고취소
	*/
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
		console.log("modelid :: ", modelid);
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
								
								strHtml += "<tr title='"+value.PART_GROUP_ID+"'>";
								strHtml += "	<td>"+chkNull(value.PART_GROUP_NO)+"</td>";
								strHtml += "	<td>"+chkNull(value.PART_GROUP_NAME)+"</td>";
								strHtml += "	<td>"+chkNull(value.PART_GROUP_SIZE)+"</td>";
								strHtml += "	<td>"+chkNull(value.PART_GROUP_MATERIAL)+"</td>";
								strHtml += "	<td>"+chkNull(value.PART_GROUP_COUNT)+"</td>";
								strHtml += "	<td>";
								
								if(value.PART_GROUP_GUBUN == "<spring:message code="smart.common.process" />") {
									strHtml += "		<spring:message code="smart.common.process" />";
								} else {
									strHtml += "		<spring:message code="smart.common.purchase" />";
								}
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
// 									strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_orderCancelPurchase'><spring:message code="smart.common.order.cancel" /></div>";
// 									strHtml += " 		/ ";
									strHtml += "		<div class='btn btn-green btn-sm' id='"+value.PART_GROUP_ID+"_stockActionPurchase'><spring:message code="smart.common.stock" /></div>";
								} else if(value.ORDER_DATE != null && value.STOCK_DATE != null) {
									strHtml += "		"+value.ORDER_ORG+"";
									strHtml += "		<br>";
									strHtml += "		"+value.ORDER_DATE+" / "+value.STOCK_DATE+"";
									strHtml += "		<br>";
									strHtml += "		<div class='btn btn-orange btn-sm' id='"+value.PART_GROUP_ID+"_stockCancelPurchase'><spring:message code="smart.common.stock.cancel" /></div>";
								}
								strHtml += "	</td>";
								strHtml += "	<td>";
								strHtml += "		<input type='hidden' id='"+value.PART_GROUP_ID+"_partgroupid' name='"+value.PART_GROUP_ID+"_partgroupid' value='"+value.PART_GROUP_ID+"'>";
								strHtml += "		<input class='form-control XenoInputCursorMove' id='"+value.PART_GROUP_ID+"_orderprice' name='"+value.PART_GROUP_ID+"_orderprice' value='"+chkNull(value.ORDER_PRICE)+"' onkeyup='onlyNum(this);this.value=this.value.comma();'>";
								strHtml += "	</td>";
								strHtml += "	<td>"+value.REG_DATE+"</td>";
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
	
	
	/**
		. 구매비 셀 방향키 이동
		. 37 : <-
		. 38 : ↑
		. 39 : ->
		. 40 : ↓
	*/
	$(function() {
        $(':input.XenoInputCursorMove').on('keydown', XenoInputCursorMove);
    });
	function XenoInputCursorMove(event) {
		
		switch(event.which) {
        case 37: // left
            if(event.ctrlKey || $(this).caret().start == 0) {
                $(this).closest('td').prevAll('td:has(:input.XenoInputCursorMove):first').find(':input.XenoInputCursorMove:first').each(function() {
                    $(this).focus().caret(this.value.length);
                });
                return false;
            }
            break;
        case 39: // right
            if(event.ctrlKey || $(this).caret().start == this.value.length) {
                $(this).closest('td').nextAll('td:has(:input.XenoInputCursorMove):first').find(':input.XenoInputCursorMove:first').each(function() {
                    $(this).focus().caret(0);
                });
                return false;
            }
            break;
        case 38: // up
            var caret = $(this).caret().start;
            $(this).closest('td').each(function() {
                var $$ = $(this.parentNode).prev('tr');
                var focused = false;
                do {
                    $$.find('td:eq(' + this.cellIndex + ') :input.XenoInputCursorMove')
                        .focus().each(function() {
                            $(this).caret(caret);
                            focused = true;
                        });
                    $$ = $$.prev('tr');
                } while($$.length != 0 && !focused);
            });
            return false;
        case 40: // down
            var caret = $(this).caret().start;
            $(this).closest('td').each(function() {
                var $$ = $(this.parentNode).next('tr');
                var focused = false;
                do {
                    $$.find('td:eq(' + this.cellIndex + ') :input.XenoInputCursorMove')
                        .focus().each(function() {
                            $(this).caret(caret);
                            focused = true;
                        });
                    $$ = $$.next('tr');
                } while($$.length != 0 && !focused);
            });
            return false;
    	}
		
	}	//XenoInputCursorMove(event)
	
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
				    		<div class="btn btn-outline-teal btn-sm" id="btn_save"><spring:message code="smart.common.button.save" /></div>
				    		&nbsp;&nbsp;
					    	<div class="btn btn-primary btn-sm" id="btn_close"><spring:message code="smart.common.button.close" /></div>
				    	</div>
				    </div>
				    
				    <div class="card-body">
						<div class="datatable table-responsive">
							<table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
								<colgroup>
									<col width='6%'>
									<col>
									<col>
									<col>
									<col width='6%'>
									<col width='8%'>
									<col width='15%'>
									<col width='10%'>
									<col width='10%'>
								</colgroup>
					    		<thead>
					    			<tr>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupno" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupname" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupsize" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupmaterial" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupcount" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.partgroupgubun" /></th>
					    				<th scope="col"><spring:message code="smart.common.order" /></th>
					    				<th scope="col"><spring:message code="smart.purchase.order.price" /></th>
					    				<th scope="col"><spring:message code="smart.cad.partlist.regdate" /></th>
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
					    				<th><spring:message code="smart.purchase.order.price" /></th>
					    				<th><spring:message code="smart.cad.partlist.regdate" /></th>
					    			</tr>
					    		</tfoot>
					    		<tbody id="data_table_tbody">
					    			<c:forEach var="result" items="${result }" varStatus="status">
					    				<tr title="${result.PART_GROUP_ID }">
						    				<td>${result.PART_GROUP_NO }</td>
						    				<td>${result.PART_GROUP_NAME }</td>
						    				<td>${result.PART_GROUP_SIZE }</td>
						    				<td>${result.PART_GROUP_MATERIAL }</td>
						    				<td>${result.PART_GROUP_COUNT }</td>
						    				<td>
						    					<c:set var="process"><spring:message code="smart.common.process" /></c:set>
						    					<c:set var="purchase"><spring:message code="smart.common.purchase" /></c:set>
						    					<c:choose>
					    							<c:when test="${result.PART_GROUP_GUBUN == process}">
					    								<spring:message code="smart.common.process" />
					    							</c:when>
					    							<c:otherwise>
					    								<spring:message code="smart.common.purchase" />
					    							</c:otherwise>
					    						</c:choose>
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
<%-- 						    							<div class="btn btn-orange btn-sm" id="${result.PART_GROUP_ID }_orderCancelPurchase"><spring:message code="smart.common.order.cancel" /></div> /  --%>
						    							<div class="btn btn-green btn-sm" id="${result.PART_GROUP_ID }_stockActionPurchase"><spring:message code="smart.common.stock" /></div> 
						    						</c:when>
						    						<c:when test="${result.ORDER_DATE ne null && result.STOCK_DATE ne null }">
						    							${result.ORDER_ORG }<br>
						    							${result.ORDER_DATE } / ${result.STOCK_DATE }<br>
						    							<div class="btn btn-orange btn-sm" id="${result.PART_GROUP_ID }_stockCancelPurchase"><spring:message code="smart.common.stock.cancel" /></div>
						    						</c:when>
						    					</c:choose>
						    					
						    				</td>
						    				<td>
						    					<input type="hidden" id="${result.PART_GROUP_ID }_partgroupid" name="${result.PART_GROUP_ID }_partgroupid" value="${result.PART_GROUP_ID }">
						    					<input class="form-control XenoInputCursorMove" id="${result.PART_GROUP_ID}_orderprice" name="${result.PART_GROUP_ID }_orderprice" value="${result.ORDER_PRICE }" onkeyup="onlyNum(this);this.value=this.value.comma();">
						    				</td>
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

<iframe name="hiddenFrame" width="0" height="0" style="visibility:hidden"></iframe>
</body>
</html>