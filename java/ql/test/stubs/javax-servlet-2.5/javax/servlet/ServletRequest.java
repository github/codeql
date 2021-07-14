// Generated automatically from javax.servlet.ServletRequest for testing purposes

package javax.servlet;

import java.io.BufferedReader;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletInputStream;

public interface ServletRequest
{
    BufferedReader getReader();
    Enumeration getAttributeNames();
    Enumeration getLocales();
    Enumeration getParameterNames();
    Locale getLocale();
    Map getParameterMap();
    Object getAttribute(String p0);
    RequestDispatcher getRequestDispatcher(String p0);
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
    boolean isSecure();
    int getContentLength();
    int getLocalPort();
    int getRemotePort();
    int getServerPort();
    void removeAttribute(String p0);
    void setAttribute(String p0, Object p1);
    void setCharacterEncoding(String p0);
}
