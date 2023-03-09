// Generated automatically from org.apache.hadoop.fs.LocatedFileStatus for testing purposes

package org.apache.hadoop.fs;

import java.util.Set;
import org.apache.hadoop.fs.BlockLocation;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.permission.FsPermission;

public class LocatedFileStatus extends FileStatus
{
    protected void setBlockLocations(BlockLocation[] p0){}
    public BlockLocation[] getBlockLocations(){ return null; }
    public LocatedFileStatus(){}
    public LocatedFileStatus(FileStatus p0, BlockLocation[] p1){}
    public LocatedFileStatus(long p0, boolean p1, int p2, long p3, long p4, long p5, FsPermission p6, String p7, String p8, Path p9, Path p10, BlockLocation[] p11){}
    public LocatedFileStatus(long p0, boolean p1, int p2, long p3, long p4, long p5, FsPermission p6, String p7, String p8, Path p9, Path p10, Set<FileStatus.AttrFlags> p11, BlockLocation[] p12){}
    public LocatedFileStatus(long p0, boolean p1, int p2, long p3, long p4, long p5, FsPermission p6, String p7, String p8, Path p9, Path p10, boolean p11, boolean p12, boolean p13, BlockLocation[] p14){}
    public boolean equals(Object p0){ return false; }
    public int compareTo(FileStatus p0){ return 0; }
    public int hashCode(){ return 0; }
}
