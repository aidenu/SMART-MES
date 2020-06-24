<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.min.js"/>"/></script>
<script>

		var actionlevel = ${actionlevel};
		var parentid = "${parentid}";
		
		if("${result}" == "INSERTOK")
		{
			alert("저장 되었습니다");
			parent.document.getElementById("level"+actionlevel+"_name").value = "";
			parent.document.getElementById("level"+actionlevel+"_value").options.length = 0;
			parent.getBasicHiddenData(actionlevel,parentid);
		}
		else if("${result}".indexOf("INSERTERROR") > -1)
		{
			alert("저장중 에러가 발생하였습니다[(${actionresult}).substr(6)]");
		}
		else if("${result}" == "UPDATEOK")
		{
			alert("수정 되었습니다");
			parent.document.getElementById("level"+actionlevel+"_name").value = "";
			parent.document.getElementById("level"+actionlevel+"_value").options.length = 0;
			parent.getBasicHiddenData(actionlevel,parentid);
		}
		else if("${result}".indexOf("UPDATEERROR") > -1)
		{
			alert("수정중 에러가 발생하였습니다[(${actionresult}).substr(6)]");
		}
		else if("${result}" == "DELETEOK")
		{
			alert("삭제 되었습니다");
			parent.document.getElementById("level"+actionlevel+"_name").value = "";
			parent.document.getElementById("level"+actionlevel+"_value").options.length = 0;
			parent.getBasicHiddenData(actionlevel,parentid);
		}
		else if("${result}".indexOf("DELETEERROR") > -1)
		{
			alert("삭제중 에러가 발생하였습니다[(${actionresult}).substr(6)]");
		}
	
		//선택한 항목의 하위 항목 화면을 표시한다
		if(actionlevel == 1)
		{
			parent.$("td_img_2").style.visibility = "hidden";
			parent.$("td_box_2").style.visibility = "hidden";
			parent.$("td_img_3").style.visibility = "hidden";
			parent.$("td_box_3").style.visibility = "hidden";
			parent.$("td_img_4").style.visibility = "hidden";
			parent.$("td_box_4").style.visibility = "hidden";
			parent.$("td_img_5").style.visibility = "hidden";
			parent.$("td_box_5").style.visibility = "hidden";
		}
		else if(actionlevel == 2)
		{
			parent.$("td_img_3").style.visibility = "hidden";
			parent.$("td_box_3").style.visibility = "hidden";
			parent.$("td_img_4").style.visibility = "hidden";
			parent.$("td_box_4").style.visibility = "hidden";
			parent.$("td_img_5").style.visibility = "hidden";
			parent.$("td_box_5").style.visibility = "hidden";
		}
		else if(actionlevel == 3)
		{
			parent.$("td_img_4").style.visibility = "hidden";
			parent.$("td_box_4").style.visibility = "hidden";
			parent.$("td_img_5").style.visibility = "hidden";
			parent.$("td_box_5").style.visibility = "hidden";
		}
		else if(actionlevel == 4)
		{
			parent.$("td_img_5").style.visibility = "hidden";
			parent.$("td_box_5").style.visibility = "hidden";
		}

</script>