// Generated automatically from org.apache.hadoop.fs.FileStatus for testing purposes

package org.apache.hadoop.fs;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.ObjectInputValidation;
import java.io.Serializable;
import java.util.Set;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.permission.FsPermission;
import org.apache.hadoop.io.Writable;

public class FileStatus implements Comparable<Object>, ObjectInputValidation, Serializable, Writable
{
    protected void setGroup(String p0){}
    protected void setOwner(String p0){}
    protected void setPermission(FsPermission p0){}
    public FileStatus(){}
    public FileStatus(FileStatus p0){}
    public FileStatus(long p0, boolean p1, int p2, long p3, long p4, Path p5){}
    public FileStatus(long p0, boolean p1, int p2, long p3, long p4, long p5, FsPermission p6, String p7, String p8, Path p9){}
    public FileStatus(long p0, boolean p1, int p2, long p3, long p4, long p5, FsPermission p6, String p7, String p8, Path p9, Path p10){}
    public FileStatus(long p0, boolean p1, int p2, long p3, long p4, long p5, FsPermission p6, String p7, String p8, Path p9, Path p10, Set<FileStatus.AttrFlags> p11){}
    public FileStatus(long p0, boolean p1, int p2, long p3, long p4, long p5, FsPermission p6, String p7, String p8, Path p9, Path p10, boolean p11, boolean p12, boolean p13){}
    public FsPermission getPermission(){ return null; }
    public Path getPath(){ return null; }
    public Path getSymlink(){ return null; }
    public String getGroup(){ return null; }
    public String getOwner(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean hasAcl(){ return false; }
    public boolean isDirectory(){ return false; }
    public boolean isEncrypted(){ return false; }
    public boolean isErasureCoded(){ return false; }
    public boolean isFile(){ return false; }
    public boolean isSnapshotEnabled(){ return false; }
    public boolean isSymlink(){ return false; }
    public final boolean isDir(){ return false; }
    public int compareTo(FileStatus p0){ return 0; }
    public int compareTo(Object p0){ return 0; }
    public int hashCode(){ return 0; }
    public long getAccessTime(){ return 0; }
    public long getBlockSize(){ return 0; }
    public long getLen(){ return 0; }
    public long getModificationTime(){ return 0; }
    public short getReplication(){ return 0; }
    public static Set<FileStatus.AttrFlags> NONE = null;
    public static Set<FileStatus.AttrFlags> attributes(boolean p0, boolean p1, boolean p2, boolean p3){ return null; }
    public void readFields(DataInput p0){}
    public void setPath(Path p0){}
    public void setSymlink(Path p0){}
    public void validateObject(){}
    public void write(DataOutput p0){}
    static public enum AttrFlags
    {
        HAS_ACL, HAS_CRYPT, HAS_EC, SNAPSHOT_ENABLED;
        private AttrFlags() {}
    }
}
