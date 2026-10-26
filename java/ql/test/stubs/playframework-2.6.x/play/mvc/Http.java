package play.mvc;

import akka.util.ByteString;
import com.fasterxml.jackson.databind.JsonNode;
import java.io.File;
import java.net.URI;
import java.security.cert.X509Certificate;
import java.time.Duration;
import java.util.*;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import play.core.j.JavaContextComponents;
import play.i18n.Lang;
import play.i18n.Langs;
import play.i18n.Messages;
import play.i18n.MessagesApi;
import play.libs.Files;
import play.libs.typedmap.TypedKey;
import play.libs.typedmap.TypedMap;
import play.mvc.Http.Cookie.SameSite;

public class Http {

  public static class Context {

    public static ThreadLocal<Context> current = new ThreadLocal<>();

    public static Context current() {
      return null;
    }

    public Context(RequestBuilder requestBuilder, JavaContextComponents components) {}

    public Context(Request request, JavaContextComponents components) {}

    public Context(Long id, play.api.mvc.RequestHeader header, Request request,
        Map<String, String> sessionData, Map<String, String> flashData, Map<String, Object> args,
        JavaContextComponents components) {}

    public Context(Long id, play.api.mvc.RequestHeader header, Request request, Response response,
        Session session, Flash flash, Map<String, Object> args, JavaContextComponents components) {}

    public Long id() {
      return 0L;
    }

    public Request request() {
      return null;
    }

    public Response response() {
      return null;
    }

    public Session session() {
      return null;
    }

    public Flash flash() {
      return null;
    }

    public play.api.mvc.RequestHeader _requestHeader() {
      return null;
    }

    public Lang lang() {
      return null;
    }

    public Messages messages() {
      return null;
    }

    public boolean changeLang(String code) {
      return true;
    }

    public boolean changeLang(Lang lang) {
      return true;
    }

    public void clearLang() {}

    private Langs langs() {
      return null;
    }

    private MessagesApi messagesApi() {
      return null;
    }

    private String sessionPath() {
      return "";
    }

    public void setTransientLang(String code) {}

    public void setTransientLang(Lang lang) {}

    public void clearTransientLang() {}

    public Map<String, Object> args;

    public static class Implicit {

      public static Response response() {
        return null;
      }

      public static Request request() {
        return null;
      }

      public static Flash flash() {
        return null;
      }

      public static Session session() {
        return null;
      }

      public static Lang lang() {
        return null;
      }

      public static Messages messages() {
        return null;
      }

      public static Context ctx() {
        return null;
      }
    }

    public String toString() {
      return "";
    }

    public Context withRequest(Request request) {
      return null;
    }
  }

  public static class Headers {

    public Headers(Map<String, List<String>> headers) {}

    public Map<String, List<String>> toMap() {
      return null;
    }

    public boolean contains(String headerName) {
      return true;
    }

    public Optional<String> get(String name) {
      return null;
    }

    public List<String> getAll(String name) {
      return null;
    }

    public Headers addHeader(String name, String value) {
      return null;
    }

    public Headers addHeader(String name, List<String> values) {
      return null;
    }

    public Headers remove(String name) {
      return null;
    }
  }

  public interface RequestHeader {

    String uri();

    String method();

    String version();

    String remoteAddress();

    boolean secure();

    TypedMap attrs();

    RequestHeader withAttrs(TypedMap newAttrs);

    <A> RequestHeader addAttr(TypedKey<A> key, A value);

    Request withBody(RequestBody body);

    String host();

    String path();

    List<play.i18n.Lang> acceptLanguages();

    boolean accepts(String mimeType);

    Map<String, String[]> queryString();

    String getQueryString(String key);

    Cookies cookies();

    Cookie cookie(String name);

    Headers getHeaders();

    @Deprecated
    default Map<String, String[]> headers() {
      return null;
    }

    @Deprecated
    default String getHeader(String headerName) {
      return "";
    }

    default Optional<String> header(String headerName) {
      return null;
    }

    default boolean hasHeader(String headerName) {
      return true;
    }

    boolean hasBody();

    Optional<String> contentType();

    Optional<String> charset();

    Optional<List<X509Certificate>> clientCertificateChain();

    @Deprecated
    Map<String, String> tags();
  }

  public interface Request extends RequestHeader {

    RequestBody body();

    Request withBody(RequestBody body);

    Request withAttrs(TypedMap newAttrs);

    <A> Request addAttr(TypedKey<A> key, A value);

    @Deprecated
    String username();

    @Deprecated
    Request withUsername(String username);
  }

  public static class RequestImpl extends play.core.j.RequestImpl {

    public RequestImpl(play.api.mvc.RequestHeader header) {}

    public RequestImpl(play.api.mvc.Request<RequestBody> request) {}
  }

  public static class RequestBuilder {

    public RequestBuilder() {}

    public RequestBody body() {
      return null;
    }

    @Deprecated
    public String username() {
      return "";
    }

    @Deprecated
    public RequestBuilder username(String username) {
      return null;
    }

    protected RequestBuilder body(RequestBody body, String contentType) {
      return null;
    }

    protected RequestBuilder body(RequestBody body) {
      return null;
    }

    public RequestBuilder bodyRaw(String data) {
      return null;
    }

    public RequestBuilder bodyRaw(String data, Files.TemporaryFileCreator tempFileCreator) {
      return null;
    }

    public RequestBuilder bodyRaw(byte[] data) {
      return null;
    }

    public RequestBuilder bodyRaw(byte[] data, Files.TemporaryFileCreator tempFileCreator) {
      return null;
    }

    public RequestBuilder bodyFormArrayValues(Map<String, String[]> data) {
      return null;
    }

    public RequestBuilder bodyForm(Map<String, String> data) {
      return null;
    }

    public RequestBuilder bodyMultipart(List<String> data,
        Files.TemporaryFileCreator temporaryFileCreator, String mat) {
      return null;
    }

    public RequestBuilder bodyJson(JsonNode node) {
      return null;
    }

    public RequestBuilder bodyJson(String json) {
      return null;
    }

    public RequestBuilder bodyXml(InputSource xml) {
      return null;
    }

    public RequestBuilder bodyXml(Document xml) {
      return null;
    }

    public RequestBuilder bodyText(String text) {
      return null;
    }

    public RequestImpl build() {
      return null;
    }

    public Long id() {
      return 0L;
    }

    public RequestBuilder id(Long id) {
      return null;
    }

    public <T> RequestBuilder attr(TypedKey<T> key, T value) {
      return null;
    }

    public RequestBuilder attrs(TypedMap newAttrs) {
      return null;
    }

    public TypedMap attrs() {
      return null;
    }

    @Deprecated
    public Map<String, String> tags() {
      return null;
    }

    @Deprecated
    public RequestBuilder tags(Map<String, String> tags) {
      return null;
    }

    @Deprecated
    public RequestBuilder tag(String key, String value) {
      return null;
    }

    public String method() {
      return "";
    }

    public RequestBuilder method(String method) {
      return null;
    }

    public String uri() {
      return "";
    }

    public RequestBuilder uri(URI uri) {
      return null;
    }

    public RequestBuilder uri(String str) {
      return null;
    }

    public RequestBuilder secure(boolean secure) {
      return null;
    }

    public boolean secure() {
      return true;
    }

    public String host() {
      return "";
    }

    public RequestBuilder host(String host) {
      return null;
    }

    public String path() {
      return "";
    }

    public RequestBuilder path(String path) {
      return null;
    }

    public String version() {
      return "";
    }

    public RequestBuilder version(String version) {
      return null;
    }

    @Deprecated
    public String header(String key) {
      return "";
    }

    @Deprecated
    public String[] headers(String key) {
      return null;
    }

    @Deprecated
    public Map<String, String[]> headers() {
      return null;
    }

    public Headers getHeaders() {
      return null;
    }

    @Deprecated
    public RequestBuilder headers(Map<String, String[]> headers) {
      return null;
    }

    public RequestBuilder headers(Headers headers) {
      return null;
    }

    @Deprecated
    public RequestBuilder header(String key, String[] values) {
      return null;
    }

    public RequestBuilder header(String key, List<String> values) {
      return null;
    }

    public RequestBuilder header(String key, String value) {
      return null;
    }

    public Cookies cookies() {
      return null;
    }

    public RequestBuilder cookie(Cookie cookie) {
      return null;
    }

    public Map<String, String> flash() {
      return null;
    }

    public RequestBuilder flash(String key, String value) {
      return null;
    }

    public RequestBuilder flash(Map<String, String> data) {
      return null;
    }

    public Map<String, String> session() {
      return null;
    }

    public RequestBuilder session(String key, String value) {
      return null;
    }

    public RequestBuilder session(Map<String, String> data) {
      return null;
    }

    public String remoteAddress() {
      return "";
    }

    public RequestBuilder remoteAddress(String remoteAddress) {
      return null;
    }

    public Optional<List<X509Certificate>> clientCertificateChain() {
      return null;
    }

    public RequestBuilder clientCertificateChain(List<X509Certificate> clientCertificateChain) {
      return null;
    }
  }

  public abstract static class RawBuffer {

    public abstract ByteString asBytes();

    public abstract ByteString asBytes(int maxLength);

    public abstract Long size();

    public abstract File asFile();
  }

  public abstract static class MultipartFormData<A> {

    public static class FileInfo {
      public FileInfo(String key, String filename, String contentType) {}

      public String getKey() {
        return "";
      }

      public String getFilename() {
        return "";
      }

      public String getContentType() {
        return "";
      }
    }

    public interface Part<A> {
    }

    public static class FilePart<A> implements Part<A> {

      public FilePart(String key, String filename, String contentType, A file) {}

      public String getKey() {
        return "";
      }

      public String getFilename() {
        return "";
      }

      public String getContentType() {
        return "";
      }

      public String getDispositionType() {
        return "";
      }

      public A getFile() {
        return null;
      }

      public A getRef() {
        return null;
      }
    }

    public static class DataPart {

      public DataPart(String key, String value) {}

      public String getKey() {
        return "";
      }

      public String getValue() {
        return "";
      }
    }

    public abstract Map<String, String[]> asFormUrlEncoded();

    public abstract List<FilePart<A>> getFiles();

    public FilePart<A> getFile(String key) {
      return null;
    }
  }

  public static final class RequestBody {

    public RequestBody(Object body) {}

    public ByteString asBytes() {
      return null;
    }

    public <A> MultipartFormData<A> asMultipartFormData() {
      return null;
    }

    public Map<String, String[]> asFormUrlEncoded() {
      return null;
    }

    public RawBuffer asRaw() {
      return null;
    }

    public String asText() {
      return "";
    }

    public Document asXml() {
      return null;
    }

    public JsonNode asJson() {
      return null;
    }

    private String encode(String value) {
      return "";
    }

    public <T> T as(Class<T> tType) {
      return null;
    }

    public <A> Optional<A> parseJson(Class<A> clazz) {
      return null;
    }

    public String toString() {
      return "";
    }
  }

  public static class Response implements HeaderNames {

    public void setHeader(String name, String value) {}

    public Map<String, String> getHeaders() {
      return null;
    }

    @Deprecated
    public void setContentType(String contentType) {}

    @Deprecated
    public void setCookie(String name, String value, Integer maxAge, String path, String domain,
        boolean secure, boolean httpOnly, SameSite sameSite) {}

    public void setCookie(Cookie cookie) {}

    public void discardCookie(String name) {}

    public void discardCookie(String name, String path) {}

    public void discardCookie(String name, String path, String domain) {}

    public void discardCookie(String name, String path, String domain, boolean secure) {}

    public Collection<Cookie> cookies() {
      return null;
    }

    public Optional<Cookie> cookie(String name) {
      return null;
    }
  }

  public static class Session extends HashMap<String, String> {

    public boolean isDirty = false;

    public Session(Map<String, String> data) {}

    @Override
    public String remove(Object key) {
      return "";
    }

    @Override
    public String put(String key, String value) {
      return "";
    }

    @Override
    public void putAll(Map<? extends String, ? extends String> values) {}

    @Override
    public void clear() {}
  }

  public static class Flash extends HashMap<String, String> {

    public boolean isDirty = false;

    public Flash(Map<String, String> data) {}

    @Override
    public String remove(Object key) {
      return "";
    }

    @Override
    public String put(String key, String value) {
      return "";
    }

    @Override
    public void putAll(Map<? extends String, ? extends String> values) {}

    @Override
    public void clear() {}
  }

  public static class Cookie {

    public Cookie(String name, String value, Integer maxAge, String path, String domain,
        boolean secure, boolean httpOnly, SameSite sameSite) {}

    @Deprecated
    public Cookie(String name, String value, Integer maxAge, String path, String domain,
        boolean secure, boolean httpOnly) {}

    public static CookieBuilder builder(String name, String value) {
      return null;
    }

    public String name() {
      return "";
    }

    public String value() {
      return "";
    }

    public Integer maxAge() {
      return 0;
    }

    public String path() {
      return "";
    }

    public String domain() {
      return "";
    }

    public boolean secure() {
      return true;
    }

    public boolean httpOnly() {
      return true;
    }

    public Optional<SameSite> sameSite() {
      return null;
    }

    public enum SameSite {
      STRICT("Strict"), LAX("Lax"), NONE("None");

      SameSite(String value) {}

      public String value() {
        return "";
      }

      public static Optional<SameSite> parse(String sameSite) {
        return null;
      }
    }
  }

  public static class CookieBuilder {

    private CookieBuilder(String name, String value) {}

    public CookieBuilder withName(String name) {
      return null;
    }

    public CookieBuilder withValue(String value) {
      return null;
    }

    @Deprecated
    public CookieBuilder withMaxAge(Integer maxAge) {
      return null;
    }

    public CookieBuilder withMaxAge(Duration maxAge) {
      return null;
    }

    public CookieBuilder withPath(String path) {
      return null;
    }

    public CookieBuilder withDomain(String domain) {
      return null;
    }

    public CookieBuilder withSecure(boolean secure) {
      return null;
    }

    public CookieBuilder withHttpOnly(boolean httpOnly) {
      return null;
    }

    public CookieBuilder withSameSite(SameSite sameSite) {
      return null;
    }

    public Cookie build() {
      return null;
    }
  }

  public interface Cookies extends Iterable<Cookie> {

    Cookie get(String name);

    Optional<Cookie> getCookie(String name);
  }

  public interface HeaderNames {

    String ACCEPT = "Accept";
    String ACCEPT_CHARSET = "Accept-Charset";
    String ACCEPT_ENCODING = "Accept-Encoding";
    String ACCEPT_LANGUAGE = "Accept-Language";
    String ACCEPT_RANGES = "Accept-Ranges";
    String AGE = "Age";
    String ALLOW = "Allow";
    String AUTHORIZATION = "Authorization";
    String CACHE_CONTROL = "Cache-Control";
    String CONNECTION = "Connection";
    String CONTENT_DISPOSITION = "Content-Disposition";
    String CONTENT_ENCODING = "Content-Encoding";
    String CONTENT_LANGUAGE = "Content-Language";
    String CONTENT_LENGTH = "Content-Length";
    String CONTENT_LOCATION = "Content-Location";
    String CONTENT_MD5 = "Content-MD5";
    String CONTENT_RANGE = "Content-Range";
    String CONTENT_TRANSFER_ENCODING = "Content-Transfer-Encoding";
    String CONTENT_TYPE = "Content-Type";
    String COOKIE = "Cookie";
    String DATE = "Date";
    String ETAG = "ETag";
    String EXPECT = "Expect";
    String EXPIRES = "Expires";
    String FORWARDED = "Forwarded";
    String FROM = "From";
    String HOST = "Host";
    String IF_MATCH = "If-Match";
    String IF_MODIFIED_SINCE = "If-Modified-Since";
    String IF_NONE_MATCH = "If-None-Match";
    String IF_RANGE = "If-Range";
    String IF_UNMODIFIED_SINCE = "If-Unmodified-Since";
    String LAST_MODIFIED = "Last-Modified";
    String LINK = "Link";
    String LOCATION = "Location";
    String MAX_FORWARDS = "Max-Forwards";
    String PRAGMA = "Pragma";
    String PROXY_AUTHENTICATE = "Proxy-Authenticate";
    String PROXY_AUTHORIZATION = "Proxy-Authorization";
    String RANGE = "Range";
    String REFERER = "Referer";
    String RETRY_AFTER = "Retry-After";
    String SERVER = "Server";
    String SET_COOKIE = "Set-Cookie";
    String SET_COOKIE2 = "Set-Cookie2";
    String TE = "Te";
    String TRAILER = "Trailer";
    String TRANSFER_ENCODING = "Transfer-Encoding";
    String UPGRADE = "Upgrade";
    String USER_AGENT = "User-Agent";
    String VARY = "Vary";
    String VIA = "Via";
    String WARNING = "Warning";
    String WWW_AUTHENTICATE = "WWW-Authenticate";
    String ACCESS_CONTROL_ALLOW_ORIGIN = "Access-Control-Allow-Origin";
    String ACCESS_CONTROL_EXPOSE_HEADERS = "Access-Control-Expose-Headers";
    String ACCESS_CONTROL_MAX_AGE = "Access-Control-Max-Age";
    String ACCESS_CONTROL_ALLOW_CREDENTIALS = "Access-Control-Allow-Credentials";
    String ACCESS_CONTROL_ALLOW_METHODS = "Access-Control-Allow-Methods";
    String ACCESS_CONTROL_ALLOW_HEADERS = "Access-Control-Allow-Headers";
    String ORIGIN = "Origin";
    String ACCESS_CONTROL_REQUEST_METHOD = "Access-Control-Request-Method";
    String ACCESS_CONTROL_REQUEST_HEADERS = "Access-Control-Request-Headers";
    String X_FORWARDED_FOR = "X-Forwarded-For";
    String X_FORWARDED_HOST = "X-Forwarded-Host";
    String X_FORWARDED_PORT = "X-Forwarded-Port";
    String X_FORWARDED_PROTO = "X-Forwarded-Proto";
    String X_REQUESTED_WITH = "X-Requested-With";
    String STRICT_TRANSPORT_SECURITY = "Strict-Transport-Security";
    String X_FRAME_OPTIONS = "X-Frame-Options";
    String X_XSS_PROTECTION = "X-XSS-Protection";
    String X_CONTENT_TYPE_OPTIONS = "X-Content-Type-Options";
    String X_PERMITTED_CROSS_DOMAIN_POLICIES = "X-Permitted-Cross-Domain-Policies";
    String CONTENT_SECURITY_POLICY = "Content-Security-Policy";
    String CONTENT_SECURITY_POLICY_REPORT_ONLY = "Content-Security-Policy-Report-Only";
    String X_CONTENT_SECURITY_POLICY_NONCE_HEADER = "X-Content-Security-Policy-Nonce";
    String REFERRER_POLICY = "Referrer-Policy";
  }

  public interface Status {
    int CONTINUE = 100;
    int SWITCHING_PROTOCOLS = 101;

    int OK = 200;
    int CREATED = 201;
    int ACCEPTED = 202;
    int NON_AUTHORITATIVE_INFORMATION = 203;
    int NO_CONTENT = 204;
    int RESET_CONTENT = 205;
    int PARTIAL_CONTENT = 206;
    int MULTI_STATUS = 207;

    int MULTIPLE_CHOICES = 300;
    int MOVED_PERMANENTLY = 301;
    int FOUND = 302;
    int SEE_OTHER = 303;
    int NOT_MODIFIED = 304;
    int USE_PROXY = 305;
    int TEMPORARY_REDIRECT = 307;
    int PERMANENT_REDIRECT = 308;

    int BAD_REQUEST = 400;
    int UNAUTHORIZED = 401;
    int PAYMENT_REQUIRED = 402;
    int FORBIDDEN = 403;
    int NOT_FOUND = 404;
    int METHOD_NOT_ALLOWED = 405;
    int NOT_ACCEPTABLE = 406;
    int PROXY_AUTHENTICATION_REQUIRED = 407;
    int REQUEST_TIMEOUT = 408;
    int CONFLICT = 409;
    int GONE = 410;
    int LENGTH_REQUIRED = 411;
    int PRECONDITION_FAILED = 412;
    int REQUEST_ENTITY_TOO_LARGE = 413;
    int REQUEST_URI_TOO_LONG = 414;
    int UNSUPPORTED_MEDIA_TYPE = 415;
    int REQUESTED_RANGE_NOT_SATISFIABLE = 416;
    int EXPECTATION_FAILED = 417;
    int IM_A_TEAPOT = 418;
    int UNPROCESSABLE_ENTITY = 422;
    int LOCKED = 423;
    int FAILED_DEPENDENCY = 424;
    int UPGRADE_REQUIRED = 426;

    // See https://tools.ietf.org/html/rfc6585 for the following statuses
    int PRECONDITION_REQUIRED = 428;
    int TOO_MANY_REQUESTS = 429;
    int REQUEST_HEADER_FIELDS_TOO_LARGE = 431;

    int INTERNAL_SERVER_ERROR = 500;
    int NOT_IMPLEMENTED = 501;
    int BAD_GATEWAY = 502;
    int SERVICE_UNAVAILABLE = 503;
    int GATEWAY_TIMEOUT = 504;
    int HTTP_VERSION_NOT_SUPPORTED = 505;
    int INSUFFICIENT_STORAGE = 507;

    // See https://tools.ietf.org/html/rfc6585#section-6
    int NETWORK_AUTHENTICATION_REQUIRED = 511;
  }

  public interface MimeTypes {

    String TEXT = "text/plain";

    String HTML = "text/html";

    String JSON = "application/json";

    String XML = "application/xml";

    String XHTML = "application/xhtml+xml";

    String CSS = "text/css";

    String JAVASCRIPT = "application/javascript";

    String FORM = "application/x-www-form-urlencoded";

    String EVENT_STREAM = "text/event-stream";

    String BINARY = "application/octet-stream";
  }

  public interface HttpVerbs {
    String GET = "GET";
    String POST = "POST";
    String PUT = "PUT";
    String PATCH = "PATCH";
    String DELETE = "DELETE";
    String HEAD = "HEAD";
    String OPTIONS = "OPTIONS";
  }
}
