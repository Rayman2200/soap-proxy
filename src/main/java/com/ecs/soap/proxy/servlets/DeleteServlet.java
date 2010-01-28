package com.ecs.soap.proxy.servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.ecs.soap.proxy.config.Configuration;


public class DeleteServlet extends HttpServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = -319343346575670887L;

	public static final String servletContextPath = "/delete";

	public static final String TYPE_PARAM = "type";

	public static final String URI_PARAM = "uri";

	public static final String SCHEMA_PARAM = "schema";

	public static final String FILE_PARAM = "file";

	public static final String ALL_PARAM = "all";

	private static final Logger logger = Logger.getLogger(DeleteServlet.class);

	private Configuration config;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.sendError(502, "GET method is not allowed for this servlet");
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String type = req.getParameter(TYPE_PARAM);
		if(logger.isDebugEnabled()){
			logger.debug("type = " + type);
		}
		if(!SCHEMA_PARAM.equals(type) && !ALL_PARAM.equals(type)){
			throw new ServletException("type parameter should be " + SCHEMA_PARAM + " or " + ALL_PARAM);
		}
		String uri = req.getParameter(URI_PARAM);
		if(logger.isDebugEnabled()){
			logger.debug("uri = " + uri);
		}
		if(StringUtils.isEmpty(uri)){
			throw new ServletException("uri parameter should be part of the mapping configuration");
		}
		Properties uriMapping = new Properties();
		uriMapping.load(new FileInputStream(this.config.getUriMappingFile()));

		if(!uriMapping.containsKey(uri)){
			throw new ServletException("uri parameter should be part of the mapping configuration");
		}

		Properties schemaMapping = new Properties();
		schemaMapping.load(new FileInputStream(this.config.getSchemaMappingFile()));

		if(ALL_PARAM.equals(type)){
			uriMapping.remove(uri);
			if(schemaMapping.containsKey(uri)){
				String[] schemaFileTokens = schemaMapping.getProperty(uri).split(",");
				for (String schemaFileName : schemaFileTokens) {
					File schemaFile = new File(this.config.getXsdDir(), schemaFileName);
					if (schemaFile.exists()) {
						schemaFile.delete();
						schemaMapping.remove(uri);
					}
				}
				schemaMapping.store(new FileOutputStream(this.config.getSchemaMappingFile()), "deleted mapping for URI " + uri);
			}
			uriMapping.store(new FileOutputStream(this.config.getUriMappingFile()), "deleted mapping for URI " + uri);
		} else {
			String fileNameToDelete = req.getParameter(FILE_PARAM);
			if(StringUtils.isEmpty(fileNameToDelete)){
				throw new ServletException("file parameter should not be null or empty");
			}
			if(schemaMapping.containsKey(uri)){
				List<String> schemaFiles = new LinkedList<String>();
				String[] schemaFileTokens = schemaMapping.getProperty(uri).split(",");
				for(String token : schemaFileTokens){
					schemaFiles.add(token.trim());
				}
				if (schemaFiles.contains(fileNameToDelete)) {
					File schemaFile = new File(this.config.getXsdDir(), fileNameToDelete);
					if (schemaFile.exists()) {
						schemaFile.delete();
					}
					schemaFiles.remove(fileNameToDelete);
					schemaMapping.remove(uri);
					if (!schemaFiles.isEmpty()) {
						Collections.sort(schemaFiles);
						// list as string, removing all blank spaces
						String schemaFileNames = schemaFiles.toString().replaceAll(" ", "");
						// removing [ and ]
						schemaFileNames = schemaFileNames.substring(1, schemaFileNames.length() - 1);
						schemaMapping.put(uri, schemaFileNames);
					}
				}
				schemaMapping.store(new FileOutputStream(this.config.getSchemaMappingFile()), "deleted " + fileNameToDelete + " for URI " + uri);
			}
		}
		resp.sendRedirect(req.getContextPath());
	}

	@Override
	public void init() throws ServletException {
		logger.trace("DeleteServlet.init()");
		this.config = Configuration.getInstance();
	}

}
