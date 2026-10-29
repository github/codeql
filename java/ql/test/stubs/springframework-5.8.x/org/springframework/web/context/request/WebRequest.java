// Generated automatically from org.springframework.web.context.request.WebRequest for testing purposes

package org.springframework.web.context.request;

import java.security.Principal;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import org.springframework.web.context.request.RequestAttributes;

public interface WebRequest extends RequestAttributes
{
    Iterator<String> getHeaderNames();
    Iterator<String> getParameterNames();
    Locale getLocale();
    Map<String, String[]> getParameterMap();
    Principal getUserPrincipal();
    String getContextPath();
    String getDescription(boolean p0);
    String getHeader(String p0);
    String getParameter(String p0);
    String getRemoteUser();
    String[] getHeaderValues(String p0);
    String[] getParameterValues(String p0);
    boolean checkNotModified(String p0);
    boolean checkNotModified(String p0, long p1);
    boolean checkNotModified(long p0);
    boolean isSecure();
    boolean isUserInRole(String p0);
}
