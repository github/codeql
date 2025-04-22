// Generated automatically from org.springframework.http.HttpStatus for testing purposes

package org.springframework.http;


public enum HttpStatus
{
    ACCEPTED, ALREADY_REPORTED, BAD_GATEWAY, BAD_REQUEST, BANDWIDTH_LIMIT_EXCEEDED, CHECKPOINT, CONFLICT, CONTINUE, CREATED, DESTINATION_LOCKED, EXPECTATION_FAILED, FAILED_DEPENDENCY, FORBIDDEN, FOUND, GATEWAY_TIMEOUT, GONE, HTTP_VERSION_NOT_SUPPORTED, IM_USED, INSUFFICIENT_SPACE_ON_RESOURCE, INSUFFICIENT_STORAGE, INTERNAL_SERVER_ERROR, I_AM_A_TEAPOT, LENGTH_REQUIRED, LOCKED, LOOP_DETECTED, METHOD_FAILURE, METHOD_NOT_ALLOWED, MOVED_PERMANENTLY, MOVED_TEMPORARILY, MULTIPLE_CHOICES, MULTI_STATUS, NETWORK_AUTHENTICATION_REQUIRED, NON_AUTHORITATIVE_INFORMATION, NOT_ACCEPTABLE, NOT_EXTENDED, NOT_FOUND, NOT_IMPLEMENTED, NOT_MODIFIED, NO_CONTENT, OK, PARTIAL_CONTENT, PAYLOAD_TOO_LARGE, PAYMENT_REQUIRED, PERMANENT_REDIRECT, PRECONDITION_FAILED, PRECONDITION_REQUIRED, PROCESSING, PROXY_AUTHENTICATION_REQUIRED, REQUESTED_RANGE_NOT_SATISFIABLE, REQUEST_ENTITY_TOO_LARGE, REQUEST_HEADER_FIELDS_TOO_LARGE, REQUEST_TIMEOUT, REQUEST_URI_TOO_LONG, RESET_CONTENT, SEE_OTHER, SERVICE_UNAVAILABLE, SWITCHING_PROTOCOLS, TEMPORARY_REDIRECT, TOO_EARLY, TOO_MANY_REQUESTS, UNAUTHORIZED, UNAVAILABLE_FOR_LEGAL_REASONS, UNPROCESSABLE_ENTITY, UNSUPPORTED_MEDIA_TYPE, UPGRADE_REQUIRED, URI_TOO_LONG, USE_PROXY, VARIANT_ALSO_NEGOTIATES;
    private HttpStatus() {}
    public HttpStatus.Series series(){ return null; }
    public String getReasonPhrase(){ return null; }
    public String toString(){ return null; }
    public boolean is1xxInformational(){ return false; }
    public boolean is2xxSuccessful(){ return false; }
    public boolean is3xxRedirection(){ return false; }
    public boolean is4xxClientError(){ return false; }
    public boolean is5xxServerError(){ return false; }
    public boolean isError(){ return false; }
    public int value(){ return 0; }
    public static HttpStatus resolve(int p0){ return null; }
    static public enum Series
    {
        CLIENT_ERROR, INFORMATIONAL, REDIRECTION, SERVER_ERROR, SUCCESSFUL;
        private Series() {}
        public int value(){ return 0; }
        public static HttpStatus.Series resolve(int p0){ return null; }
    }
}
