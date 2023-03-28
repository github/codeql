// Generated automatically from org.springframework.http.server.reactive.ServerHttpRequest for testing purposes

package org.springframework.http.server.reactive;

import java.net.InetSocketAddress;
import java.net.URI;
import java.util.function.Consumer;
import org.springframework.http.HttpCookie;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpRequest;
import org.springframework.http.ReactiveHttpInputMessage;
import org.springframework.http.server.RequestPath;
import org.springframework.http.server.reactive.SslInfo;
import org.springframework.util.MultiValueMap;

public interface ServerHttpRequest extends HttpRequest, ReactiveHttpInputMessage
{
    MultiValueMap<String, HttpCookie> getCookies();
    MultiValueMap<String, String> getQueryParams();
    RequestPath getPath();
    String getId();
    default InetSocketAddress getLocalAddress(){ return null; }
    default InetSocketAddress getRemoteAddress(){ return null; }
    default ServerHttpRequest.Builder mutate(){ return null; }
    default SslInfo getSslInfo(){ return null; }
    static public interface Builder
    {
        ServerHttpRequest build();
        ServerHttpRequest.Builder contextPath(String p0);
        ServerHttpRequest.Builder header(String p0, String... p1);
        ServerHttpRequest.Builder headers(Consumer<HttpHeaders> p0);
        ServerHttpRequest.Builder method(HttpMethod p0);
        ServerHttpRequest.Builder path(String p0);
        ServerHttpRequest.Builder remoteAddress(InetSocketAddress p0);
        ServerHttpRequest.Builder sslInfo(SslInfo p0);
        ServerHttpRequest.Builder uri(URI p0);
    }
}
