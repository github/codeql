// Generated automatically from javax.servlet.Servlet for testing purposes

package javax.servlet;

import javax.servlet.ServletConfig;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public interface Servlet
{
    ServletConfig getServletConfig();
    String getServletInfo();
    void destroy();
    void init(ServletConfig p0);
    void service(ServletRequest p0, ServletResponse p1);
}
