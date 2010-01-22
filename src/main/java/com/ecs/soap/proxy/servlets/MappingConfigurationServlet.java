package com.ecs.soap.proxy.servlets;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.ecs.soap.proxy.config.Configuration;


public class MappingConfigurationServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -319343346575670887L;
	
	public static final String SOAP_PROXY_PATH_PARAM_NAME = "soap-proxy-path";
	
	public static final String URI_MAPPING_ATT = "uriMapping";
	
	public static final String SCHEMA_MAPPING_ATT = "schemaMapping";
	
	private static final Logger logger = Logger.getLogger(MappingConfigurationServlet.class);
	
	private Configuration config;

	@SuppressWarnings("unchecked")
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Properties uriMapping = new Properties();
		uriMapping.load(new FileInputStream(this.config.getUriMappingFile()));
		if(logger.isTraceEnabled()){
			StringBuffer buf = new StringBuffer("uri mapping: \n");
			for(Enumeration eKey = uriMapping.keys(); eKey.hasMoreElements(); ){
				String uri = (String) eKey.nextElement();
				String url = uriMapping.getProperty(uri);
				buf.append(uri + " = " + url);
				buf.append("\n");
			}
			logger.trace(buf.toString());
		}
		req.setAttribute(URI_MAPPING_ATT, uriMapping);
		
		Properties schemaMapping = new Properties();
		schemaMapping.load(new FileInputStream(this.config.getSchemaMappingFile()));
		if(logger.isTraceEnabled()){
			StringBuffer buf = new StringBuffer("schema mapping: \n");
			for(Enumeration eKey = schemaMapping.keys(); eKey.hasMoreElements(); ){
				String uri = (String) eKey.nextElement();
				String url = schemaMapping.getProperty(uri);
				buf.append(uri + " = " + url);
				buf.append("\n");
			}
			logger.trace(buf.toString());
		}
		req.setAttribute(SCHEMA_MAPPING_ATT, schemaMapping);
		
		String outputJsp = "/WEB-INF/jsp/config.jsp";
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(outputJsp);
		dispatcher.forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

	@Override
	public void init() throws ServletException {
		logger.trace("MappingConfigurationServlet.init()");
		try {
			ServletConfig servletConfig = getServletConfig();
			String path = servletConfig.getInitParameter(SOAP_PROXY_PATH_PARAM_NAME);
			if(!StringUtils.isEmpty(path)){
				Configuration.setSoapProxyPath(path);
			}
			this.config = Configuration.getInstance();
		} catch (Throwable t) {
			throw new ServletException("Servlet initialization failed", t);
		}

	}

}
