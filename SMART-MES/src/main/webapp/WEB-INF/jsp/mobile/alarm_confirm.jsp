<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script>

	if("${actionresult}" == "OK")
	{
		alert("<spring:message code="space.common.alert.alarm.modify.confirm" />");
				
		parent.selfReload();
	}
	else if("${actionresult}".indexOf("ERROR") > -1)
	{
		alert("<spring:message code="space.common.alert.alarm.modify.error" />[${actionresult}]");
	}
	
	parent.document.getElementById("btn_layer").style.display = "block";
	
	parent.$.mobile.loading( "hide" );
	
</script>