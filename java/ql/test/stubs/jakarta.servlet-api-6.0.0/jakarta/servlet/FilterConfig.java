// Generated automatically from jakarta.servlet.FilterConfig for testing purposes

package jakarta.servlet;

import jakarta.servlet.ServletContext;
import java.util.Enumeration;

public interface FilterConfig
{
    Enumeration<String> getInitParameterNames();
    ServletContext getServletContext();
    String getFilterName();
    String getInitParameter(String p0);
}
