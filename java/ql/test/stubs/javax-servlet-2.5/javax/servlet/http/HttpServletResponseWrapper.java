// Generated automatically from javax.servlet.http.HttpServletResponseWrapper for testing purposes

package javax.servlet.http;

import java.util.Collection;
import java.util.Map;
import java.util.function.Supplier;
import javax.servlet.ServletResponseWrapper;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

public class HttpServletResponseWrapper extends ServletResponseWrapper implements HttpServletResponse
{
    protected HttpServletResponseWrapper() {}
    public Collection<String> getHeaderNames(){ return null; }
    public Collection<String> getHeaders(String p0){ return null; }
    public HttpServletResponseWrapper(HttpServletResponse p0){}
    public String encodeRedirectURL(String p0){ return null; }
    public String encodeRedirectUrl(String p0){ return null; }
    public String encodeURL(String p0){ return null; }
    public String encodeUrl(String p0){ return null; }
    public String getHeader(String p0){ return null; }
    public Supplier<Map<String, String>> getTrailerFields(){ return null; }
    public boolean containsHeader(String p0){ return false; }
    public int getStatus(){ return 0; }
    public void addCookie(Cookie p0){}
    public void addDateHeader(String p0, long p1){}
    public void addHeader(String p0, String p1){}
    public void addIntHeader(String p0, int p1){}
    public void sendError(int p0){}
    public void sendError(int p0, String p1){}
    public void sendRedirect(String p0){}
    public void setDateHeader(String p0, long p1){}
    public void setHeader(String p0, String p1){}
    public void setIntHeader(String p0, int p1){}
    public void setStatus(int p0){}
    public void setStatus(int p0, String p1){}
    public void setTrailerFields(Supplier<Map<String, String>> p0){}
}
