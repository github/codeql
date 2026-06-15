// Generated automatically from com.github.luben.zstd.BufferPool for testing purposes

package com.github.luben.zstd;

import java.nio.ByteBuffer;

public interface BufferPool
{
    ByteBuffer get(int p0);
    void release(ByteBuffer p0);
}
