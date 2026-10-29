// Generated automatically from io.netty.handler.codec.http.HttpContent for testing purposes

package io.netty.handler.codec.http;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufHolder;
import io.netty.handler.codec.http.HttpObject;

public interface HttpContent extends ByteBufHolder, HttpObject
{
    HttpContent copy();
    HttpContent duplicate();
    HttpContent replace(ByteBuf p0);
    HttpContent retain();
    HttpContent retain(int p0);
    HttpContent retainedDuplicate();
    HttpContent touch();
    HttpContent touch(Object p0);
}
