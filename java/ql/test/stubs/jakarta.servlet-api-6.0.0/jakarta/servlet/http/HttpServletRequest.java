// Generated automatically from jakarta.servlet.http.HttpServletRequest for testing purposes

package jakarta.servlet.http;

import jakarta.servlet.ServletRequest;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletMapping;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpUpgradeHandler;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.PushBuilder;
import java.security.Principal;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Map;

public interface HttpServletRequest extends ServletRequest
{
    <T extends HttpUpgradeHandler> T upgrade(java.lang.Class<T> p0);
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
