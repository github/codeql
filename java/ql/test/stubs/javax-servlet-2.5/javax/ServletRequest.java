// Generated automatically from javax.servlet.ServletRequest for testing purposes

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
import javax.servlet.ServletResponse;

public interface ServletRequest
{
    AsyncContext getAsyncContext();
    AsyncContext startAsync();
    AsyncContext startAsync(ServletRequest p0, ServletResponse p1);
    BufferedReader getReader();
    DispatcherType getDispatcherType();
    Enumeration<Locale> getLocales();
    Enumeration<String> getAttributeNames();
    Enumeration<String> getParameterNames();
    Locale getLocale();
    Map<String, String[]> getParameterMap();
    Object getAttribute(String p0);
    RequestDispatcher getRequestDispatcher(String p0);
    ServletContext getServletContext();
    ServletInputStream getInputStream();
    String getCharacterEncoding();
    String getContentType();
    String getLocalAddr();
    String getLocalName();
    String getParameter(String p0);
    String getProtocol();
    String getRealPath(String p0);
    String getRemoteAddr();
    String getRemoteHost();
    String getScheme();
    String getServerName();
    String[] getParameterValues(String p0);
    boolean isAsyncStarted();
    boolean isAsyncSupported();
    boolean isSecure();
    int getContentLength();
    int getLocalPort();
    int getRemotePort();
    int getServerPort();
    long getContentLengthLong();
    void removeAttribute(String p0);
    void setAttribute(String p0, Object p1);
    void setCharacterEncoding(String p0);
}
