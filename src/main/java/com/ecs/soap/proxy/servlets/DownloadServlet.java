package com.ecs.soap.proxy.servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.ecs.soap.proxy.config.Configuration;


public class DownloadServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -319343346575670887L;
	
	public static final String servletContextPath = "/download";
	
	public static final String FILE_PARAM = "file";
		
	private static final Logger logger = Logger.getLogger(DownloadServlet.class);
	
	private Configuration config;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String fileName = req.getParameter(FILE_PARAM);
		File file = new File(this.config.getXsdDir(), fileName);
		if(logger.isDebugEnabled()){
			logger.debug("sending file " + file.getAbsolutePath());
		}
		FileInputStream fis = new FileInputStream(file);
		int readed = -1;
		while((readed = fis.read()) != -1){
			resp.getOutputStream().write(readed);
		}
		resp.getOutputStream().close();
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

	@Override
	public void init() throws ServletException {
		logger.trace("DownloadServlet.init()");
		this.config = Configuration.getInstance();
	}

}
