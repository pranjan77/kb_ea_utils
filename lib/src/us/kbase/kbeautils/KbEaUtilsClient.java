package us.kbase.kbeautils;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import us.kbase.auth.AuthToken;
import us.kbase.common.service.JsonClientCaller;
import us.kbase.common.service.JsonClientException;
import us.kbase.common.service.RpcContext;
import us.kbase.common.service.UnauthorizedException;

/**
 * <p>Original spec-file module name: kb_ea_utils</p>
 * <pre>
 * Utilities for Reads Processing
 * </pre>
 */
public class KbEaUtilsClient {
    private JsonClientCaller caller;
    private String serviceVersion = null;


    /** Constructs a client with a custom URL and no user credentials.
     * @param url the URL of the service.
     */
    public KbEaUtilsClient(URL url) {
        caller = new JsonClientCaller(url);
    }
    /** Constructs a client with a custom URL.
     * @param url the URL of the service.
     * @param token the user's authorization token.
     * @throws UnauthorizedException if the token is not valid.
     * @throws IOException if an IOException occurs when checking the token's
     * validity.
     */
    public KbEaUtilsClient(URL url, AuthToken token) throws UnauthorizedException, IOException {
        caller = new JsonClientCaller(url, token);
    }

    /** Constructs a client with a custom URL.
     * @param url the URL of the service.
     * @param user the user name.
     * @param password the password for the user name.
     * @throws UnauthorizedException if the credentials are not valid.
     * @throws IOException if an IOException occurs when checking the user's
     * credentials.
     */
    public KbEaUtilsClient(URL url, String user, String password) throws UnauthorizedException, IOException {
        caller = new JsonClientCaller(url, user, password);
    }

    /** Constructs a client with a custom URL
     * and a custom authorization service URL.
     * @param url the URL of the service.
     * @param user the user name.
     * @param password the password for the user name.
     * @param auth the URL of the authorization server.
     * @throws UnauthorizedException if the credentials are not valid.
     * @throws IOException if an IOException occurs when checking the user's
     * credentials.
     */
    public KbEaUtilsClient(URL url, String user, String password, URL auth) throws UnauthorizedException, IOException {
        caller = new JsonClientCaller(url, user, password, auth);
    }

    /** Get the token this client uses to communicate with the server.
     * @return the authorization token.
     */
    public AuthToken getToken() {
        return caller.getToken();
    }

    /** Get the URL of the service with which this client communicates.
     * @return the service URL.
     */
    public URL getURL() {
        return caller.getURL();
    }

    /** Set the timeout between establishing a connection to a server and
     * receiving a response. A value of zero or null implies no timeout.
     * @param milliseconds the milliseconds to wait before timing out when
     * attempting to read from a server.
     */
    public void setConnectionReadTimeOut(Integer milliseconds) {
        this.caller.setConnectionReadTimeOut(milliseconds);
    }

    /** Check if this client allows insecure http (vs https) connections.
     * @return true if insecure connections are allowed.
     */
    public boolean isInsecureHttpConnectionAllowed() {
        return caller.isInsecureHttpConnectionAllowed();
    }

    /** Deprecated. Use isInsecureHttpConnectionAllowed().
     * @deprecated
     */
    public boolean isAuthAllowedForHttp() {
        return caller.isAuthAllowedForHttp();
    }

    /** Set whether insecure http (vs https) connections should be allowed by
     * this client.
     * @param allowed true to allow insecure connections. Default false
     */
    public void setIsInsecureHttpConnectionAllowed(boolean allowed) {
        caller.setInsecureHttpConnectionAllowed(allowed);
    }

    /** Deprecated. Use setIsInsecureHttpConnectionAllowed().
     * @deprecated
     */
    public void setAuthAllowedForHttp(boolean isAuthAllowedForHttp) {
        caller.setAuthAllowedForHttp(isAuthAllowedForHttp);
    }

    /** Set whether all SSL certificates, including self-signed certificates,
     * should be trusted.
     * @param trustAll true to trust all certificates. Default false.
     */
    public void setAllSSLCertificatesTrusted(final boolean trustAll) {
        caller.setAllSSLCertificatesTrusted(trustAll);
    }
    
    /** Check if this client trusts all SSL certificates, including
     * self-signed certificates.
     * @return true if all certificates are trusted.
     */
    public boolean isAllSSLCertificatesTrusted() {
        return caller.isAllSSLCertificatesTrusted();
    }
    /** Sets streaming mode on. In this case, the data will be streamed to
     * the server in chunks as it is read from disk rather than buffered in
     * memory. Many servers are not compatible with this feature.
     * @param streamRequest true to set streaming mode on, false otherwise.
     */
    public void setStreamingModeOn(boolean streamRequest) {
        caller.setStreamingModeOn(streamRequest);
    }

    /** Returns true if streaming mode is on.
     * @return true if streaming mode is on.
     */
    public boolean isStreamingModeOn() {
        return caller.isStreamingModeOn();
    }

    public void _setFileForNextRpcResponse(File f) {
        caller.setFileForNextRpcResponse(f);
    }

    public String getServiceVersion() {
        return this.serviceVersion;
    }

    public void setServiceVersion(String newValue) {
        this.serviceVersion = newValue;
    }

    /**
     * <p>Original spec-file function name: get_fastq_ea_utils_stats</p>
     * <pre>
     * This function should be used for getting statistics on read library object types 
     * The results are returned as a string.
     * </pre>
     * @param   inputParams   instance of type {@link us.kbase.kbeautils.GetFastqEaUtilsStatsParams GetFastqEaUtilsStatsParams} (original type "get_fastq_ea_utils_stats_params")
     * @return   parameter "ea_utils_stats" of String
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public String getFastqEaUtilsStats(GetFastqEaUtilsStatsParams inputParams, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(inputParams);
        TypeReference<List<String>> retType = new TypeReference<List<String>>() {};
        List<String> res = caller.jsonrpcCall("kb_ea_utils.get_fastq_ea_utils_stats", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    /**
     * <p>Original spec-file function name: run_app_fastq_ea_utils_stats</p>
     * <pre>
     * This function should be used for getting statistics on read library object type.
     * The results are returned as a report type object.
     * </pre>
     * @param   inputParams   instance of type {@link us.kbase.kbeautils.RunAppFastqEaUtilsStatsParams RunAppFastqEaUtilsStatsParams} (original type "run_app_fastq_ea_utils_stats_params")
     * @return   parameter "report" of type {@link us.kbase.kbeautils.Report Report}
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public Report runAppFastqEaUtilsStats(RunAppFastqEaUtilsStatsParams inputParams, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(inputParams);
        TypeReference<List<Report>> retType = new TypeReference<List<Report>>() {};
        List<Report> res = caller.jsonrpcCall("kb_ea_utils.run_app_fastq_ea_utils_stats", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    /**
     * <p>Original spec-file function name: get_ea_utils_stats</p>
     * <pre>
     * This function should be used for getting statistics on fastq files. Input is string of file path.
     * Output is a report string.
     * </pre>
     * @param   inputParams   instance of type {@link us.kbase.kbeautils.EaUtilsParams EaUtilsParams} (original type "ea_utils_params")
     * @return   parameter "report" of String
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public String getEaUtilsStats(EaUtilsParams inputParams, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(inputParams);
        TypeReference<List<String>> retType = new TypeReference<List<String>>() {};
        List<String> res = caller.jsonrpcCall("kb_ea_utils.get_ea_utils_stats", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    /**
     * <p>Original spec-file function name: calculate_fastq_stats</p>
     * <pre>
     * This function should be used for getting statistics on fastq files. Input is string of file path.
     * Output is a data structure with different fields.
     * </pre>
     * @param   inputParams   instance of type {@link us.kbase.kbeautils.EaUtilsParams EaUtilsParams} (original type "ea_utils_params")
     * @return   parameter "ea_stats" of type {@link us.kbase.kbeautils.EaReport EaReport} (original type "ea_report")
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public EaReport calculateFastqStats(EaUtilsParams inputParams, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(inputParams);
        TypeReference<List<EaReport>> retType = new TypeReference<List<EaReport>>() {};
        List<EaReport> res = caller.jsonrpcCall("kb_ea_utils.calculate_fastq_stats", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    /**
     * <p>Original spec-file function name: run_Fastq_Multx</p>
     * <pre>
     * </pre>
     * @param   params   instance of type {@link us.kbase.kbeautils.RunFastqMultxInput RunFastqMultxInput} (original type "run_Fastq_Multx_Input")
     * @return   parameter "returnVal" of type {@link us.kbase.kbeautils.RunFastqMultxOutput RunFastqMultxOutput} (original type "run_Fastq_Multx_Output")
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public RunFastqMultxOutput runFastqMultx(RunFastqMultxInput params, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(params);
        TypeReference<List<RunFastqMultxOutput>> retType = new TypeReference<List<RunFastqMultxOutput>>() {};
        List<RunFastqMultxOutput> res = caller.jsonrpcCall("kb_ea_utils.run_Fastq_Multx", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    /**
     * <p>Original spec-file function name: run_Fastq_Join</p>
     * <pre>
     * </pre>
     * @param   params   instance of type {@link us.kbase.kbeautils.RunFastqJoinInput RunFastqJoinInput} (original type "run_Fastq_Join_Input")
     * @return   parameter "returnVal" of type {@link us.kbase.kbeautils.RunFastqJoinOutput RunFastqJoinOutput} (original type "run_Fastq_Join_Output")
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public RunFastqJoinOutput runFastqJoin(RunFastqJoinInput params, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(params);
        TypeReference<List<RunFastqJoinOutput>> retType = new TypeReference<List<RunFastqJoinOutput>>() {};
        List<RunFastqJoinOutput> res = caller.jsonrpcCall("kb_ea_utils.run_Fastq_Join", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    /**
     * <p>Original spec-file function name: exec_Fastq_Join</p>
     * <pre>
     * </pre>
     * @param   params   instance of type {@link us.kbase.kbeautils.RunFastqJoinInput RunFastqJoinInput} (original type "run_Fastq_Join_Input")
     * @return   parameter "returnVal" of type {@link us.kbase.kbeautils.ExecFastqJoinOutput ExecFastqJoinOutput} (original type "exec_Fastq_Join_Output")
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public ExecFastqJoinOutput execFastqJoin(RunFastqJoinInput params, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(params);
        TypeReference<List<ExecFastqJoinOutput>> retType = new TypeReference<List<ExecFastqJoinOutput>>() {};
        List<ExecFastqJoinOutput> res = caller.jsonrpcCall("kb_ea_utils.exec_Fastq_Join", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    /**
     * <p>Original spec-file function name: exec_Fastq_Join_OneLibrary</p>
     * <pre>
     * </pre>
     * @param   params   instance of type {@link us.kbase.kbeautils.RunFastqJoinInput RunFastqJoinInput} (original type "run_Fastq_Join_Input")
     * @return   parameter "returnVal" of type {@link us.kbase.kbeautils.ExecFastqJoinOutput ExecFastqJoinOutput} (original type "exec_Fastq_Join_Output")
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public ExecFastqJoinOutput execFastqJoinOneLibrary(RunFastqJoinInput params, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(params);
        TypeReference<List<ExecFastqJoinOutput>> retType = new TypeReference<List<ExecFastqJoinOutput>>() {};
        List<ExecFastqJoinOutput> res = caller.jsonrpcCall("kb_ea_utils.exec_Fastq_Join_OneLibrary", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    /**
     * <p>Original spec-file function name: exec_Determine_Phred</p>
     * <pre>
     * </pre>
     * @param   params   instance of type {@link us.kbase.kbeautils.ExecDeterminePhredInput ExecDeterminePhredInput} (original type "exec_Determine_Phred_Input")
     * @return   parameter "returnVal" of type {@link us.kbase.kbeautils.ExecDeterminePhredOutput ExecDeterminePhredOutput} (original type "exec_Determine_Phred_Output")
     * @throws IOException if an IO exception occurs
     * @throws JsonClientException if a JSON RPC exception occurs
     */
    public ExecDeterminePhredOutput execDeterminePhred(ExecDeterminePhredInput params, RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        args.add(params);
        TypeReference<List<ExecDeterminePhredOutput>> retType = new TypeReference<List<ExecDeterminePhredOutput>>() {};
        List<ExecDeterminePhredOutput> res = caller.jsonrpcCall("kb_ea_utils.exec_Determine_Phred", args, retType, true, true, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }

    public Map<String, Object> status(RpcContext... jsonRpcContext) throws IOException, JsonClientException {
        List<Object> args = new ArrayList<Object>();
        TypeReference<List<Map<String, Object>>> retType = new TypeReference<List<Map<String, Object>>>() {};
        List<Map<String, Object>> res = caller.jsonrpcCall("kb_ea_utils.status", args, retType, true, false, jsonRpcContext, this.serviceVersion);
        return res.get(0);
    }
}
