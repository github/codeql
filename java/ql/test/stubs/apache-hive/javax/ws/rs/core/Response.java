// Generated automatically from javax.ws.rs.core.Response for testing purposes

package javax.ws.rs.core;

import java.lang.annotation.Annotation;
import java.net.URI;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import javax.ws.rs.core.CacheControl;
import javax.ws.rs.core.EntityTag;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.Link;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.NewCookie;
import javax.ws.rs.core.Variant;

abstract public class Response
{
    abstract static public class ResponseBuilder
    {
        protected ResponseBuilder(){}
        protected static Response.ResponseBuilder newInstance(){ return null; }
        public Response.ResponseBuilder status(Response.Status p0){ return null; }
        public Response.ResponseBuilder status(Response.StatusType p0){ return null; }
        public abstract Response build();
        public abstract Response.ResponseBuilder allow(Set<String> p0);
        public abstract Response.ResponseBuilder allow(String... p0);
        public abstract Response.ResponseBuilder cacheControl(CacheControl p0);
        public abstract Response.ResponseBuilder clone();
        public abstract Response.ResponseBuilder contentLocation(URI p0);
        public abstract Response.ResponseBuilder cookie(NewCookie... p0);
        public abstract Response.ResponseBuilder encoding(String p0);
        public abstract Response.ResponseBuilder entity(Object p0);
        public abstract Response.ResponseBuilder entity(Object p0, Annotation[] p1);
        public abstract Response.ResponseBuilder expires(Date p0);
        public abstract Response.ResponseBuilder header(String p0, Object p1);
        public abstract Response.ResponseBuilder language(Locale p0);
        public abstract Response.ResponseBuilder language(String p0);
        public abstract Response.ResponseBuilder lastModified(Date p0);
        public abstract Response.ResponseBuilder link(String p0, String p1);
        public abstract Response.ResponseBuilder link(URI p0, String p1);
        public abstract Response.ResponseBuilder links(Link... p0);
        public abstract Response.ResponseBuilder location(URI p0);
        public abstract Response.ResponseBuilder replaceAll(MultivaluedMap<String, Object> p0);
        public abstract Response.ResponseBuilder status(int p0);
        public abstract Response.ResponseBuilder tag(EntityTag p0);
        public abstract Response.ResponseBuilder tag(String p0);
        public abstract Response.ResponseBuilder type(MediaType p0);
        public abstract Response.ResponseBuilder type(String p0);
        public abstract Response.ResponseBuilder variant(Variant p0);
        public abstract Response.ResponseBuilder variants(List<Variant> p0);
        public abstract Response.ResponseBuilder variants(Variant... p0);
    }
    protected Response(){}
    public MultivaluedMap<String, Object> getHeaders(){ return null; }
    public abstract <T> T readEntity(java.lang.Class<T> p0);
    public abstract <T> T readEntity(java.lang.Class<T> p0, Annotation[] p1);
    public abstract <T> T readEntity(javax.ws.rs.core.GenericType<T> p0);
    public abstract <T> T readEntity(javax.ws.rs.core.GenericType<T> p0, Annotation[] p1);
    public abstract Date getDate();
    public abstract Date getLastModified();
    public abstract EntityTag getEntityTag();
    public abstract Link getLink(String p0);
    public abstract Link.Builder getLinkBuilder(String p0);
    public abstract Locale getLanguage();
    public abstract Map<String, NewCookie> getCookies();
    public abstract MediaType getMediaType();
    public abstract MultivaluedMap<String, Object> getMetadata();
    public abstract MultivaluedMap<String, String> getStringHeaders();
    public abstract Object getEntity();
    public abstract Response.StatusType getStatusInfo();
    public abstract Set<Link> getLinks();
    public abstract Set<String> getAllowedMethods();
    public abstract String getHeaderString(String p0);
    public abstract URI getLocation();
    public abstract boolean bufferEntity();
    public abstract boolean hasEntity();
    public abstract boolean hasLink(String p0);
    public abstract int getLength();
    public abstract int getStatus();
    public abstract void close();
    public static Response.ResponseBuilder accepted(){ return null; }
    public static Response.ResponseBuilder accepted(Object p0){ return null; }
    public static Response.ResponseBuilder created(URI p0){ return null; }
    public static Response.ResponseBuilder fromResponse(Response p0){ return null; }
    public static Response.ResponseBuilder noContent(){ return null; }
    public static Response.ResponseBuilder notAcceptable(List<Variant> p0){ return null; }
    public static Response.ResponseBuilder notModified(){ return null; }
    public static Response.ResponseBuilder notModified(EntityTag p0){ return null; }
    public static Response.ResponseBuilder notModified(String p0){ return null; }
    public static Response.ResponseBuilder ok(){ return null; }
    public static Response.ResponseBuilder ok(Object p0){ return null; }
    public static Response.ResponseBuilder ok(Object p0, MediaType p1){ return null; }
    public static Response.ResponseBuilder ok(Object p0, String p1){ return null; }
    public static Response.ResponseBuilder ok(Object p0, Variant p1){ return null; }
    public static Response.ResponseBuilder seeOther(URI p0){ return null; }
    public static Response.ResponseBuilder serverError(){ return null; }
    public static Response.ResponseBuilder status(Response.Status p0){ return null; }
    public static Response.ResponseBuilder status(Response.StatusType p0){ return null; }
    public static Response.ResponseBuilder status(int p0){ return null; }
    public static Response.ResponseBuilder temporaryRedirect(URI p0){ return null; }
    static public enum Status
    {
        ACCEPTED, BAD_GATEWAY, BAD_REQUEST, CONFLICT, CREATED, EXPECTATION_FAILED, FORBIDDEN, FOUND, GATEWAY_TIMEOUT, GONE, HTTP_VERSION_NOT_SUPPORTED, INTERNAL_SERVER_ERROR, LENGTH_REQUIRED, METHOD_NOT_ALLOWED, MOVED_PERMANENTLY, NOT_ACCEPTABLE, NOT_FOUND, NOT_IMPLEMENTED, NOT_MODIFIED, NO_CONTENT, OK, PARTIAL_CONTENT, PAYMENT_REQUIRED, PRECONDITION_FAILED, PROXY_AUTHENTICATION_REQUIRED, REQUESTED_RANGE_NOT_SATISFIABLE, REQUEST_ENTITY_TOO_LARGE, REQUEST_TIMEOUT, REQUEST_URI_TOO_LONG, RESET_CONTENT, SEE_OTHER, SERVICE_UNAVAILABLE, TEMPORARY_REDIRECT, UNAUTHORIZED, UNSUPPORTED_MEDIA_TYPE, USE_PROXY;
        private Status() {}
        public Response.Status.Family getFamily(){ return null; }
        public String getReasonPhrase(){ return null; }
        public String toString(){ return null; }
        public int getStatusCode(){ return 0; }
        public static Response.Status fromStatusCode(int p0){ return null; }
        static public enum Family
        {
            CLIENT_ERROR, INFORMATIONAL, OTHER, REDIRECTION, SERVER_ERROR, SUCCESSFUL;
            private Family() {}
            public static Response.Status.Family familyOf(int p0){ return null; }
        }
    }
    static public interface StatusType
    {
        Response.Status.Family getFamily();
        String getReasonPhrase();
        int getStatusCode();
    }
}
