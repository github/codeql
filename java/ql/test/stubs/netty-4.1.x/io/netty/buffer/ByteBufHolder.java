// Generated automatically from io.netty.buffer.ByteBufHolder for testing purposes

package io.netty.buffer;

import io.netty.buffer.ByteBuf;
import io.netty.util.ReferenceCounted;

public interface ByteBufHolder extends ReferenceCounted
{
    ByteBuf content();
    ByteBufHolder copy();
    ByteBufHolder duplicate();
    ByteBufHolder replace(ByteBuf p0);
    ByteBufHolder retain();
    ByteBufHolder retain(int p0);
    ByteBufHolder retainedDuplicate();
    ByteBufHolder touch();
    ByteBufHolder touch(Object p0);
}
