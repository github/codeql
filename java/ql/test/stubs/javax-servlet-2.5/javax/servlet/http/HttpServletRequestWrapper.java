// Generated automatically from javax.servlet.http.HttpServletRequestWrapper for testing purposes

package javax.servlet.http;

import java.security.Principal;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Map;
import javax.servlet.ServletRequestWrapper;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletMapping;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import javax.servlet.http.PushBuilder;

public class HttpServletRequestWrapper extends ServletRequestWrapper implements HttpServletRequest
{
    protected HttpServletRequestWrapper() {}
    public Collection<Part> getParts(){ return null; }
    public Cookie[] getCookies(){ return null; }
    public Enumeration<String> getHeaderNames(){ return null; }
    public Enumeration<String> getHeaders(String p0){ return null; }
    public HttpServletMapping getHttpServletMapping(){ return null; }
    public HttpServletRequestWrapper(HttpServletRequest p0){}
    public HttpSession getSession(){ return null; }
    public HttpSession getSession(boolean p0){ return null; }
    public Map<String, String> getTrailerFields(){ return null; }
    public Part getPart(String p0){ return null; }
    public Principal getUserPrincipal(){ return null; }
    public PushBuilder newPushBuilder(){ return null; }
    public String changeSessionId(){ return null; }
    public String getAuthType(){ return null; }
    public String getContextPath(){ return null; }
    public String getHeader(String p0){ return null; }
    public String getMethod(){ return null; }
    public String getPathInfo(){ return null; }
    public String getPathTranslated(){ return null; }
    public String getQueryString(){ return null; }
    public String getRemoteUser(){ return null; }
    public String getRequestURI(){ return null; }
    public String getRequestedSessionId(){ return null; }
    public String getServletPath(){ return null; }
    public StringBuffer getRequestURL(){ return null; }
    public boolean authenticate(HttpServletResponse p0){ return false; }
    public boolean isRequestedSessionIdFromCookie(){ return false; }
    public boolean isRequestedSessionIdFromURL(){ return false; }
    public boolean isRequestedSessionIdFromUrl(){ return false; }
    public boolean isRequestedSessionIdValid(){ return false; }
    public boolean isTrailerFieldsReady(){ return false; }
    public boolean isUserInRole(String p0){ return false; }
    public int getIntHeader(String p0){ return 0; }
    public long getDateHeader(String p0){ return 0; }
    public void login(String p0, String p1){}
    public void logout(){}
}
