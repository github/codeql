// Generated automatically from jakarta.servlet.ServletResponse for testing purposes

package jakarta.servlet;

import jakarta.servlet.ServletOutputStream;
import java.io.PrintWriter;
import java.util.Locale;

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
