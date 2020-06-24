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
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
	
<c:choose>
	<c:when test="${fn:length(result) > 0}">

		google.charts.load("current", {packages: ['corechart', 'bar']});
		google.charts.setOnLoadCallback(drawChart);
		
		function drawChart() {
			var data = google.visualization.arrayToDataTable([
				['설비명', 'GREEN', {role: 'style'}, 'AMBER', {role: 'style'}, 'RED', {role: 'style'}, 'NORMAL', {role: 'style'}],
				<c:forEach var="result" items="${result}" varStatus="status">
					<c:choose>
						<c:when test="${status.last}">
							["${result.EQP_NAME}", Number("${result.GREEN_RATE}"), '#2f92e9', Number("${result.AMBER_RATE}"), '#FFCC00', Number("${result.RED_RATE}"), '#FF3300', Number("${result.NORMAL_RATE}"), '#E5E6E7']
						</c:when>
						<c:otherwise>
							["${result.EQP_NAME}", Number("${result.GREEN_RATE}"), '#2f92e9', Number("${result.AMBER_RATE}"), '#FFCC00', Number("${result.RED_RATE}"), '#FF3300', Number("${result.NORMAL_RATE}"), '#E5E6E7'],
						</c:otherwise>
					</c:choose>
				
				</c:forEach>

			]);
			
			var options = {
				chartArea: {width: '80%'},
				width: parent.div_width * 0.8,
			   	height: parent.div_height * 0.8,
				backgroundColor: {fill: "#2c3338"},
				legendTextStyle: {color: '#FFF' },
				isStacked: true,
				series: {
					0: {color: '#2f92e9'},
					1: {color: '#FFCC00'},
					2: {color: '#FF3300'},
					3: {color: '#E5E6E7'}
				},
				tooltip: {
					textStyle: {color: '#FFF'},
					isHtml: true
				},
				hAxis: {
					title: '설비명',
					titleTextStyle: {color: '#FFF'},
					textStyle:{color: '#FFF'}
				},
				vAxis: {
					title: '%',
					titleTextStyle: {color: '#FFF'},
					textStyle:{color: '#FFF'},
					maxValue: 100,
					minValue: 0
				}
				
			};
			
			
			var chart = new google.visualization.ColumnChart(parent.document.getElementById('chart_div'));
			chart.draw(data, options);
		}
		
	</c:when>
	<c:otherwise>
	
		parent.document.getElementById('chart_div').innerHTML = "<table width=100%><tr><td align='center' style='width:100%;height:500px' border=1><h1 style='color:#FFFFFF;'>조회 결과가 없습니다</h1></td></tr></table>";
	
	</c:otherwise>
	
</c:choose>
	
	parent.document.getElementById("progress_div").style.visibility = "hidden";
	
</script>