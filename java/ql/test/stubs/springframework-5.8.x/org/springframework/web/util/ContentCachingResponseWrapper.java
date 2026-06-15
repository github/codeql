// Generated automatically from org.springframework.web.util.ContentCachingResponseWrapper for testing purposes

package org.springframework.web.util;

import java.io.InputStream;
import java.io.PrintWriter;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

public class ContentCachingResponseWrapper extends HttpServletResponseWrapper
{
    protected ContentCachingResponseWrapper() {}
    protected void copyBodyToResponse(boolean p0){}
    public ContentCachingResponseWrapper(HttpServletResponse p0){}
    public InputStream getContentInputStream(){ return null; }
    public PrintWriter getWriter(){ return null; }
    public ServletOutputStream getOutputStream(){ return null; }
    public byte[] getContentAsByteArray(){ return null; }
    public int getContentSize(){ return 0; }
    public int getStatusCode(){ return 0; }
    public void copyBodyToResponse(){}
    public void flushBuffer(){}
    public void reset(){}
    public void resetBuffer(){}
    public void sendError(int p0){}
    public void sendError(int p0, String p1){}
    public void sendRedirect(String p0){}
    public void setBufferSize(int p0){}
    public void setContentLength(int p0){}
    public void setContentLengthLong(long p0){}
}
