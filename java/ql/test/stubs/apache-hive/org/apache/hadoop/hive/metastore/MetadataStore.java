// Generated automatically from org.apache.hadoop.hive.metastore.MetadataStore for testing purposes

package org.apache.hadoop.hive.metastore;

import java.nio.ByteBuffer;
import java.util.List;

public interface MetadataStore
{
    void getFileMetadata(List<Long> p0, ByteBuffer[] p1);
    void storeFileMetadata(List<Long> p0, List<ByteBuffer> p1, ByteBuffer[] p2, ByteBuffer[][] p3);
    void storeFileMetadata(long p0, ByteBuffer p1, ByteBuffer[] p2, ByteBuffer[] p3);
}
