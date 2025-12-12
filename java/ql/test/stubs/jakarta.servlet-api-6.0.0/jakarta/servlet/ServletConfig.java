// Generated automatically from jakarta.servlet.ServletConfig for testing purposes

package jakarta.servlet;

import jakarta.servlet.ServletContext;
import java.util.Enumeration;

public interface ServletConfig
{
    Enumeration<String> getInitParameterNames();
    ServletContext getServletContext();
    String getInitParameter(String p0);
    String getServletName();
}
