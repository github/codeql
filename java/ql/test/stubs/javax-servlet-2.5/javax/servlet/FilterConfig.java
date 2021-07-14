// Generated automatically from javax.servlet.FilterConfig for testing purposes

package javax.servlet;

import java.util.Enumeration;
import javax.servlet.ServletContext;

public interface FilterConfig
{
    Enumeration<String> getInitParameterNames();
    ServletContext getServletContext();
    String getFilterName();
    String getInitParameter(String p0);
}
