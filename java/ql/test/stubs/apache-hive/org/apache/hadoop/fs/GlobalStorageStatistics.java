// Generated automatically from org.apache.hadoop.fs.GlobalStorageStatistics for testing purposes

package org.apache.hadoop.fs;

import java.util.Iterator;
import org.apache.hadoop.fs.StorageStatistics;

public enum GlobalStorageStatistics
{
    INSTANCE;
    private GlobalStorageStatistics() {}
    public Iterator<StorageStatistics> iterator(){ return null; }
    public StorageStatistics get(String p0){ return null; }
    public StorageStatistics put(String p0, GlobalStorageStatistics.StorageStatisticsProvider p1){ return null; }
    public void reset(){}
    static public interface StorageStatisticsProvider
    {
        StorageStatistics provide();
    }
}
