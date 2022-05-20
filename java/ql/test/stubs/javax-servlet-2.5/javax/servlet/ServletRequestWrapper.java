// Generated automatically from javax.servlet.ServletRequestWrapper for testing purposes

package javax.servlet;

import java.io.BufferedReader;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Map;
import javax.servlet.AsyncContext;
import javax.servlet.DispatcherType;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class ServletRequestWrapper implements ServletRequest
{
    protected ServletRequestWrapper() {}
    public AsyncContext getAsyncContext(){ return null; }
    public AsyncContext startAsync(){ return null; }
    public AsyncContext startAsync(ServletRequest p0, ServletResponse p1){ return null; }
    public BufferedReader getReader(){ return null; }
    public DispatcherType getDispatcherType(){ return null; }
    public Enumeration<Locale> getLocales(){ return null; }
    public Enumeration<String> getAttributeNames(){ return null; }
    public Enumeration<String> getParameterNames(){ return null; }
    public Locale getLocale(){ return null; }
    public Map<String, String[]> getParameterMap(){ return null; }
    public Object getAttribute(String p0){ return null; }
    public RequestDispatcher getRequestDispatcher(String p0){ return null; }
    public ServletContext getServletContext(){ return null; }
    public ServletInputStream getInputStream(){ return null; }
    public ServletRequest getRequest(){ return null; }
    public ServletRequestWrapper(ServletRequest p0){}
    public String getCharacterEncoding(){ return null; }
    public String getContentType(){ return null; }
    public String getLocalAddr(){ return null; }
    public String getLocalName(){ return null; }
    public String getParameter(String p0){ return null; }
    public String getProtocol(){ return null; }
    public String getRealPath(String p0){ return null; }
    public String getRemoteAddr(){ return null; }
    public String getRemoteHost(){ return null; }
    public String getScheme(){ return null; }
    public String getServerName(){ return null; }
    public String[] getParameterValues(String p0){ return null; }
    public boolean isAsyncStarted(){ return false; }
    public boolean isAsyncSupported(){ return false; }
    public boolean isSecure(){ return false; }
    public boolean isWrapperFor(Class<? extends Object> p0){ return false; }
    public boolean isWrapperFor(ServletRequest p0){ return false; }
    public int getContentLength(){ return 0; }
    public int getLocalPort(){ return 0; }
    public int getRemotePort(){ return 0; }
    public int getServerPort(){ return 0; }
    public long getContentLengthLong(){ return 0; }
    public void removeAttribute(String p0){}
    public void setAttribute(String p0, Object p1){}
    public void setCharacterEncoding(String p0){}
    public void setRequest(ServletRequest p0){}
}
