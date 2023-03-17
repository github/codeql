// Generated automatically from org.apache.hadoop.hive.metastore.partition.spec.PartitionSpecProxy for testing purposes

package org.apache.hadoop.hive.metastore.partition.spec;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.Partition;
import org.apache.hadoop.hive.metastore.api.PartitionSpec;

abstract public class PartitionSpecProxy
{
    public PartitionSpecProxy(){}
    public abstract List<PartitionSpec> toPartitionSpec();
    public abstract PartitionSpecProxy.PartitionIterator getPartitionIterator();
    public abstract String getCatName();
    public abstract String getDbName();
    public abstract String getTableName();
    public abstract int size();
    public abstract void setCatName(String p0);
    public abstract void setDbName(String p0);
    public abstract void setRootLocation(String p0);
    public abstract void setTableName(String p0);
    static public interface PartitionIterator extends Iterator<Partition>
    {
        Map<String, String> getParameters();
        Partition getCurrent();
        String getCatName();
        String getDbName();
        String getLocation();
        String getTableName();
        void putToParameters(String p0, String p1);
        void setCreateTime(long p0);
        void setParameters(Map<String, String> p0);
    }
}
