<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java"%>
<%@page import="com.ecs.soap.proxy.servlets.MappingConfigurationServlet"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.ecs.soap.proxy.servlets.DownloadServlet"%>
<%@page import="com.ecs.soap.proxy.servlets.UploadServlet"%>
<%@page import="com.ecs.soap.proxy.servlets.DeleteServlet"%>
<%@page import="com.ecs.soap.proxy.servlets.SOAPServlet"%>
<%@page import="com.ecs.soap.proxy.servlets.ResultsServlet"%>
<%
Properties uriMapping = (Properties) request.getAttribute(MappingConfigurationServlet.URI_MAPPING_ATT);
Properties schemaMapping = (Properties) request.getAttribute(MappingConfigurationServlet.SCHEMA_MAPPING_ATT);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="include/main-title.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/proxy.js" ></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/style.css" >
</head>
<body>
<div id="content">
<div id="header">
<%@include file="include/header-title.jsp" %>
<div style="display: none;">
<form id="addMappingForm" action="<%=request.getContextPath() + UploadServlet.servletContextPath %>" method="GET" >
</form>
<form id="resultsForm" action="<%=request.getContextPath() + ResultsServlet.servletContextPath %>" method="GET" >
</form>
</div>
<div id="toolbar">
<button type="button" onclick="document.getElementById('addMappingForm').submit();" style="margin-left:7px; cursor:pointer; cursor:hand" ><img title="New mapping configuration" src="<%=request.getContextPath() %>/img/add-mapping.gif" />&nbsp;New mapping configuration</button>
<button type="button" onclick="document.getElementById('resultsForm').submit();" style="cursor:pointer; cursor:hand" ><img title="View last results" src="<%=request.getContextPath() %>/img/results.gif" />&nbsp;View last results</button>
</div>
</div>
<div id="main">
<jsp:include page="include/main-top.jsp">
	<jsp:param value="Mapping configuration of the Proxy" name="title"/>
</jsp:include>
<% if(uriMapping == null || uriMapping.isEmpty()){ %>
<p class="noConfiguration"><i>No configuration</i></p>
<% } else {
	for(Enumeration<Object> eKey = uriMapping.keys(); eKey.hasMoreElements(); ){
		String uri = (String) eKey.nextElement();
		String targetUrl = uriMapping.getProperty(uri);
%>
<div id="item">
<fieldset>
<legend>Proxy for <%=uri %></legend>
<table class="itemTable" >
<tr>
<td class="propertyName">Local URL:</td>
<td class="propertyValue">
<%=request.getScheme() + "://" + request.getLocalAddr() + ":" + request.getLocalPort() + request.getContextPath() + SOAPServlet.servletContextPath + uri %>
</td>
</tr>
<tr class="trOneFieldForm" >
<td class="propertyName">Target URL:</td>
<td class="propertyValue">
<table class="targetUrlTable" cellpadding="0" cellspacing="0">
<tr id="<%=uri %>.currentTargetUrl">
<td>
<%=targetUrl %>
</td>
<td>
<img onclick="document.getElementById('<%=uri %>.modifyTargetUrl').style.display = 'block';document.getElementById('<%=uri %>.currentTargetUrl').style.display = 'none';" style="cursor:pointer; cursor:hand" title="Modify target URL" src="<%=request.getContextPath() %>/img/modify.gif" />
</td>
</tr>
<tr id="<%=uri %>.modifyTargetUrl" style="display: none;">
<td colspan="2" >
<form id="<%=uri %>.modifyTargetUrlForm" action="<%=request.getContextPath() + UploadServlet.servletContextPath %>" enctype="multipart/form-data" method="post">
<input type="hidden" name="<%=UploadServlet.URI_PARAM %>" value="<%=uri %>" />
<table class="modifyUrlTable" cellpadding="0" cellspacing="0">
<tr>
<td>
<input type="text" name="<%=UploadServlet.TARGET_ENDPOINT_URL_PARAM %>" value="<%=targetUrl %>" size="75" />
</td>
<td>
<button type="button" onclick="document.getElementById('<%=uri %>.modifyTargetUrlForm').submit();" style="margin-left:7px; cursor:pointer; cursor:hand" ><img title="Modify" src="<%=request.getContextPath() %>/img/apply.gif" />&nbsp;Modify</button>
<button type="button" onclick="document.getElementById('<%=uri %>.currentTargetUrl').style.display = 'block';document.getElementById('<%=uri %>.modifyTargetUrl').style.display = 'none';" style="cursor:pointer; cursor:hand" ><img title="Cancel" src="<%=request.getContextPath() %>/img/cancel.gif" />&nbsp;Cancel</button>
</td>
</tr>
</table>
</form>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td class="propertyName" valign="top" >Schema files:</td>
<td class="propertyValue">
<table class="schemaTable" cellpadding="0" cellspacing="0">
<%if(schemaMapping.containsKey(uri)){ %>
<%
String schemaFiles = schemaMapping.getProperty(uri);
String[] schemaFileTokens = schemaFiles.split(",");
for(String schemaFile : schemaFileTokens){
	schemaFile = schemaFile.trim();
%>
<tr>
<td>
<a target="_blank" href="<%=request.getContextPath() + DownloadServlet.servletContextPath%>?<%=DownloadServlet.FILE_PARAM %>=<%=schemaFile %>"><%=schemaFile %></a>
</td>
<td>
<img style="cursor:pointer; cursor:hand" title="Remove this schema" onclick="javascript:document.getElementById('<%=uri %>.deleteSchemaForm').<%=DeleteServlet.FILE_PARAM %>.value='<%=schemaFile %>';confirmDeleteSchema('<%=uri %>.deleteSchemaForm', '<%=uri %>', '<%=schemaFile %>');" src="<%=request.getContextPath() %>/img/delete.gif" style="cursor: hand;" />
</td>
</tr>
<%
} // end for
%>
<% } else { %>
<tr>
<td><i>none</i></td>
</tr>
<%} %>
</table>
<table class="addSchemaTable" cellpadding="0" cellspacing="0">
<tr id="<%=uri %>.addSchema"  class="trOneFieldForm" >
<td>
<button type="button" onclick="document.getElementById('<%=uri %>').style.display = 'block';document.getElementById('<%=uri %>.addSchema').style.display = 'none';" style="cursor:pointer; cursor:hand" ><img title="Add a schema" src="<%=request.getContextPath() %>/img/add.gif" />&nbsp;Add a schema</button>
</td>
</tr>
<tr id="<%=uri %>" style="display: none" class="trOneFieldForm">
<td>
<form id="<%=uri %>.addSchemaForm" action="<%=request.getContextPath() +UploadServlet.servletContextPath %>" enctype="multipart/form-data" method="post">
<input type="hidden" name="<%=UploadServlet.URI_PARAM %>" value="<%=uri %>" />
<input type="hidden" name="<%=UploadServlet.TARGET_ENDPOINT_URL_PARAM %>" value="<%=targetUrl %>" />
<table class="addSchemaTable" cellpadding="0" cellspacing="0">
<tr>
<td>Schema file (XSD or WSDL):</td>
<td>
<input type="file" name="<%=UploadServlet.SCHEMA_FILE_PARAM %>" />
</td>
<td>
<button type="button" onclick="document.getElementById('<%=uri %>.addSchemaForm').submit();" style="margin-left:7px; cursor:pointer; cursor:hand" ><img title="Upload" src="<%=request.getContextPath() %>/img/apply.gif" />&nbsp;Upload</button>
<button type="button" onclick="document.getElementById('<%=uri %>.addSchema').style.display = 'block';document.getElementById('<%=uri %>').style.display = 'none';" style="cursor:pointer; cursor:hand" ><img title="Cancel" src="<%=request.getContextPath() %>/img/cancel.gif" />&nbsp;Cancel</button>
</td>
</tr>
</table>
</form>
</td>
</tr>
</table>
</td>
</tr>
</table>
<br/>
<button type="button" onclick="javascript:confirmDeleteMapping('<%=uri %>.deleteMappingForm', '<%=uri %>');" style="margin-left:7px; cursor:pointer; cursor:hand" ><img title="Delete this mapping" src="<%=request.getContextPath() %>/img/trash.gif" />&nbsp;Delete this mapping</button>
<%if(schemaMapping.containsKey(uri)){ %>
<div style="display: none;">
<form id="<%=uri %>.deleteSchemaForm" action="<%=request.getContextPath() + DeleteServlet.servletContextPath %>" method="POST">
<input type="hidden" name="<%=DeleteServlet.TYPE_PARAM %>" value="<%=DeleteServlet.SCHEMA_PARAM %>" />
<input type="hidden" name="<%=DeleteServlet.FILE_PARAM %>" />
<input type="hidden" name="<%=DeleteServlet.URI_PARAM %>" value="<%=uri %>" />
</form>
</div>
<%} %>
<div style="display: none;">
<form id="<%=uri %>.deleteMappingForm" action="<%=request.getContextPath() + DeleteServlet.servletContextPath %>" method="POST">
<input type="hidden" name="<%=DeleteServlet.TYPE_PARAM %>" value="<%=DeleteServlet.ALL_PARAM %>" />
<input type="hidden" name="<%=DeleteServlet.URI_PARAM %>" value="<%=uri %>" />
</form>
</div>
</fieldset>
</div>
<%
}// end for
}// end else
%>
</div>
</div>
</body>
</html>