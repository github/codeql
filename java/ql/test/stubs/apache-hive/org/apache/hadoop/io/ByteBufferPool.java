// Generated automatically from org.apache.hadoop.io.ByteBufferPool for testing purposes

package org.apache.hadoop.io;

import java.nio.ByteBuffer;

public interface ByteBufferPool
{
    ByteBuffer getBuffer(boolean p0, int p1);
    void putBuffer(ByteBuffer p0);
}
