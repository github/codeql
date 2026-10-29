// Generated automatically from io.netty.handler.codec.http.HttpMessage for testing purposes

package io.netty.handler.codec.http;

import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpObject;
import io.netty.handler.codec.http.HttpVersion;

public interface HttpMessage extends HttpObject
{
    HttpHeaders headers();
    HttpMessage setProtocolVersion(HttpVersion p0);
    HttpVersion getProtocolVersion();
    HttpVersion protocolVersion();
}
