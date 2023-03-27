// Generated automatically from io.netty.handler.codec.http.FullHttpResponse for testing purposes

package io.netty.handler.codec.http;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.FullHttpMessage;
import io.netty.handler.codec.http.HttpResponse;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.handler.codec.http.HttpVersion;

public interface FullHttpResponse extends FullHttpMessage, HttpResponse
{
    FullHttpResponse copy();
    FullHttpResponse duplicate();
    FullHttpResponse replace(ByteBuf p0);
    FullHttpResponse retain();
    FullHttpResponse retain(int p0);
    FullHttpResponse retainedDuplicate();
    FullHttpResponse setProtocolVersion(HttpVersion p0);
    FullHttpResponse setStatus(HttpResponseStatus p0);
    FullHttpResponse touch();
    FullHttpResponse touch(Object p0);
}
