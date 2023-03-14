// Generated automatically from org.springframework.core.io.buffer.DataBufferFactory for testing purposes

package org.springframework.core.io.buffer;

import java.nio.ByteBuffer;
import java.util.List;
import org.springframework.core.io.buffer.DataBuffer;

public interface DataBufferFactory
{
    DataBuffer allocateBuffer();
    DataBuffer allocateBuffer(int p0);
    DataBuffer join(List<? extends DataBuffer> p0);
    DataBuffer wrap(ByteBuffer p0);
    DataBuffer wrap(byte[] p0);
    boolean isDirect();
}
