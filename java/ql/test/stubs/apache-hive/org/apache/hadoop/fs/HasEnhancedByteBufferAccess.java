// Generated automatically from org.apache.hadoop.fs.HasEnhancedByteBufferAccess for testing purposes

package org.apache.hadoop.fs;

import java.nio.ByteBuffer;
import java.util.EnumSet;
import org.apache.hadoop.fs.ReadOption;
import org.apache.hadoop.io.ByteBufferPool;

public interface HasEnhancedByteBufferAccess
{
    ByteBuffer read(ByteBufferPool p0, int p1, EnumSet<ReadOption> p2);
    void releaseBuffer(ByteBuffer p0);
}
