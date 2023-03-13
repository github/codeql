// Generated automatically from org.apache.hadoop.fs.QuotaUsage for testing purposes

package org.apache.hadoop.fs;

import java.util.List;
import org.apache.hadoop.fs.StorageType;

public class QuotaUsage
{
    protected QuotaUsage(){}
    protected QuotaUsage(QuotaUsage.Builder p0){}
    protected String getQuotaUsage(boolean p0){ return null; }
    protected String getTypesQuotaUsage(boolean p0, List<StorageType> p1){ return null; }
    protected static String QUOTA_HEADER = null;
    protected static String QUOTA_STRING_FORMAT = null;
    protected static String SPACE_QUOTA_STRING_FORMAT = null;
    protected static String[] QUOTA_HEADER_FIELDS = null;
    protected void setQuota(long p0){}
    protected void setSpaceConsumed(long p0){}
    protected void setSpaceQuota(long p0){}
    public String toString(){ return null; }
    public String toString(boolean p0){ return null; }
    public String toString(boolean p0, boolean p1, List<StorageType> p2){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isTypeConsumedAvailable(){ return false; }
    public boolean isTypeQuotaSet(){ return false; }
    public int hashCode(){ return 0; }
    public long getFileAndDirectoryCount(){ return 0; }
    public long getQuota(){ return 0; }
    public long getSpaceConsumed(){ return 0; }
    public long getSpaceQuota(){ return 0; }
    public long getTypeConsumed(StorageType p0){ return 0; }
    public long getTypeQuota(StorageType p0){ return 0; }
    public static String getHeader(){ return null; }
    public static String getStorageTypeHeader(List<StorageType> p0){ return null; }
    static public class Builder
    {
        public Builder(){}
        public QuotaUsage build(){ return null; }
        public QuotaUsage.Builder fileAndDirectoryCount(long p0){ return null; }
        public QuotaUsage.Builder quota(long p0){ return null; }
        public QuotaUsage.Builder spaceConsumed(long p0){ return null; }
        public QuotaUsage.Builder spaceQuota(long p0){ return null; }
        public QuotaUsage.Builder typeConsumed(StorageType p0, long p1){ return null; }
        public QuotaUsage.Builder typeConsumed(long[] p0){ return null; }
        public QuotaUsage.Builder typeQuota(StorageType p0, long p1){ return null; }
        public QuotaUsage.Builder typeQuota(long[] p0){ return null; }
    }
}
