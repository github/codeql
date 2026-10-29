// Generated automatically from org.apache.hadoop.hive.metastore.FileMetadataHandler for testing purposes

package org.apache.hadoop.hive.metastore;

import java.nio.ByteBuffer;
import java.util.List;
import org.apache.commons.logging.Log;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hive.metastore.FileFormatProxy;
import org.apache.hadoop.hive.metastore.MetadataStore;
import org.apache.hadoop.hive.metastore.PartitionExpressionProxy;
import org.apache.hadoop.hive.metastore.api.FileMetadataExprType;

abstract public class FileMetadataHandler
{
    protected FileFormatProxy getFileFormatProxy(){ return null; }
    protected MetadataStore getStore(){ return null; }
    protected PartitionExpressionProxy getExpressionProxy(){ return null; }
    protected abstract FileMetadataExprType getType();
    protected static Log LOG = null;
    public ByteBuffer[] createAddedCols(){ return null; }
    public ByteBuffer[][] createAddedColVals(List<ByteBuffer> p0){ return null; }
    public FileMetadataHandler(){}
    public abstract void getFileMetadataByExpr(List<Long> p0, byte[] p1, ByteBuffer[] p2, ByteBuffer[] p3, boolean[] p4);
    public void cacheFileMetadata(long p0, FileSystem p1, Path p2){}
    public void configure(Configuration p0, PartitionExpressionProxy p1, MetadataStore p2){}
}
