// Generated automatically from org.springframework.http.server.RequestPath for testing purposes

package org.springframework.http.server;

import java.net.URI;
import org.springframework.http.server.PathContainer;

public interface RequestPath extends PathContainer
{
    PathContainer contextPath();
    PathContainer pathWithinApplication();
    RequestPath modifyContextPath(String p0);
    static RequestPath parse(String p0, String p1){ return null; }
    static RequestPath parse(URI p0, String p1){ return null; }
}
