<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java"%>
<%@page import="com.ecs.soap.proxy.servlets.UploadServlet"%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<html>
<%
String uri = (String) request.getAttribute(UploadServlet.URI_PARAM);
if(uri == null) uri = "";
String targetUrl = (String) request.getAttribute(UploadServlet.TARGET_ENDPOINT_URL_PARAM);
if(targetUrl == null) targetUrl = "";
String schemaPath = (String) request.getAttribute(UploadServlet.SCHEMA_FILE_PARAM);
if(schemaPath == null) schemaPath = "";
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
</div>
<div id="toolbar">
<button type="button" onclick="document.getElementById('backForm').submit();" style="margin-left:7px; cursor:pointer; cursor:hand" ><img title="Back to mapping" src="<%=request.getContextPath() %>/img/mapping.gif" />&nbsp;Back to mapping</button>
</div>
</div>
<div id="main">
<jsp:include page="include/main-top.jsp">
	<jsp:param value="Upload new mapping configuration" name="title"/>
</jsp:include>
<form id="cancelForm" action="<%=request.getContextPath() %>" method="get">
</form>
<form action="<%=request.getContextPath() + UploadServlet.servletContextPath%>" enctype="multipart/form-data" method="post">
<table class="uploadPageTable">
<tr>
<td class="propertyName">
Proxy URI:&nbsp;<span style="color: red">*</span>
</td>
<td class="propertyValue">
<input type="text" name="<%=UploadServlet.URI_PARAM %>" value="<%=uri %>" size="75" />
</td>
<%
if(!StringUtils.isEmpty((String) request.getAttribute(UploadServlet.URI_PARAM + UploadServlet.ERROR_SUFFIX))){
%>
</tr>
<tr>
<td>&nbsp;</td>
<td class="propertyValue">
<span style="color: red"><i><%=(String) request.getAttribute(UploadServlet.URI_PARAM + UploadServlet.ERROR_SUFFIX) %></i></span>
</td>
</tr>
<%
} else {
%>
</tr>
<%
}
%>
<tr>
<td class="propertyName">
Target endpoint URL:&nbsp;<span style="color: red">*</span>
</td>
<td class="propertyValue">
<input type="text" name="<%=UploadServlet.TARGET_ENDPOINT_URL_PARAM %>" value="<%=targetUrl %>" size="75" />
</td>
<%
if(!StringUtils.isEmpty((String) request.getAttribute(UploadServlet.TARGET_ENDPOINT_URL_PARAM + UploadServlet.ERROR_SUFFIX))){
%>
</tr>
<tr>
<td class="propertyName">&nbsp;</td>
<td class="propertyValue">
<span style="color: red"><i><%=(String) request.getAttribute(UploadServlet.TARGET_ENDPOINT_URL_PARAM + UploadServlet.ERROR_SUFFIX)%></i></span>
</td>
</tr>
<%
} else {
%>
</tr>
<%
}
%>
<tr>
<td class="propertyName">
Schema file (XSD or WSDL):
</td>
<td class="propertyValue">
<input type="file" name="<%=UploadServlet.SCHEMA_FILE_PARAM %>" />
</td>
<%
if(!StringUtils.isEmpty((String) request.getAttribute(UploadServlet.SCHEMA_FILE_PARAM + UploadServlet.ERROR_SUFFIX))){
%>
</tr>
<tr>
<td class="propertyName">&nbsp;</td>
<td class="propertyValue">
<span style="color: red"><i><%=(String) request.getAttribute(UploadServlet.SCHEMA_FILE_PARAM + UploadServlet.ERROR_SUFFIX)%></i></span>
</td>
</tr>
<%
} else {
%>
</tr>
<%
}
%>
<tr>
<td class="propertyName" style="font-weight: normal;" colspan="2">
<span style="color: red;"><i>* Mandatory fields</i></span>
</td>
</tr>
<tr>
<td colspan="2" align="center">
<table>
<tr>
<td>
<button type="submit" style="margin-left:7px; cursor:pointer; cursor:hand" ><img title="Upload" src="<%=request.getContextPath() %>/img/apply.gif" />&nbsp;Upload</button>
<button type="button" onclick="document.getElementById('cancelForm').submit();" style="cursor:pointer; cursor:hand" ><img title="Cancel" src="<%=request.getContextPath() %>/img/cancel.gif" />&nbsp;Cancel</button>
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
</div>
</div>
</body>
</html>