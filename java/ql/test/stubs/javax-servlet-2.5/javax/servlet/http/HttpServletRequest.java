// Generated automatically from javax.servlet.http.HttpServletRequest for testing purposes

package javax.servlet.http;

import java.security.Principal;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Map;
import javax.servlet.ServletRequest;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletMapping;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import javax.servlet.http.PushBuilder;

public interface HttpServletRequest extends ServletRequest
{
    Collection<Part> getParts();
    Cookie[] getCookies();
    Enumeration<String> getHeaderNames();
    Enumeration<String> getHeaders(String p0);
    HttpSession getSession();
    HttpSession getSession(boolean p0);
    Part getPart(String p0);
    Principal getUserPrincipal();
    String changeSessionId();
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
    boolean authenticate(HttpServletResponse p0);
    boolean isRequestedSessionIdFromCookie();
    boolean isRequestedSessionIdFromURL();
    boolean isRequestedSessionIdFromUrl();
    boolean isRequestedSessionIdValid();
    boolean isUserInRole(String p0);
    default HttpServletMapping getHttpServletMapping(){ return null; }
    default Map<String, String> getTrailerFields(){ return null; }
    default PushBuilder newPushBuilder(){ return null; }
    default boolean isTrailerFieldsReady(){ return false; }
    int getIntHeader(String p0);
    long getDateHeader(String p0);
    static String BASIC_AUTH = null;
    static String CLIENT_CERT_AUTH = null;
    static String DIGEST_AUTH = null;
    static String FORM_AUTH = null;
    void login(String p0, String p1);
    void logout();
}
