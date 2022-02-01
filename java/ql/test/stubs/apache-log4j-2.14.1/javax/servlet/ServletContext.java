// Generated automatically from javax.servlet.ServletContext for testing purposes

package javax.servlet;

import java.io.InputStream;
import java.net.URL;
import java.util.Enumeration;
import java.util.EventListener;
import java.util.Map;
import java.util.Set;
import javax.servlet.Filter;
import javax.servlet.FilterRegistration;
import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletRegistration;
import javax.servlet.SessionCookieConfig;
import javax.servlet.SessionTrackingMode;
import javax.servlet.descriptor.JspConfigDescriptor;

public interface ServletContext
{
    <T extends EventListener> T createListener(Class<T> p0);
    <T extends EventListener> void addListener(T p0);
    <T extends Filter> T createFilter(Class<T> p0);
    <T extends Servlet> T createServlet(Class<T> p0);
    ClassLoader getClassLoader();
    Enumeration<Servlet> getServlets();
    Enumeration<String> getAttributeNames();
    Enumeration<String> getInitParameterNames();
    Enumeration<String> getServletNames();
    FilterRegistration getFilterRegistration(String p0);
    FilterRegistration.Dynamic addFilter(String p0, Class<? extends Filter> p1);
    FilterRegistration.Dynamic addFilter(String p0, Filter p1);
    FilterRegistration.Dynamic addFilter(String p0, String p1);
    InputStream getResourceAsStream(String p0);
    JspConfigDescriptor getJspConfigDescriptor();
    Map<String, ? extends FilterRegistration> getFilterRegistrations();
    Map<String, ? extends ServletRegistration> getServletRegistrations();
    Object getAttribute(String p0);
    RequestDispatcher getNamedDispatcher(String p0);
    RequestDispatcher getRequestDispatcher(String p0);
    Servlet getServlet(String p0);
    ServletContext getContext(String p0);
    ServletRegistration getServletRegistration(String p0);
    ServletRegistration.Dynamic addServlet(String p0, Class<? extends Servlet> p1);
    ServletRegistration.Dynamic addServlet(String p0, Servlet p1);
    ServletRegistration.Dynamic addServlet(String p0, String p1);
    SessionCookieConfig getSessionCookieConfig();
    Set<SessionTrackingMode> getDefaultSessionTrackingModes();
    Set<SessionTrackingMode> getEffectiveSessionTrackingModes();
    Set<String> getResourcePaths(String p0);
    String getContextPath();
    String getInitParameter(String p0);
    String getMimeType(String p0);
    String getRealPath(String p0);
    String getServerInfo();
    String getServletContextName();
    String getVirtualServerName();
    URL getResource(String p0);
    boolean setInitParameter(String p0, String p1);
    int getEffectiveMajorVersion();
    int getEffectiveMinorVersion();
    int getMajorVersion();
    int getMinorVersion();
    static String ORDERED_LIBS = null;
    static String TEMPDIR = null;
    void addListener(Class<? extends EventListener> p0);
    void addListener(String p0);
    void declareRoles(String... p0);
    void log(Exception p0, String p1);
    void log(String p0);
    void log(String p0, Throwable p1);
    void removeAttribute(String p0);
    void setAttribute(String p0, Object p1);
    void setSessionTrackingModes(Set<SessionTrackingMode> p0);
}
