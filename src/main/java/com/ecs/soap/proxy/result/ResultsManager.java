package com.ecs.soap.proxy.result;

import java.util.Arrays;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;

import org.apache.log4j.Logger;

import com.ecs.soap.proxy.result.model.CallResult;


public class ResultsManager {

	private static final Logger logger = Logger.getLogger(ResultsManager.class);

	private static ResultsManager instance;

	public static final int MAX_RESULTS_DEFAULT_VALUE = 20;

	public static synchronized ResultsManager getInstance(){
		if(instance == null) instance = new ResultsManager();
		return instance;
	}

	private Queue<CallResult> results;

	private int capacity;

	private ResultsManager(){
		this.capacity = MAX_RESULTS_DEFAULT_VALUE;
		this.results = new ArrayBlockingQueue<CallResult>(capacity);
	}

	public synchronized void addResult(CallResult result){
		if(logger.isDebugEnabled()){
			StringBuilder message = new StringBuilder("adding call result to stat queue :\n");
			message.append(String.valueOf(result));
			logger.debug(message.toString());
		}
		if(this.results.size() == this.capacity){
			this.results.poll();
		}
		this.results.add(result);
	}

	public synchronized List<CallResult> listResults(){
		CallResult[] resultsArray = new CallResult[this.results.size()];
		this.results.toArray(resultsArray);
		return Arrays.asList(resultsArray);

	}

	public synchronized void setCapacity(int capacity){
		if(capacity <= 0){
			throw new IllegalArgumentException("the minimum value for maxResultsSize is 1");
		}
		this.capacity = capacity;
		List<CallResult> currentResults = listResults();
		this.results = new ArrayBlockingQueue<CallResult>(this.capacity);
		this.results.addAll(currentResults);
	}

}
