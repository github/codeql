// Generated automatically from jakarta.servlet.http.HttpSession for testing purposes

package jakarta.servlet.http;

import jakarta.servlet.ServletContext;
import java.util.Enumeration;

public interface HttpSession
{
    Enumeration<String> getAttributeNames();
    Object getAttribute(String p0);
    ServletContext getServletContext();
    String getId();
    boolean isNew();
    int getMaxInactiveInterval();
    long getCreationTime();
    long getLastAccessedTime();
    void invalidate();
    void removeAttribute(String p0);
    void setAttribute(String p0, Object p1);
    void setMaxInactiveInterval(int p0);
}
