<%
String title = (String) request.getParameter("title");
if(title == null) title = "";
%>

<table class="mainBorder" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td class="mainBorderLeft"><img src="<%=request.getContextPath() %>/img/titl2_b_middle.jpg" /></td>
<td class="mainBorderMiddle"><span><%=title %></span></td>
<td class="mainBorderRight"><img src="<%=request.getContextPath() %>/img/titl2_b_middle.jpg" /></td>
</tr>
</table>