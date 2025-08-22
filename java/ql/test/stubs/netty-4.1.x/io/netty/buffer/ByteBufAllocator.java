// Generated automatically from io.netty.buffer.ByteBufAllocator for testing purposes

package io.netty.buffer;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.CompositeByteBuf;

public interface ByteBufAllocator
{
    ByteBuf buffer();
    ByteBuf buffer(int p0);
    ByteBuf buffer(int p0, int p1);
    ByteBuf directBuffer();
    ByteBuf directBuffer(int p0);
    ByteBuf directBuffer(int p0, int p1);
    ByteBuf heapBuffer();
    ByteBuf heapBuffer(int p0);
    ByteBuf heapBuffer(int p0, int p1);
    ByteBuf ioBuffer();
    ByteBuf ioBuffer(int p0);
    ByteBuf ioBuffer(int p0, int p1);
    CompositeByteBuf compositeBuffer();
    CompositeByteBuf compositeBuffer(int p0);
    CompositeByteBuf compositeDirectBuffer();
    CompositeByteBuf compositeDirectBuffer(int p0);
    CompositeByteBuf compositeHeapBuffer();
    CompositeByteBuf compositeHeapBuffer(int p0);
    boolean isDirectBufferPooled();
    int calculateNewCapacity(int p0, int p1);
    static ByteBufAllocator DEFAULT = null;
}
