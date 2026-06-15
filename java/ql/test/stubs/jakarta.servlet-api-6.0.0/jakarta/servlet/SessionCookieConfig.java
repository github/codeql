// Generated automatically from jakarta.servlet.SessionCookieConfig for testing purposes

package jakarta.servlet;

import java.util.Map;

public interface SessionCookieConfig
{
    Map<String, String> getAttributes();
    String getAttribute(String p0);
    String getComment();
    String getDomain();
    String getName();
    String getPath();
    boolean isHttpOnly();
    boolean isSecure();
    int getMaxAge();
    void setAttribute(String p0, String p1);
    void setComment(String p0);
    void setDomain(String p0);
    void setHttpOnly(boolean p0);
    void setMaxAge(int p0);
    void setName(String p0);
    void setPath(String p0);
    void setSecure(boolean p0);
}
