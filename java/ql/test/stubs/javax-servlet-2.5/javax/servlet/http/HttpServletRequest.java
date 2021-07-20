// Generated automatically from javax.servlet.http.HttpServletRequest for testing purposes

package javax.servlet.http;

import java.security.Principal;
import java.util.Enumeration;
import javax.servlet.ServletRequest;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;

public interface HttpServletRequest extends ServletRequest
{
    Cookie[] getCookies();
    Enumeration getHeaderNames();
    Enumeration getHeaders(String p0);
    HttpSession getSession();
    HttpSession getSession(boolean p0);
    Principal getUserPrincipal();
    String getAuthType();
    String getContextPath();
    String getHeader(String p0);
    String getMethod();
    String getPathInfo();
    String getPathTranslated();
    String getQueryString();
    String getRemoteUser();
    String getRequestURI();
    String getRequestedSessionId();
    String getServletPath();
    StringBuffer getRequestURL();
    boolean isRequestedSessionIdFromCookie();
    boolean isRequestedSessionIdFromURL();
    boolean isRequestedSessionIdFromUrl();
    boolean isRequestedSessionIdValid();
    boolean isUserInRole(String p0);
    int getIntHeader(String p0);
    long getDateHeader(String p0);
    static String BASIC_AUTH = null;
    static String CLIENT_CERT_AUTH = null;
    static String DIGEST_AUTH = null;
    static String FORM_AUTH = null;
}
