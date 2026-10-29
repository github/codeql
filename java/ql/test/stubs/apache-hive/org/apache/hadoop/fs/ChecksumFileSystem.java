// Generated automatically from org.apache.hadoop.fs.ChecksumFileSystem for testing purposes

package org.apache.hadoop.fs;

import java.util.List;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FilterFileSystem;
import org.apache.hadoop.fs.LocatedFileStatus;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.RemoteIterator;
import org.apache.hadoop.fs.permission.AclEntry;
import org.apache.hadoop.fs.permission.FsPermission;
import org.apache.hadoop.util.Progressable;

abstract public class ChecksumFileSystem extends FilterFileSystem
{
    protected ChecksumFileSystem() {}
    public ChecksumFileSystem(FileSystem p0){}
    public FSDataInputStream open(Path p0, int p1){ return null; }
    public FSDataOutputStream append(Path p0, int p1, Progressable p2){ return null; }
    public FSDataOutputStream create(Path p0, FsPermission p1, boolean p2, int p3, short p4, long p5, Progressable p6){ return null; }
    public FSDataOutputStream createNonRecursive(Path p0, FsPermission p1, boolean p2, int p3, short p4, long p5, Progressable p6){ return null; }
    public FileStatus[] listStatus(Path p0){ return null; }
    public FileSystem getRawFileSystem(){ return null; }
    public Path getChecksumFile(Path p0){ return null; }
    public Path startLocalOutput(Path p0, Path p1){ return null; }
    public RemoteIterator<LocatedFileStatus> listLocatedStatus(Path p0){ return null; }
    public boolean delete(Path p0, boolean p1){ return false; }
    public boolean mkdirs(Path p0){ return false; }
    public boolean rename(Path p0, Path p1){ return false; }
    public boolean reportChecksumFailure(Path p0, FSDataInputStream p1, long p2, FSDataInputStream p3, long p4){ return false; }
    public boolean setReplication(Path p0, short p1){ return false; }
    public boolean truncate(Path p0, long p1){ return false; }
    public int getBytesPerSum(){ return 0; }
    public long getChecksumFileLength(Path p0, long p1){ return 0; }
    public static boolean isChecksumFile(Path p0){ return false; }
    public static double getApproxChkSumLength(long p0){ return 0; }
    public static long getChecksumLength(long p0, int p1){ return 0; }
    public void completeLocalOutput(Path p0, Path p1){}
    public void copyFromLocalFile(boolean p0, Path p1, Path p2){}
    public void copyToLocalFile(Path p0, Path p1, boolean p2){}
    public void copyToLocalFile(boolean p0, Path p1, Path p2){}
    public void modifyAclEntries(Path p0, List<AclEntry> p1){}
    public void removeAcl(Path p0){}
    public void removeAclEntries(Path p0, List<AclEntry> p1){}
    public void removeDefaultAcl(Path p0){}
    public void setAcl(Path p0, List<AclEntry> p1){}
    public void setConf(Configuration p0){}
    public void setOwner(Path p0, String p1, String p2){}
    public void setPermission(Path p0, FsPermission p1){}
    public void setVerifyChecksum(boolean p0){}
    public void setWriteChecksum(boolean p0){}
}
