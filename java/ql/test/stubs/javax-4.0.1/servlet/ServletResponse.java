// Generated automatically from javax.servlet.ServletResponse for testing purposes

package javax.servlet;

import java.io.PrintWriter;
import java.util.Locale;
import javax.servlet.ServletOutputStream;

public interface ServletResponse
{
    Locale getLocale();
    PrintWriter getWriter();
    ServletOutputStream getOutputStream();
    String getCharacterEncoding();
    String getContentType();
    boolean isCommitted();
    int getBufferSize();
    void flushBuffer();
    void reset();
    void resetBuffer();
    void setBufferSize(int p0);
    void setCharacterEncoding(String p0);
    void setContentLength(int p0);
    void setContentLengthLong(long p0);
    void setContentType(String p0);
    void setLocale(Locale p0);
}
