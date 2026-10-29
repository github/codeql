// Generated automatically from io.netty.handler.codec.http.HttpResponse for testing purposes

package io.netty.handler.codec.http;

import io.netty.handler.codec.http.HttpMessage;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.handler.codec.http.HttpVersion;

public interface HttpResponse extends HttpMessage
{
    HttpResponse setProtocolVersion(HttpVersion p0);
    HttpResponse setStatus(HttpResponseStatus p0);
    HttpResponseStatus getStatus();
    HttpResponseStatus status();
}
