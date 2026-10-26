// Generated automatically from io.netty.handler.codec.http.HttpRequest for testing purposes

package io.netty.handler.codec.http;

import io.netty.handler.codec.http.HttpMessage;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.HttpVersion;

public interface HttpRequest extends HttpMessage
{
    HttpMethod getMethod();
    HttpMethod method();
    HttpRequest setMethod(HttpMethod p0);
    HttpRequest setProtocolVersion(HttpVersion p0);
    HttpRequest setUri(String p0);
    String getUri();
    String uri();
}
