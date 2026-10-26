// Generated automatically from io.netty.handler.codec.http.LastHttpContent for testing purposes

package io.netty.handler.codec.http;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.HttpContent;
import io.netty.handler.codec.http.HttpHeaders;

public interface LastHttpContent extends HttpContent
{
    HttpHeaders trailingHeaders();
    LastHttpContent copy();
    LastHttpContent duplicate();
    LastHttpContent replace(ByteBuf p0);
    LastHttpContent retain();
    LastHttpContent retain(int p0);
    LastHttpContent retainedDuplicate();
    LastHttpContent touch();
    LastHttpContent touch(Object p0);
    static LastHttpContent EMPTY_LAST_CONTENT = null;
}
