// Generated automatically from javax.servlet.ServletContext for testing purposes

package javax.servlet;

import java.io.InputStream;
import java.net.URL;
import java.util.Enumeration;
import java.util.Set;
import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;

public interface ServletContext
{
    Enumeration getAttributeNames();
    Enumeration getInitParameterNames();
    Enumeration getServletNames();
    Enumeration getServlets();
    InputStream getResourceAsStream(String p0);
    Object getAttribute(String p0);
    RequestDispatcher getNamedDispatcher(String p0);
    RequestDispatcher getRequestDispatcher(String p0);
    Servlet getServlet(String p0);
    ServletContext getContext(String p0);
    Set getResourcePaths(String p0);
    String getContextPath();
    String getInitParameter(String p0);
    String getMimeType(String p0);
    String getRealPath(String p0);
    String getServerInfo();
    String getServletContextName();
    URL getResource(String p0);
    int getMajorVersion();
    int getMinorVersion();
    void log(Exception p0, String p1);
    void log(String p0);
    void log(String p0, Throwable p1);
    void removeAttribute(String p0);
    void setAttribute(String p0, Object p1);
}
