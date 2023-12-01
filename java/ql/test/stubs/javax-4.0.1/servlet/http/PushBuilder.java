// Generated automatically from javax.servlet.http.PushBuilder for testing purposes

package javax.servlet.http;

import java.util.Set;

public interface PushBuilder
{
    PushBuilder addHeader(String p0, String p1);
    PushBuilder method(String p0);
    PushBuilder path(String p0);
    PushBuilder queryString(String p0);
    PushBuilder removeHeader(String p0);
    PushBuilder sessionId(String p0);
    PushBuilder setHeader(String p0, String p1);
    Set<String> getHeaderNames();
    String getHeader(String p0);
    String getMethod();
    String getPath();
    String getQueryString();
    String getSessionId();
    void push();
}
