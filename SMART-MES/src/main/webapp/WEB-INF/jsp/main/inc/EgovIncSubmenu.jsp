<%--
  Class Name : EgovIncSubmenu.jsp
  Description : Sub메뉴화면(include)
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2015.02.25  KDW       좌측메뉴를 상당 Sub메뉴로 변경

    author   : 스페이스솔루션 KDW
    since    : 2015.02.25
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import ="egovframework.com.cmm.LoginVO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="<c:url value="/js/EgovSubMenu.js"/>"/></script>
<script type="text/javascript">
<!--
/* ********************************************************
 * 상세내역조회 함수
 ******************************************************** */
 
function fn_MovePage(nodeNum) {
    var nodeValues = treeNodes[nodeNum].split("|");
    //parent.main_right.location.href = nodeValues[5];
    
    if(nodeValues[5].indexOf("?")>0)
    {
    	document.menuListForm.action = "${pageContext.request.contextPath}"+nodeValues[5] + "&currentMenuNo=" + nodeValues[0];
    }
    else
    {
    	document.menuListForm.action = "${pageContext.request.contextPath}"+nodeValues[5] + "?currentMenuNo=" + nodeValues[0];
    }
    
    //alert(document.menuListForm.action);
    document.menuListForm.submit();
}
//-->
</script>
<!-- 메뉴 시작 -->
<div>
	<div>
		<script type="text/javascript">
			<!--
				var Tree = new Array;
     
				var currentUrl = "<%=request.getRequestURL()%>";
				var currentMenuNo = "<%=session.getAttribute("currentMenuNo")%>";
				currentUrl = currentUrl.substring(currentUrl.indexOf("/WEB-INF/jsp/")+12,currentUrl.lastIndexOf("."));
     
				if(document.menuListForm.tmp_menuNm != null)
				{
					for (var j = 0; j < document.menuListForm.tmp_menuNm.length; j++)
					{
						Tree[j] = document.menuListForm.tmp_menuNm[j].value;
                 
						if(Tree[j].substring(0,Tree[j].indexOf("|")) == currentMenuNo)
						{
							document.title = Tree[j].substring(nth_occurrence(Tree[j],"|",2)+1,nth_occurrence(Tree[j],"|",3));
						}
					}
				}
         
				createTree(Tree, true, document.getElementById("baseMenuNo").value,currentMenuNo);
         
				//n번째 문자열 위치 찾기
				function nth_occurrence (string, char, nth)
				{ 
					var first_index = string.indexOf(char); 
					var length_up_to_first_index = first_index + 1; 

					if (nth == 1)
					{ 
						return first_index; 
					}
					else
					{ 
						var string_after_first_occurrence = string.slice(length_up_to_first_index); 
						var next_occurrence = nth_occurrence(string_after_first_occurrence, char, nth - 1); 

						if (next_occurrence === -1)
						{ 
							return -1; 
						}
						else
						{ 
							return length_up_to_first_index + next_occurrence; 
						} 
					} 
				} 
			//-->
		</script>
	</div>
</div>

<!-- //메뉴 끝 -->