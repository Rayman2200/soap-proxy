<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.Map"%>
<%@ page language="java"%>
<%@page import="java.util.List"%>
<%@page import="com.ecs.soap.proxy.result.model.CallResult"%>
<%@page import="com.ecs.soap.proxy.servlets.ResultsServlet"%>


<%@page import="com.ecs.soap.proxy.result.model.CallResult.Status"%><html>
<%
List<CallResult> results = (List<CallResult>) request.getAttribute(ResultsServlet.RESULTS_ATT);
Map<String, String> chartsPng = (Map<String, String>) request.getAttribute(ResultsServlet.GRAPHS_ATT);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="include/main-title.jsp" %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/style.css" >
</head>
<body>
<div id="content">
<div id="header">
<%@include file="include/header-title.jsp" %>
<div style="display: none;">
<form id="backForm" action="<%=request.getContextPath() %>/" method="GET" >
</form>
<form id="resultsForm" action="<%=request.getContextPath() + ResultsServlet.servletContextPath %>" method="GET" >
</form>
<form id="clearForm" action="<%=request.getContextPath() + ResultsServlet.servletContextPath %>" method="GET" >
<input type="hidden" name="<%=ResultsServlet.CLEAR_PARAM %>" value="all" />
</form>
</div>
<div id="toolbar">
<button onclick="document.getElementById('backForm').submit();" style="margin-left:7px; cursor:pointer; cursor:hand" ><img title="Back to mapping" src="<%=request.getContextPath() %>/img/mapping.gif" />&nbsp;Back to mapping</button>
<button onclick="document.getElementById('resultsForm').submit();" style="cursor:pointer; cursor:hand" ><img title="Refresh" src="<%=request.getContextPath() %>/img/refresh.gif" />&nbsp;Refresh</button>
<button onclick="document.getElementById('clearForm').submit();" style="cursor:pointer; cursor:hand" ><img title="Clear" src="<%=request.getContextPath() %>/img/delete.gif" />&nbsp;Clear</button>
</div>
</div>
<div id="main">
<jsp:include page="include/main-top.jsp">
	<jsp:param value="Last proxy results" name="title"/>
</jsp:include>
<% if(results == null || results.isEmpty()){ %>
<p class="noResults"><i>No results yet</i></p>
<% } else { %>
<div style="margin-left: auto; margin-right: auto;">
<table class="resultsTable" border="1" cellpadding="0" cellspacing="0" >
<tr>
<th class="headerCell"><b>Timestamp</b></th>
<th class="headerCell"><b>URI</b></th>
<th class="headerCell"><b>Request</b></th>
<th class="headerCell"><b>Request status</b></th>
<th class="headerCell"><b>Response</b></th>
<th class="headerCell"><b>Response status</b></th>
<th class="headerCell"><b>Response time (ms)</b></th>
</tr>
<% for(int i = results.size() - 1; i>=0; i--){
CallResult result = results.get(i);
%>
<tr>
<td class="statsCell">
<%=result.getFormattedTimestamp() %>
</td>
<td class="statsCell">
<%=result.getUri() %>
</td>
<td class="statsCell">
<%if(result.getSoapRequest() == null){ %>
-
<%} else { %>
<img title="Show SOAP request" style="cursor:pointer; cursor:hand" onclick="document.getElementById('requestForm.<%=i %>').submit();" src="<%=request.getContextPath() %>/img/message.gif" />
<div style="display: none;">
<form id="requestForm.<%=i %>" action="<%=request.getContextPath() + ResultsServlet.servletContextPath %>" method="POST" target="_blank">
<input type="hidden" name="<%=ResultsServlet.SHOW_PARAM %>" value="<%=ResultsServlet.REQUEST_VALUE %>" />
<input type="hidden" name="<%=ResultsServlet.INDEX_PARAM %>" value="<%=i %>" />
</form>
</div>
<%} %>
</td>
<td class="statsCell">
<%if(result.getSoapRequest() == null){ %>
-
<%} else { %>
<%if(result.getRequestStatus().equals(CallResult.Status.OK)){%>
<%if(result.getRequestDetailedErrors().isEmpty()){ %>
<img src="<%=request.getContextPath() %>/img/ok.gif" />
<% } else { %>
<img title="Show errors" style="cursor:pointer; cursor:hand" onclick="document.getElementById('requestErrorsForm.<%=i %>').submit();" src="<%=request.getContextPath() %>/img/warn.gif" />
<%} %>
<% } else { %>
<img title="Show errors" style="cursor:pointer; cursor:hand" onclick="document.getElementById('requestErrorsForm.<%=i %>').submit();" src="<%=request.getContextPath() %>/img/ko.gif" />
<%} %>
<%} %>
<div style="display: none;">
<form id="requestErrorsForm.<%=i %>" action="<%=request.getContextPath() + ResultsServlet.servletContextPath %>" method="POST" target="_blank">
<input type="hidden" name="<%=ResultsServlet.SHOW_PARAM %>" value="<%=ResultsServlet.REQUEST_ERRORS_VALUE %>" />
<input type="hidden" name="<%=ResultsServlet.INDEX_PARAM %>" value="<%=i %>" />
</form>
</div>
</td>
<td class="statsCell">
<%if(result.getSoapResponse() == null){ %>
-
<%} else { %>
<img title="Show SOAP response" style="cursor:pointer; cursor:hand" onclick="document.getElementById('responseForm.<%=i %>').submit();" src="<%=request.getContextPath() %>/img/message.gif" />
<div style="display: none;">
<form id="responseForm.<%=i %>" action="<%=request.getContextPath() + ResultsServlet.servletContextPath %>" method="POST" target="_blank">
<input type="hidden" name="<%=ResultsServlet.SHOW_PARAM %>" value="<%=ResultsServlet.RESPONSE_VALUE %>" />
<input type="hidden" name="<%=ResultsServlet.INDEX_PARAM %>" value="<%=i %>" />
</form>
</div>
<%} %>
</td>
<td class="statsCell">
<%if(result.getSoapResponse() == null){ %>
-
<%} else { %>
<%if(result.getResponseStatus().equals(CallResult.Status.OK)){%>
<%if(result.getResponseDetailedErrors().isEmpty()){ %>
<img src="<%=request.getContextPath() %>/img/ok.gif" />
<% } else { %>
<img title="Show errors" style="cursor:pointer; cursor:hand" onclick="document.getElementById('responseErrorsForm.<%=i %>').submit();" src="<%=request.getContextPath() %>/img/warn.gif" />
<%} %>
<% } else { %>
<img title="Show errors" style="cursor:pointer; cursor:hand" onclick="document.getElementById('responseErrorsForm.<%=i %>').submit();" src="<%=request.getContextPath() %>/img/ko.gif" />
<%} %>
<%} %>
<div style="display: none;">
<form id="responseErrorsForm.<%=i %>" action="<%=request.getContextPath() + ResultsServlet.servletContextPath %>" method="POST" target="_blank">
<input type="hidden" name="<%=ResultsServlet.SHOW_PARAM %>" value="<%=ResultsServlet.RESPONSE_ERRORS_VALUE %>" />
<input type="hidden" name="<%=ResultsServlet.INDEX_PARAM %>" value="<%=i %>" />
</form>
</div>
</td>
<td class="statsCell">
<%if(result.getResponseTime() == null){ %>
-
<%} else { %>
<%=result.getResponseTime() %>
<%} %>
</td>
</tr>
<%
}
%>
</div>
</table>
<%
}
%>
</div>
<%if(chartsPng != null && !chartsPng.isEmpty()) {%>
<br/>
<br/>
<br/>
<div style="margin-left: auto; margin-right: auto;">
<table class="graphsTable" border="0" cellpadding="0" cellspacing="0" >
<%for(String content : chartsPng.values()) {%>
<tr align="center">
<td class="statsCell" align="center">
<img  align="middle" src="data:image/png;base64,<%=content %>" />
</td>
</tr>
<%} %>
</table>
</div>
<%} %>
</div>
</body>
</html>