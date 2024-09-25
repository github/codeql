// Generated automatically from javax.servlet.http.HttpServletResponse for testing purposes

package javax.servlet.http;

import java.util.Collection;
import java.util.Map;
import java.util.function.Supplier;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;

public interface HttpServletResponse extends ServletResponse
{
    Collection<String> getHeaderNames();
    Collection<String> getHeaders(String p0);
    String encodeRedirectURL(String p0);
    String encodeRedirectUrl(String p0);
    String encodeURL(String p0);
    String encodeUrl(String p0);
    String getHeader(String p0);
    boolean containsHeader(String p0);
    default Supplier<Map<String, String>> getTrailerFields(){ return null; }
    default void setTrailerFields(Supplier<Map<String, String>> p0){}
    int getStatus();
    static int SC_ACCEPTED = 0;
    static int SC_BAD_GATEWAY = 0;
    static int SC_BAD_REQUEST = 0;
    static int SC_CONFLICT = 0;
    static int SC_CONTINUE = 0;
    static int SC_CREATED = 0;
    static int SC_EXPECTATION_FAILED = 0;
    static int SC_FORBIDDEN = 0;
    static int SC_FOUND = 0;
    static int SC_GATEWAY_TIMEOUT = 0;
    static int SC_GONE = 0;
    static int SC_HTTP_VERSION_NOT_SUPPORTED = 0;
    static int SC_INTERNAL_SERVER_ERROR = 0;
    static int SC_LENGTH_REQUIRED = 0;
    static int SC_METHOD_NOT_ALLOWED = 0;
    static int SC_MOVED_PERMANENTLY = 0;
    static int SC_MOVED_TEMPORARILY = 0;
    static int SC_MULTIPLE_CHOICES = 0;
    static int SC_NON_AUTHORITATIVE_INFORMATION = 0;
    static int SC_NOT_ACCEPTABLE = 0;
    static int SC_NOT_FOUND = 0;
    static int SC_NOT_IMPLEMENTED = 0;
    static int SC_NOT_MODIFIED = 0;
    static int SC_NO_CONTENT = 0;
    static int SC_OK = 0;
    static int SC_PARTIAL_CONTENT = 0;
    static int SC_PAYMENT_REQUIRED = 0;
    static int SC_PRECONDITION_FAILED = 0;
    static int SC_PROXY_AUTHENTICATION_REQUIRED = 0;
    static int SC_REQUESTED_RANGE_NOT_SATISFIABLE = 0;
    static int SC_REQUEST_ENTITY_TOO_LARGE = 0;
    static int SC_REQUEST_TIMEOUT = 0;
    static int SC_REQUEST_URI_TOO_LONG = 0;
    static int SC_RESET_CONTENT = 0;
    static int SC_SEE_OTHER = 0;
    static int SC_SERVICE_UNAVAILABLE = 0;
    static int SC_SWITCHING_PROTOCOLS = 0;
    static int SC_TEMPORARY_REDIRECT = 0;
    static int SC_UNAUTHORIZED = 0;
    static int SC_UNSUPPORTED_MEDIA_TYPE = 0;
    static int SC_USE_PROXY = 0;
    void addCookie(Cookie p0);
    void addDateHeader(String p0, long p1);
    void addHeader(String p0, String p1);
    void addIntHeader(String p0, int p1);
    void sendError(int p0);
    void sendError(int p0, String p1);
    void sendRedirect(String p0);
    void setDateHeader(String p0, long p1);
    void setHeader(String p0, String p1);
    void setIntHeader(String p0, int p1);
    void setStatus(int p0);
    void setStatus(int p0, String p1);
}
