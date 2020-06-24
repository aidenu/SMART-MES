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
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
	
	<c:choose>
		<c:when test="${fn:length(result) > 0}">
		
			google.charts.load('current', {'packages':['timeline']});
			
			google.charts.setOnLoadCallback(drawChart);
			
			function drawChart()
			{
				var container = parent.document.getElementById('timeline');
				var chart = new google.visualization.Timeline(container);
				var dataTable = new google.visualization.DataTable();
			
				dataTable.addColumn({ type: 'string', id: 'EQP' });
				dataTable.addColumn({ type: 'string', id: 'Color' });
				dataTable.addColumn({ type: 'string', role: 'style' });
				dataTable.addColumn({ type: 'datetime', id: 'Start' });
				dataTable.addColumn({ type: 'datetime', id: 'End' });
			  
			  
				dataTable.addRows([
					
					<c:forEach var="result" items="${result}" varStatus="status">
					
						<c:set var="barColor" scope="session" value=""/>
						
						<c:choose>
							<c:when test="${result.WORK_FLAG == 'GREEN'}">
								<c:set var="barColor" scope="session" value="#2f92e9"/>
							</c:when>
							<c:when test="${result.WORK_FLAG == 'AMBER'}">
								<c:set var="barColor" scope="session" value="#FFCC00"/>
							</c:when>
							<c:when test="${result.WORK_FLAG == 'RED'}">
								<c:set var="barColor" scope="session" value="#FF3300"/>
							</c:when>
							<c:when test="${result.WORK_FLAG == 'NORMAL'}">
								<c:set var="barColor" scope="session" value="#E5E6E7"/>
							</c:when>
						</c:choose>
						
						<c:choose>
							<c:when test="${status.last}">
								[ '${result.EQP_NAME}', '${result.WORK_FLAG}', '${barColor}', new Date(${result.START_YEAR},${result.START_MONTH},${result.START_DAY},${result.START_HOUR},${result.START_MIN},00), new Date(${result.END_YEAR},${result.END_MONTH},${result.END_DAY},${result.END_HOUR},${result.END_MIN},00)]
							</c:when>
							<c:otherwise>
								[ '${result.EQP_NAME}', '${result.WORK_FLAG}', '${barColor}', new Date(${result.START_YEAR},${result.START_MONTH},${result.START_DAY},${result.START_HOUR},${result.START_MIN},00), new Date(${result.END_YEAR},${result.END_MONTH},${result.END_DAY},${result.END_HOUR},${result.END_MIN},00)],
							</c:otherwise>
						</c:choose>
					</c:forEach>

				]);
						
			
				var options = {
										width: '100%',
										backgroundColor: '#2c3338',
										timeline: {
													rowLabelStyle: {color: '#FFF'},
													showBarLabels: false
												},
										hAxis: {
													minValue: new Date(${SEARCH_YEAR},${SEARCH_MONTH},${SEARCH_DAY},00,00,00),
													maxValue: new Date(${SEARCH_YEAR},${SEARCH_MONTH},${SEARCH_DAY},23,59,59)
												}
									};
				
				google.visualization.events.addListener(chart, 'select', function () {
						var selection = chart.getSelection();
						
						if (selection.length > 0) {
							parent.getDetail(dataTable.getValue(selection[0].row, 0));
						}
				});
				
			  
				chart.draw(dataTable, options);
			}
			
		</c:when>
		<c:otherwise>
		
			parent.document.getElementById('timeline').innerHTML = "<table width=100%><tr><td align='center' style='width:100%;height:500px' border=1><h1 style='color:#FFFFFF;'>조회 결과가 없습니다</h1></td></tr></table>";
			
		</c:otherwise>
	</c:choose>
	
	<c:if test="${fn:length(result) > 0}">
		parent.document.getElementById("gathering_time").innerHTML = "<h1><font color=white>${GATHERING_TIME} 에 취합된 데이터 입니다.</font></h1>";
	</c:if>
	
	
	parent.document.getElementById("progress_div").style.visibility = "hidden";
	
</script>