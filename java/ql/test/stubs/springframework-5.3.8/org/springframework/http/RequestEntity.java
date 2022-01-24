// Generated automatically from org.springframework.http.RequestEntity for testing purposes

package org.springframework.http;

import java.lang.reflect.Type;
import java.net.URI;
import java.nio.charset.Charset;
import java.time.Instant;
import java.time.ZonedDateTime;
import java.util.Map;
import java.util.function.Consumer;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.util.MultiValueMap;

public class RequestEntity<T> extends HttpEntity<T>
{
    protected RequestEntity() {}
    public HttpMethod getMethod(){ return null; }
    public RequestEntity(HttpMethod p0, URI p1){}
    public RequestEntity(MultiValueMap<String, String> p0, HttpMethod p1, URI p2){}
    public RequestEntity(T p0, HttpMethod p1, URI p2){}
    public RequestEntity(T p0, HttpMethod p1, URI p2, Type p3){}
    public RequestEntity(T p0, MultiValueMap<String, String> p1, HttpMethod p2, URI p3){}
    public RequestEntity(T p0, MultiValueMap<String, String> p1, HttpMethod p2, URI p3, Type p4){}
    public String toString(){ return null; }
    public Type getType(){ return null; }
    public URI getUrl(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static RequestEntity.BodyBuilder method(HttpMethod p0, String p1, Map<String, ? extends Object> p2){ return null; }
    public static RequestEntity.BodyBuilder method(HttpMethod p0, String p1, Object... p2){ return null; }
    public static RequestEntity.BodyBuilder method(HttpMethod p0, URI p1){ return null; }
    public static RequestEntity.BodyBuilder patch(String p0, Object... p1){ return null; }
    public static RequestEntity.BodyBuilder patch(URI p0){ return null; }
    public static RequestEntity.BodyBuilder post(String p0, Object... p1){ return null; }
    public static RequestEntity.BodyBuilder post(URI p0){ return null; }
    public static RequestEntity.BodyBuilder put(String p0, Object... p1){ return null; }
    public static RequestEntity.BodyBuilder put(URI p0){ return null; }
    public static RequestEntity.HeadersBuilder<? extends Object> delete(String p0, Object... p1){ return null; }
    public static RequestEntity.HeadersBuilder<? extends Object> delete(URI p0){ return null; }
    public static RequestEntity.HeadersBuilder<? extends Object> get(String p0, Object... p1){ return null; }
    public static RequestEntity.HeadersBuilder<? extends Object> get(URI p0){ return null; }
    public static RequestEntity.HeadersBuilder<? extends Object> head(String p0, Object... p1){ return null; }
    public static RequestEntity.HeadersBuilder<? extends Object> head(URI p0){ return null; }
    public static RequestEntity.HeadersBuilder<? extends Object> options(String p0, Object... p1){ return null; }
    public static RequestEntity.HeadersBuilder<? extends Object> options(URI p0){ return null; }
    static <T> String format(HttpMethod p0, String p1, T p2, HttpHeaders p3){ return null; }
    static public interface BodyBuilder extends RequestEntity.HeadersBuilder<RequestEntity.BodyBuilder>
    {
        <T> RequestEntity<T> body(T p0);
        <T> RequestEntity<T> body(T p0, Type p1);
        RequestEntity.BodyBuilder contentLength(long p0);
        RequestEntity.BodyBuilder contentType(MediaType p0);
    }
    static public interface HeadersBuilder<B extends RequestEntity.HeadersBuilder<B>>
    {
        B accept(MediaType... p0);
        B acceptCharset(Charset... p0);
        B header(String p0, String... p1);
        B headers(Consumer<HttpHeaders> p0);
        B headers(HttpHeaders p0);
        B ifModifiedSince(Instant p0);
        B ifModifiedSince(ZonedDateTime p0);
        B ifModifiedSince(long p0);
        B ifNoneMatch(String... p0);
        RequestEntity<Void> build();
    }
}
