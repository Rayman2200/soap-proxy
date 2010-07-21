package com.ecs.soap.proxy.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.ecs.soap.proxy.result.ResultsManager;
import com.ecs.soap.proxy.result.model.CallResult;


public class ResultsServlet extends HttpServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = -22675239548402698L;

	private static Logger logger = Logger.getLogger(ResultsServlet.class);

	public static final String servletContextPath = "/results";

	public static final String MAX_RESULTS_PARAM_NAME = "max-results";

	public static final String RESULTS_ATT = "stats";

	public static final String SHOW_PARAM = "show";

	public static final String INDEX_PARAM = "index";
	
	public static final String CLEAR_PARAM = "clear";

	public static final String REQUEST_ERRORS_VALUE = "request_errors";

	public static final String RESPONSE_ERRORS_VALUE = "response_errors";

	public static final String REQUEST_VALUE = "req";

	public static final String RESPONSE_VALUE = "resp";

	private ResultsManager resultsManager;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String clear = req.getParameter(CLEAR_PARAM);
		if(!StringUtils.isEmpty(clear) && clear.equals("all")){
			this.resultsManager.clear();
		}
		
		List<CallResult> stats = this.resultsManager.listResults();
		req.setAttribute(RESULTS_ATT, stats);
		if(req.getSession().getAttribute(RESULTS_ATT) != null){
			req.getSession().removeAttribute(RESULTS_ATT);
		}
		req.getSession().setAttribute(RESULTS_ATT, stats);
		String outputJsp = "/WEB-INF/jsp/results.jsp";
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(outputJsp);
		dispatcher.forward(req, resp);
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		List<CallResult> stats = (List<CallResult>) req.getSession().getAttribute(RESULTS_ATT);
		if(stats == null || stats.isEmpty()){
			throw new ServletException("no results yes");
		}

		String show = req.getParameter(SHOW_PARAM);
		String indexAsString = req.getParameter(INDEX_PARAM);
		if(logger.isDebugEnabled()){
			logger.debug("show=" + show);
			logger.debug("index=" + indexAsString);
		}
		if(StringUtils.isEmpty(indexAsString)){
			throw new ServletException("index parameter should not be null of empty");
		}
		int index = -1;
		try {
			index = Integer.parseInt(indexAsString);
		} catch (NumberFormatException e){
			throw new ServletException(e);
		}

		if(index > stats.size() - 1){
			throw new ServletException("index " + index + " is out of bounds for current stats");
		}

		if(StringUtils.isEmpty(show)){
			throw new ServletException("show parameter should not be null of empty");
		}
		CallResult result = stats.get(index);
		if(result == null){
			throw new ServletException("the result at index " + index + " is null");
		}

		if(show.equals(REQUEST_ERRORS_VALUE)){
			resp.setContentType("text");
			List<String> errors = result.getRequestDetailedErrors();
			if(errors.isEmpty()){
				resp.getOutputStream().write("no errors".getBytes());
				resp.getOutputStream().close();
				return;
			} else {
				for(String error : errors){
					resp.getOutputStream().write(error.getBytes());
					resp.getOutputStream().write("\n-\n".getBytes());
				}
				resp.getOutputStream().close();
				return;
			}
		} if(show.equals(RESPONSE_ERRORS_VALUE)){
			resp.setContentType("text");
			List<String> errors = result.getResponseDetailedErrors();
			if(errors.isEmpty()){
				resp.getOutputStream().write("no errors".getBytes());
				resp.getOutputStream().close();
				return;
			} else {
				for(String error : errors){
					resp.getOutputStream().write(error.getBytes());
					resp.getOutputStream().write("\n-\n".getBytes());
				}
				resp.getOutputStream().close();
				return;
			}
		} else if(show.equals(REQUEST_VALUE)){
			resp.setContentType("text/xml");
			String soapRequest = result.getSoapRequest();
			resp.getOutputStream().write(soapRequest.getBytes());
			resp.getOutputStream().close();
			return;
		} else if(show.equals(RESPONSE_VALUE)){
			resp.setContentType("text/xml");
			String soapResponse = result.getSoapResponse();
			resp.getOutputStream().write(soapResponse.getBytes());
			resp.getOutputStream().close();
			return;
		} else {
			throw new ServletException(show + " is not a valid value for parameter show");
		}
	}

	@Override
	public void init() throws ServletException {
		logger.trace("ResultsServlet.init()");
		ServletConfig config = getServletConfig();
		this.resultsManager = ResultsManager.getInstance();
		String maxResultsSizeAsString = config.getInitParameter(MAX_RESULTS_PARAM_NAME);
		logger.debug("init param " + MAX_RESULTS_PARAM_NAME + " = " + maxResultsSizeAsString);
		try {
			int maxResultsSize = Integer.parseInt(maxResultsSizeAsString);
			logger.info("setting maxResultsSize to " + maxResultsSize);
			this.resultsManager.setCapacity(maxResultsSize);
		} catch (Exception e){
			logger.warn("wrong value " + maxResultsSizeAsString + " for maxResultsSize param, using default value (" + ResultsManager.MAX_RESULTS_DEFAULT_VALUE + ")", e);
		}

	}



}
