<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script type="text/javascript" src="<c:url value="/js/spaceutil.js"/>"/></script>

<script>
	
	if("${ACTION_RESULT}" == "OK")
	{
		if("${actiontype}" == "NEW")
		{
			alert("등록 되었습니다");
		}
		else if("${actiontype}" == "UPDATE")
		{
			alert("수정 되었습니다");
		}
		else
		{
			alert("삭제 되었습니다");
		}
	}
	else
	{
		if("${actiontype}" == "NEW")
		{
			alert("등록 중 에러가 발생되었습니다["+replaceAll("${ACTION_RESULT}","|","\n")+"]");
		}
		else if("${actiontype}" == "UPDATE")
		{
			alert("수정 중 에러가 발생되었습니다["+replaceAll("${ACTION_RESULT}","|","\n")+"]");
		}
		else
		{
			alert("삭제 중 에러가 발생되었습니다["+replaceAll("${ACTION_RESULT}","|","\n")+"]");
		}
	}

	parent.document.getElementById("progress_div").style.visibility = "hidden";
	
	parent.opener.getData();
	
	parent.self.close();
	
</script>