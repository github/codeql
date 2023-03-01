// Generated automatically from org.apache.hadoop.fs.StorageStatistics for testing purposes

package org.apache.hadoop.fs;

import java.util.Iterator;

abstract public class StorageStatistics
{
    protected StorageStatistics() {}
    public StorageStatistics(String p0){}
    public String getName(){ return null; }
    public String getScheme(){ return null; }
    public abstract Iterator<StorageStatistics.LongStatistic> getLongStatistics();
    public abstract Long getLong(String p0);
    public abstract boolean isTracked(String p0);
    public abstract void reset();
    static public class LongStatistic
    {
        protected LongStatistic() {}
        public LongStatistic(String p0, long p1){}
        public String getName(){ return null; }
        public String toString(){ return null; }
        public long getValue(){ return 0; }
    }
}
