// Generated automatically from io.netty.handler.codec.http.FullHttpRequest for testing purposes

package io.netty.handler.codec.http;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.FullHttpMessage;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.HttpVersion;

public interface FullHttpRequest extends FullHttpMessage, HttpRequest
{
    FullHttpRequest copy();
    FullHttpRequest duplicate();
    FullHttpRequest replace(ByteBuf p0);
    FullHttpRequest retain();
    FullHttpRequest retain(int p0);
    FullHttpRequest retainedDuplicate();
    FullHttpRequest setMethod(HttpMethod p0);
    FullHttpRequest setProtocolVersion(HttpVersion p0);
    FullHttpRequest setUri(String p0);
    FullHttpRequest touch();
    FullHttpRequest touch(Object p0);
}
