package com.ecs.soap.proxy.result.model;

import java.io.PrintWriter;
import java.io.Serializable;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

public class CallResult implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = 2517063006178014611L;

	public static enum Status {
		OK,KO
	}

	private String uri;

	private Status requestStatus;

	private Status responseStatus;

	private String soapRequest;

	private String soapResponse;

	private Date timestamp;

	private List<String> requestDetailedErrors;

	private List<String> responseDetailedErrors;

	public CallResult(String uri){
		this.timestamp = new Date();
		this.uri = uri;
		this.requestStatus = Status.OK;
		this.responseStatus = Status.OK;
		this.requestDetailedErrors = new LinkedList<String>();
		this.responseDetailedErrors = new LinkedList<String>();
	}

	@Override
	public String toString(){
		StringBuilder s = new StringBuilder("CallResult: ");
		s.append("uri=" + this.uri);
		s.append(", ");
		s.append("requestStatus=" + this.requestStatus);
		s.append(", ");
		s.append("responseStatus=" + this.responseStatus);
		return s.toString();
	}

	public String getFormattedTimestamp(){
		return new SimpleDateFormat("dd/MM/yyyy HH:mm:ss,SSS").format(this.timestamp);
	}

	public String getUri() {
		return uri;
	}

	public void setUri(String uri) {
		this.uri = uri;
	}

	public String getSoapRequest() {
		return soapRequest;
	}

	public void setSoapRequest(String soapRequest) {
		this.soapRequest = soapRequest;
	}

	public String getSoapResponse() {
		return soapResponse;
	}

	public void setSoapResponse(String soapResponse) {
		this.soapResponse = soapResponse;
	}

	public List<String> getRequestDetailedErrors() {
		return requestDetailedErrors;
	}

	public List<String> getResponseDetailedErrors() {
		return responseDetailedErrors;
	}

	public void addRequestDetailedError(Exception e){
		StringWriter sWriter = new StringWriter();
		PrintWriter pWriter = new PrintWriter(sWriter);
		e.printStackTrace(pWriter);
		pWriter.close();
		addRequestDetailedError(sWriter.toString());
	}

	public void addResponseDetailedError(Exception e){
		StringWriter sWriter = new StringWriter();
		PrintWriter pWriter = new PrintWriter(sWriter);
		e.printStackTrace(pWriter);
		pWriter.close();
		addResponseDetailedError(sWriter.toString());
	}

	public void addRequestDetailedError(String detailedError) {
		this.requestDetailedErrors.add(detailedError);
	}

	public void addResponseDetailedError(String detailedError) {
		this.responseDetailedErrors.add(detailedError);
	}

	public Date getTimestamp() {
		return timestamp;
	}

	public Status getRequestStatus() {
		return requestStatus;
	}

	public void setRequestStatus(Status requestStatus) {
		this.requestStatus = requestStatus;
	}

	public Status getResponseStatus() {
		return responseStatus;
	}

	public void setResponseStatus(Status responseStatus) {
		this.responseStatus = responseStatus;
	}

}
