// Generated automatically from org.apache.hadoop.hive.metastore.FileFormatProxy for testing purposes

package org.apache.hadoop.hive.metastore;

import java.nio.ByteBuffer;
import java.util.List;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hive.metastore.Metastore;
import org.apache.hadoop.hive.ql.io.sarg.SearchArgument;

public interface FileFormatProxy
{
    ByteBuffer getMetadataToCache(FileSystem p0, Path p1, ByteBuffer[] p2);
    ByteBuffer[] getAddedColumnsToCache();
    ByteBuffer[][] getAddedValuesToCache(List<ByteBuffer> p0);
    Metastore.SplitInfos applySargToMetadata(SearchArgument p0, ByteBuffer p1);
}
