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

<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript">var jq$ =jQuery.noConflict();</script>
<script type="text/javascript" src="<c:url value="/js/titlefix/jquery.fixedheadertable.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>
<script>

	var strHtml = new StringBuffer();
	
	var mapRowspanLevel1 = new Map();
	var mapRowspanLevel2 = new Map();
	var mapRowspanPie = new Map();
	var mapRowspanFb = new Map();
	var mapRowspanRadius = new Map();
	
	var oldItemLevel1 = "";
	var oldItemLevel2 = "";
	var oldItemPie = "";
	var oldItemFb = "";
	var oldItemRadius = "";
	
	var cntRowspanLevel1 = 0;
	var cntRowspanLevel2 = 0;
	var cntRowspanPie = 0;
	var cntRowspanFb = 0;
	var cntRowspanRadius = 0;
	
	<c:forEach var="result" items="${result}" varStatus="status">

		if(${status.index} > 0 && oldItemLevel1 != "${result.TOOL_LEVEL_1}")
		{
			mapRowspanLevel1.put(oldItemLevel1,cntRowspanLevel1);
			cntRowspanLevel1 = 1;
		}
		else
		{
			cntRowspanLevel1 ++;
		}
		
		if(${status.index} > 0 && oldItemLevel2 != "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}")
		{
			mapRowspanLevel2.put(oldItemLevel2,cntRowspanLevel2);
			cntRowspanLevel2 = 1;
		}
		else
		{
			cntRowspanLevel2 ++;
		}
		
		if(${status.index} > 0 && oldItemPie != "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}")
		{
			mapRowspanPie.put(oldItemPie,cntRowspanPie);
			cntRowspanPie = 1;
		}
		else
		{
			cntRowspanPie ++;
		}
		
		if(${status.index} > 0 && oldItemFb != "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}")
		{
			mapRowspanFb.put(oldItemFb,cntRowspanFb);
			cntRowspanFb = 1;
		}
		else
		{
			cntRowspanFb ++;
		}
		
		if(${status.index} > 0 && oldItemRadius != "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}_${result.TOOL_RADIUS}")
		{
			mapRowspanRadius.put(oldItemRadius,cntRowspanRadius);
			cntRowspanRadius = 1;
		}
		else
		{
			cntRowspanRadius ++;
		}
		
		oldItemLevel1 =  "${result.TOOL_LEVEL_1}";
		oldItemLevel2 =  "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}";
		oldItemPie =  "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}";
		oldItemFb =  "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}";
		oldItemRadius =  "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}_${result.TOOL_RADIUS}";
	
	</c:forEach>
	
	mapRowspanLevel1.put(oldItemLevel1,cntRowspanLevel1);
	mapRowspanLevel2.put(oldItemLevel2,cntRowspanLevel2);
	mapRowspanPie.put(oldItemPie,cntRowspanPie);
	mapRowspanFb.put(oldItemFb,cntRowspanFb);
	mapRowspanRadius.put(oldItemRadius,cntRowspanRadius);
	
	
	oldItemLevel1 = "";
	oldItemLevel2 = "";
	oldItemPie = "";
	oldItemFb = "";
	oldItemRadius = "";

	<c:forEach var="result" items="${result}" varStatus="status">
	
		strHtml.append("<tr title='${result.TOOL_ID}'>");
		
		if(${status.first} || oldItemLevel1 != "${result.TOOL_LEVEL_1}")
		{
			strHtml.append("<td rowspan=");strHtml.append(mapRowspanLevel1.get("${result.TOOL_LEVEL_1}"));strHtml.append("><font color='#FFF'>${result.TOOL_LEVEL_1}</font></td>");
		}
		
		if(${status.first} || oldItemLevel2 != "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}")
		{
			strHtml.append("<td rowspan=");strHtml.append(mapRowspanLevel2.get("${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}"));strHtml.append("><font color='#FFF'>${result.TOOL_LEVEL_2}</font></td>");
		}
		
		if(${status.first} || oldItemPie != "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}")
		{
			strHtml.append("<td rowspan=");strHtml.append(mapRowspanPie.get("${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}"));strHtml.append("><font color='#FFF'>${result.TOOL_PIE}</font></td>");
		}
		
		if(${status.first} || oldItemFb != "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}")
		{
			strHtml.append("<td rowspan=");strHtml.append(mapRowspanFb.get("${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}"));strHtml.append("><font color='#FFF'>${result.TOOL_FB}</font></td>");
		}
		
		if(${status.first} || oldItemRadius != "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}_${result.TOOL_RADIUS}")
		{
			strHtml.append("<td rowspan=");strHtml.append(mapRowspanRadius.get("${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}_${result.TOOL_RADIUS}"));strHtml.append("><font color='#FFF'>${result.TOOL_RADIUS}</font></td>");
		}
		
		strHtml.append("<td>${result.TOOL_LENGTH}</td>");
		strHtml.append("<td <c:choose><c:when test="${result.TOOL_SAFE_STOCK == result.TOOL_CURRENT_STOCK}">style='background-color:#99ccff'</c:when><c:when test="${result.TOOL_SAFE_STOCK > result.TOOL_CURRENT_STOCK}">style='background-color:#ff6699'</c:when></c:choose>><input type='checkbox' id='${result.TOOL_ID}_check'></td>");
		strHtml.append("<td <c:choose><c:when test="${result.TOOL_SAFE_STOCK == result.TOOL_CURRENT_STOCK}">style='background-color:#99ccff'</c:when><c:when test="${result.TOOL_SAFE_STOCK > result.TOOL_CURRENT_STOCK}">style='background-color:#ff6699'</c:when></c:choose>><input type='text' id='${result.TOOL_ID}_unit' style='height:15px;width:70px;text-align:right;' onkeyup='checkStrLength(30,this);onlyNum(this);this.value=this.value.comma();' value='${result.TOOL_UNIT}'></td>");
		strHtml.append("<td <c:choose><c:when test="${result.TOOL_SAFE_STOCK == result.TOOL_CURRENT_STOCK}">style='background-color:#99ccff'</c:when><c:when test="${result.TOOL_SAFE_STOCK > result.TOOL_CURRENT_STOCK}">style='background-color:#ff6699'</c:when></c:choose>><input type='text' id='${result.TOOL_ID}_safe' style='height:15px;width:70px;text-align:right;' onkeyup='checkStrLength(30,this);onlyNum(this);' value='${result.TOOL_SAFE_STOCK}'></td>");
		strHtml.append("<td <c:choose><c:when test="${result.TOOL_SAFE_STOCK == result.TOOL_CURRENT_STOCK}">style='background-color:#99ccff'</c:when><c:when test="${result.TOOL_SAFE_STOCK > result.TOOL_CURRENT_STOCK}">style='background-color:#ff6699'</c:when></c:choose>><font color='#FFF'>${result.TOOL_CURRENT_STOCK}</font></td>");
		strHtml.append("<td <c:choose><c:when test="${result.TOOL_SAFE_STOCK == result.TOOL_CURRENT_STOCK}">style='background-color:#99ccff'</c:when><c:when test="${result.TOOL_SAFE_STOCK > result.TOOL_CURRENT_STOCK}">style='background-color:#ff6699'</c:when></c:choose>><input type='text' id='${result.TOOL_ID}_stock' style='height:15px;width:70px;text-align:right;' onkeyup='checkStrLength(30,this);onlyNum(this);' value=''></td>");
		strHtml.append("<input type='hidden' id='${result.TOOL_ID}_level1' value='${result.TOOL_LEVEL_1}'>");
		strHtml.append("<input type='hidden' id='${result.TOOL_ID}_level2' value='${result.TOOL_LEVEL_2}'>");
		strHtml.append("<input type='hidden' id='${result.TOOL_ID}_pie' value='${result.TOOL_PIE}'>");
		strHtml.append("<input type='hidden' id='${result.TOOL_ID}_fb' value='${result.TOOL_FB}'>");
		strHtml.append("<input type='hidden' id='${result.TOOL_ID}_radius' value='${result.TOOL_RADIUS}'>");
		strHtml.append("<input type='hidden' id='${result.TOOL_ID}_length' value='${result.TOOL_LENGTH}'>");
		strHtml.append("</tr>");
		
		oldItemLevel1 =  "${result.TOOL_LEVEL_1}";
		oldItemLevel2 =  "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}";
		oldItemPie =  "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}";
		oldItemFb =  "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}";
		oldItemRadius =  "${result.TOOL_LEVEL_1}_${result.TOOL_LEVEL_2}_${result.TOOL_PIE}_${result.TOOL_FB}_${result.TOOL_RADIUS}";
		
	</c:forEach>
	
	parent.jq$("#data_table_tbody").empty();
	
	parent.jq$("#data_table_tbody").append(strHtml.toString());
	
	parent.document.getElementById("progress_div").style.visibility = "hidden";
	
</script>