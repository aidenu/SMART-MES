<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<link href="<c:url value='/css/titlefix/defaultTheme.css'/>" rel="stylesheet" type="text/css" >
<link href="<c:url value='/css/titlefix/myTheme.css'/>" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script type="text/javascript" src="https://www.google.com/jsapi"/></script>
<script>
	
	google.load("visualization", "1.1", {packages:["corechart"]});
	
	google.setOnLoadCallback(drawChart);
	
	function drawChart() {
		var data = new google.visualization.DataTable();
		data.addColumn('string', '');
		<c:forEach var="result" items="${result}" varStatus="resultStatus">
			data.addColumn('number', '${result.EQP_NAME}');
		</c:forEach>
		
		data.addRows([
			<c:choose>
				<c:when test="${datetype == 'MONTH'}">
					<c:forEach var="listDate" items="${listTargetDate}" varStatus="statuslist">
						<c:set var="workTime">${listDate}</c:set>
						<c:choose>
							<c:when test="${statuslist.last}">
								["${listDate}",
								 	<c:forEach var="resultData" items="${result}" varStatus="statusresult">
								 		<c:choose>
								 			<c:when test="${statusresult.last}">
								 				${resultData[workTime]}
								 			</c:when>
								 			<c:otherwise>
								 				${resultData[workTime]},
								 			</c:otherwise>
								 		</c:choose>
								 	</c:forEach>
								]
							</c:when>
							<c:otherwise>
								["${listDate}",
									 <c:forEach var="resultData" items="${result}" varStatus="statusresult">
								 		<c:choose>
								 			<c:when test="${statusresult.last}">
								 				${resultData[workTime]}
								 			</c:when>
								 			<c:otherwise>
								 				${resultData[workTime]},
								 			</c:otherwise>
								 		</c:choose>
								 	</c:forEach>
								],
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<c:forEach var="listDate" items="${listTargetDate}" varStatus="statuslist">
						<c:set var="workTime">${listDate}</c:set>
						<c:choose>
							<c:when test="${statuslist.last}">
								["${listDate}",
									 <c:forEach var="resultData" items="${result}" varStatus="statusresult">
								 		<c:choose>
								 			<c:when test="${statusresult.last}">
								 				${resultData[workTime]}
								 			</c:when>
								 			<c:otherwise>
								 				${resultData[workTime]},
								 			</c:otherwise>
								 		</c:choose>
								 	</c:forEach>
								]
							</c:when>
							<c:otherwise>
								["${listDate}",
									 <c:forEach var="resultData" items="${result}" varStatus="statusresult">
								 		<c:choose>
								 			<c:when test="${statusresult.last}">
								 				${resultData[workTime]}
								 			</c:when>
								 			<c:otherwise>
								 				${resultData[workTime]},
								 			</c:otherwise>
								 		</c:choose>
								 	</c:forEach>
								],
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		]);  
        	 
		var options = {
			title: "<spring:message code="space.status.result.eqp.title" />",
		   	width: parent.div_width*0.9,
		   	height: parent.div_height,
		   	backgroundColor: {fill: "#2c3338"},
		   	legendTextStyle: { color: '#FFF' },
		   	titleTextStyle: { color: '#FFF' },
		   	chartArea : {left:100, top:100, right:100},
		   	curveType: 'none',
	       	legend: { position: 'bottom' },
	       	pointsVisible:true,
		   	vAxis: {title: '%',titleTextStyle:{color:'#FFF'},textStyle:{color:'#FFF'},maxValue:100,minValue:0},
		   	hAxis: {title: '<spring:message code="space.status.chart.eqp.ration.hAxis" />',titleTextStyle:{fontSize:15, color:'#FFF'},textStyle:{color:'#FFF'}}
		};
		 
		var chart = new google.visualization.LineChart(parent.document.getElementById("myChart"));
		chart.draw(data, options);
		
		var columns = [];
		var series = {};
   		for (var i = 0; i < data.getNumberOfColumns(); i++) {
       		columns.push(i);
      		if (i > 0) {
           	series[i - 1] = {};
       		}
   		}
   		
   		google.visualization.events.addListener(chart, 'select', function () {
   	        var sel = chart.getSelection();
   	        
   	        // if selection length is 0, we deselected an element
   	        if (sel.length > 0) {
   	            // if row is object, we clicked on the legend
   	            if (typeof sel[0].row === 'object') {
   	                var col = sel[0].column;
   	                if (columns[col] == col) {
   	                    // hide the data series
   	                    columns[col] = {
   	                        label: data.getColumnLabel(col),
   	                        type: data.getColumnType(col),
   	                        calc: function () {
   	                            return null;
   	                        }
   	                    };
   	                    
   	                    // grey out the legend entry
   	                    series[col - 1].color = '#CCCCCC';
   	                }
   	                else {
   	                    // show the data series
   	                    columns[col] = col;
   	                    series[col - 1].color = null;
   	                }
   	                var view = new google.visualization.DataView(data);
   	                view.setColumns(columns);
   	                chart.draw(view, options);
   	            }
   	        }
   	    });
	}
	
	
	
	var strHtml = new StringBuffer();
	var strHtml2 = new StringBuffer();
	
	strHtml.append("<table style='order-collapse:collapse;text-align:left;line-height:1.5;margin :20px 10px;border:1px solid #FFF;'>");
	strHtml.append("		<tr>");
	strHtml.append("			<th style='width: 200px;padding: 10px;font-weight: bold;vertical-align: top;color: #FFFFFF;font-size:30px;'><spring:message code="space.status.chart.eqp.ration.total.ratio" /></td>");
	strHtml.append("			<td style='width: 270px;padding: 10px;vertical-align: top;font-size:30px;'><font color='#FFFFFF'>${TOT_RATIO}%</font></td>");
	strHtml.append("		</tr>");
	strHtml.append("		<tr>");
	strHtml.append("			<th style='width: 200px;padding: 10px;font-weight: bold;vertical-align: top;color: #FFFFFF;font-size:30px;'><spring:message code="space.status.chart.eqp.ration.untotal.ratio" /></td>");
	strHtml.append("			<td style='width: 270px;padding: 10px;vertical-align: top;font-size:30px;'><font color='#FFFFFF'>${UNTOT_RATIO}%</font></td>");
	strHtml.append("		</tr>");
	strHtml.append("</table>");
	
	strHtml2.append("<table style='order-collapse:collapse;text-align:left;line-height:1.5;margin :20px 10px;border:1px solid #FFF;'>");
	strHtml2.append("	<thead>");
	strHtml2.append("		<tr>");
	strHtml2.append("			<th style='padding: 10px;font-weight: bold;vertical-align: top;color: #B9E4FF;font-size:30px;'><spring:message code="space.status.status.eqp.part" /></th>");
	strHtml2.append("			<th style='padding: 10px;font-weight: bold;vertical-align: top;color: #B9E4FF;font-size:30px;'><spring:message code="space.status.chart.eqp.ration.machine" /></th>");
	strHtml2.append("			<th style='padding: 10px;font-weight: bold;vertical-align: top;color: #B9E4FF;font-size:30px;'><spring:message code="space.status.chart.eqp.ration.ratio" /></th>");
	strHtml2.append("		</tr>");
	strHtml2.append("	</thead>");
	strHtml2.append("	<tbody>");
	<c:forEach var="result" items="${result}" varStatus="resultStatus">
	strHtml2.append("		<tr>");
	strHtml2.append("			<th style='width: 150px;padding: 10px;font-weight: bold;vertical-align: top;color: #FFFFFF;font-size:20px;'>${result.EQP_PART}</th>");
	strHtml2.append("			<th style='width: 150px;padding: 10px;font-weight: bold;vertical-align: top;color: #FFFFFF;font-size:20px;'>${result.EQP_NAME}</th>");
	strHtml2.append("			<td style='width: 150px;padding: 10px;vertical-align: top;font-size:20px;'><font color='#FFFFFF'>${result.SUM_RATIO}%</font></td>");
	strHtml2.append("		</tr>");
	</c:forEach>
	strHtml2.append("	</tbody>");
	strHtml2.append("</table>");
	

	parent.jq$("#allStatus").empty();
	parent.jq$("#machineStatus").empty();
	parent.jq$("#allStatus").append(strHtml.toString());
	parent.jq$("#machineStatus").append(strHtml2.toString());
	
	
	parent.document.getElementById("progress_div").style.visibility = "hidden";
	
</script>