// Generated automatically from org.apache.hc.core5.http.Method for testing purposes

package org.apache.hc.core5.http;


public enum Method
{
    CONNECT, DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT, TRACE;
    private Method() {}
    public boolean isIdempotent(){ return false; }
    public boolean isSafe(){ return false; }
    public boolean isSame(String p0){ return false; }
    public static Method normalizedValueOf(String p0){ return null; }
    public static boolean isIdempotent(String p0){ return false; }
    public static boolean isSafe(String p0){ return false; }
}
