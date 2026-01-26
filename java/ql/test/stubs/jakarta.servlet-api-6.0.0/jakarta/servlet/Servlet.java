// Generated automatically from jakarta.servlet.Servlet for testing purposes

package jakarta.servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

public interface Servlet
{
    ServletConfig getServletConfig();
    String getServletInfo();
    void destroy();
    void init(ServletConfig p0);
    void service(ServletRequest p0, ServletResponse p1);
}
