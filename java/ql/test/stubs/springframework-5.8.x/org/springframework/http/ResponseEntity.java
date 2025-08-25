// Generated automatically from org.springframework.http.ResponseEntity for testing purposes

package org.springframework.http;

import java.net.URI;
import java.time.Instant;
import java.time.ZonedDateTime;
import java.util.Optional;
import java.util.function.Consumer;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.util.MultiValueMap;

public class ResponseEntity<T> extends HttpEntity<T>
{
    protected ResponseEntity() {}
    public HttpStatus getStatusCode(){ return null; }
    public ResponseEntity(HttpStatus p0){}
    public ResponseEntity(MultiValueMap<String, String> p0, HttpStatus p1){}
    public ResponseEntity(T p0, HttpStatus p1){}
    public ResponseEntity(T p0, MultiValueMap<String, String> p1, HttpStatus p2){}
    public ResponseEntity(T p0, MultiValueMap<String, String> p1, int p2){}
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int getStatusCodeValue(){ return 0; }
    public int hashCode(){ return 0; }
    public static <T> ResponseEntity<T> of(Optional<T> p0){ return null; }
    public static <T> ResponseEntity<T> ok(T p0){ return null; }
    public static ResponseEntity.BodyBuilder accepted(){ return null; }
    public static ResponseEntity.BodyBuilder badRequest(){ return null; }
    public static ResponseEntity.BodyBuilder created(URI p0){ return null; }
    public static ResponseEntity.BodyBuilder ok(){ return null; }
    public static ResponseEntity.BodyBuilder status(HttpStatus p0){ return null; }
    public static ResponseEntity.BodyBuilder status(int p0){ return null; }
    public static ResponseEntity.BodyBuilder unprocessableEntity(){ return null; }
    public static ResponseEntity.HeadersBuilder<? extends Object> noContent(){ return null; }
    public static ResponseEntity.HeadersBuilder<? extends Object> notFound(){ return null; }
    static public interface BodyBuilder extends ResponseEntity.HeadersBuilder<ResponseEntity.BodyBuilder>
    {
        <T> ResponseEntity<T> body(T p0);
        ResponseEntity.BodyBuilder contentLength(long p0);
        ResponseEntity.BodyBuilder contentType(MediaType p0);
    }
    static public interface HeadersBuilder<B extends ResponseEntity.HeadersBuilder<B>>
    {
        <T> ResponseEntity<T> build();
        B allow(HttpMethod... p0);
        B cacheControl(CacheControl p0);
        B eTag(String p0);
        B header(String p0, String... p1);
        B headers(Consumer<HttpHeaders> p0);
        B headers(HttpHeaders p0);
        B lastModified(Instant p0);
        B lastModified(ZonedDateTime p0);
        B lastModified(long p0);
        B location(URI p0);
        B varyBy(String... p0);
    }
}
