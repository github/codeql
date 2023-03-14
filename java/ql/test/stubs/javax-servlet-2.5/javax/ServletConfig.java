// Generated automatically from javax.servlet.ServletConfig for testing purposes

package javax.servlet;

import java.util.Enumeration;
import javax.servlet.ServletContext;

public interface ServletConfig
{
    Enumeration<String> getInitParameterNames();
    ServletContext getServletContext();
    String getInitParameter(String p0);
    String getServletName();
}
