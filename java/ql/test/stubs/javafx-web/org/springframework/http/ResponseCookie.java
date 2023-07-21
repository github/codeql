// Generated automatically from org.springframework.http.ResponseCookie for testing purposes

package org.springframework.http;

import java.time.Duration;
import org.springframework.http.HttpCookie;

public class ResponseCookie extends HttpCookie
{
    protected ResponseCookie() {}
    public Duration getMaxAge(){ return null; }
    public String getDomain(){ return null; }
    public String getPath(){ return null; }
    public String getSameSite(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isHttpOnly(){ return false; }
    public boolean isSecure(){ return false; }
    public int hashCode(){ return 0; }
    public static ResponseCookie.ResponseCookieBuilder from(String p0, String p1){ return null; }
    public static ResponseCookie.ResponseCookieBuilder fromClientResponse(String p0, String p1){ return null; }
    static public interface ResponseCookieBuilder
    {
        ResponseCookie build();
        ResponseCookie.ResponseCookieBuilder domain(String p0);
        ResponseCookie.ResponseCookieBuilder httpOnly(boolean p0);
        ResponseCookie.ResponseCookieBuilder maxAge(Duration p0);
        ResponseCookie.ResponseCookieBuilder maxAge(long p0);
        ResponseCookie.ResponseCookieBuilder path(String p0);
        ResponseCookie.ResponseCookieBuilder sameSite(String p0);
        ResponseCookie.ResponseCookieBuilder secure(boolean p0);
    }
}
