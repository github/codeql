// Generated automatically from io.netty.handler.codec.http.FullHttpMessage for testing purposes

package io.netty.handler.codec.http;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.HttpMessage;
import io.netty.handler.codec.http.LastHttpContent;

public interface FullHttpMessage extends HttpMessage, LastHttpContent
{
    FullHttpMessage copy();
    FullHttpMessage duplicate();
    FullHttpMessage replace(ByteBuf p0);
    FullHttpMessage retain();
    FullHttpMessage retain(int p0);
    FullHttpMessage retainedDuplicate();
    FullHttpMessage touch();
    FullHttpMessage touch(Object p0);
}
