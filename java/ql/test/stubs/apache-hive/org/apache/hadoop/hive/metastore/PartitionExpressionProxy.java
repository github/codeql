// Generated automatically from org.apache.hadoop.hive.metastore.PartitionExpressionProxy for testing purposes

package org.apache.hadoop.hive.metastore;

import java.util.List;
import org.apache.hadoop.hive.metastore.FileFormatProxy;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.hadoop.hive.metastore.api.FileMetadataExprType;
import org.apache.hadoop.hive.ql.io.sarg.SearchArgument;

public interface PartitionExpressionProxy
{
    FileFormatProxy getFileFormatProxy(FileMetadataExprType p0);
    FileMetadataExprType getMetadataType(String p0);
    SearchArgument createSarg(byte[] p0);
    String convertExprToFilter(byte[] p0);
    boolean filterPartitionsByExpr(List<FieldSchema> p0, byte[] p1, String p2, List<String> p3);
}
