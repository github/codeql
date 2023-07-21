// Generated automatically from io.netty.handler.codec.http.multipart.Attribute for testing purposes

package io.netty.handler.codec.http.multipart;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.multipart.HttpData;

public interface Attribute extends HttpData
{
    Attribute copy();
    Attribute duplicate();
    Attribute replace(ByteBuf p0);
    Attribute retain();
    Attribute retain(int p0);
    Attribute retainedDuplicate();
    Attribute touch();
    Attribute touch(Object p0);
    String getValue();
    void setValue(String p0);
}
