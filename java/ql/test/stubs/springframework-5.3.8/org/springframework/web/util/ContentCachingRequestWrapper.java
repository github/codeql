// Generated automatically from org.springframework.web.util.ContentCachingRequestWrapper for testing purposes

package org.springframework.web.util;

import java.io.BufferedReader;
import java.util.Enumeration;
import java.util.Map;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class ContentCachingRequestWrapper extends HttpServletRequestWrapper
{
    protected ContentCachingRequestWrapper() {}
    protected void handleContentOverflow(int p0){}
    public BufferedReader getReader(){ return null; }
    public ContentCachingRequestWrapper(HttpServletRequest p0){}
    public ContentCachingRequestWrapper(HttpServletRequest p0, int p1){}
    public Enumeration<String> getParameterNames(){ return null; }
    public Map<String, String[]> getParameterMap(){ return null; }
    public ServletInputStream getInputStream(){ return null; }
    public String getCharacterEncoding(){ return null; }
    public String getParameter(String p0){ return null; }
    public String[] getParameterValues(String p0){ return null; }
    public byte[] getContentAsByteArray(){ return null; }
}
