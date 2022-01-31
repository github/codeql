// Generated automatically from javax.servlet.http.HttpSession for testing purposes

package javax.servlet.http;

import java.util.Enumeration;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSessionContext;

public interface HttpSession
{
    Enumeration<String> getAttributeNames();
    HttpSessionContext getSessionContext();
    Object getAttribute(String p0);
    Object getValue(String p0);
    ServletContext getServletContext();
    String getId();
    String[] getValueNames();
    boolean isNew();
    int getMaxInactiveInterval();
    long getCreationTime();
    long getLastAccessedTime();
    void invalidate();
    void putValue(String p0, Object p1);
    void removeAttribute(String p0);
    void removeValue(String p0);
    void setAttribute(String p0, Object p1);
    void setMaxInactiveInterval(int p0);
}
