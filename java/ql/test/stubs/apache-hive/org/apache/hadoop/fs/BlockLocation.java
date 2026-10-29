// Generated automatically from org.apache.hadoop.fs.BlockLocation for testing purposes

package org.apache.hadoop.fs;

import java.io.Serializable;
import org.apache.hadoop.fs.StorageType;

public class BlockLocation implements Serializable
{
    public BlockLocation(){}
    public BlockLocation(BlockLocation p0){}
    public BlockLocation(String[] p0, String[] p1, String[] p2, String[] p3, String[] p4, StorageType[] p5, long p6, long p7, boolean p8){}
    public BlockLocation(String[] p0, String[] p1, String[] p2, String[] p3, long p4, long p5, boolean p6){}
    public BlockLocation(String[] p0, String[] p1, String[] p2, long p3, long p4){}
    public BlockLocation(String[] p0, String[] p1, String[] p2, long p3, long p4, boolean p5){}
    public BlockLocation(String[] p0, String[] p1, long p2, long p3){}
    public BlockLocation(String[] p0, String[] p1, long p2, long p3, boolean p4){}
    public StorageType[] getStorageTypes(){ return null; }
    public String toString(){ return null; }
    public String[] getCachedHosts(){ return null; }
    public String[] getHosts(){ return null; }
    public String[] getNames(){ return null; }
    public String[] getStorageIds(){ return null; }
    public String[] getTopologyPaths(){ return null; }
    public boolean isCorrupt(){ return false; }
    public long getLength(){ return 0; }
    public long getOffset(){ return 0; }
    public void setCachedHosts(String[] p0){}
    public void setCorrupt(boolean p0){}
    public void setHosts(String[] p0){}
    public void setLength(long p0){}
    public void setNames(String[] p0){}
    public void setOffset(long p0){}
    public void setStorageIds(String[] p0){}
    public void setStorageTypes(StorageType[] p0){}
    public void setTopologyPaths(String[] p0){}
}
