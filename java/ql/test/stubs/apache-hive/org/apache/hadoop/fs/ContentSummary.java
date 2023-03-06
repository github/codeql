// Generated automatically from org.apache.hadoop.fs.ContentSummary for testing purposes

package org.apache.hadoop.fs;

import java.io.DataInput;
import java.io.DataOutput;
import java.util.List;
import org.apache.hadoop.fs.QuotaUsage;
import org.apache.hadoop.fs.StorageType;
import org.apache.hadoop.io.Writable;

public class ContentSummary extends QuotaUsage implements Writable
{
    public ContentSummary(){}
    public ContentSummary(long p0, long p1, long p2){}
    public ContentSummary(long p0, long p1, long p2, long p3, long p4, long p5){}
    public String getErasureCodingPolicy(){ return null; }
    public String toString(){ return null; }
    public String toString(boolean p0){ return null; }
    public String toString(boolean p0, boolean p1){ return null; }
    public String toString(boolean p0, boolean p1, boolean p2){ return null; }
    public String toString(boolean p0, boolean p1, boolean p2, List<StorageType> p3){ return null; }
    public String toString(boolean p0, boolean p1, boolean p2, boolean p3, List<StorageType> p4){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public long getDirectoryCount(){ return 0; }
    public long getFileCount(){ return 0; }
    public long getLength(){ return 0; }
    public long getSnapshotDirectoryCount(){ return 0; }
    public long getSnapshotFileCount(){ return 0; }
    public long getSnapshotLength(){ return 0; }
    public long getSnapshotSpaceConsumed(){ return 0; }
    public static String getHeader(boolean p0){ return null; }
    public static String[] getHeaderFields(){ return null; }
    public static String[] getQuotaHeaderFields(){ return null; }
    public void readFields(DataInput p0){}
    public void write(DataOutput p0){}
}
