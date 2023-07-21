// Generated automatically from javax.servlet.ServletResponseWrapper for testing purposes

package javax.servlet;

import java.io.PrintWriter;
import java.util.Locale;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletResponse;

public class ServletResponseWrapper implements ServletResponse
{
    protected ServletResponseWrapper() {}
    public Locale getLocale(){ return null; }
    public PrintWriter getWriter(){ return null; }
    public ServletOutputStream getOutputStream(){ return null; }
    public ServletResponse getResponse(){ return null; }
    public ServletResponseWrapper(ServletResponse p0){}
    public String getCharacterEncoding(){ return null; }
    public String getContentType(){ return null; }
    public boolean isCommitted(){ return false; }
    public boolean isWrapperFor(Class<? extends Object> p0){ return false; }
    public boolean isWrapperFor(ServletResponse p0){ return false; }
    public int getBufferSize(){ return 0; }
    public void flushBuffer(){}
    public void reset(){}
    public void resetBuffer(){}
    public void setBufferSize(int p0){}
    public void setCharacterEncoding(String p0){}
    public void setContentLength(int p0){}
    public void setContentLengthLong(long p0){}
    public void setContentType(String p0){}
    public void setLocale(Locale p0){}
    public void setResponse(ServletResponse p0){}
}
