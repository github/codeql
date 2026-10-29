// Generated automatically from org.apache.hadoop.fs.FilterFileSystem for testing purposes

package org.apache.hadoop.fs;

import java.net.URI;
import java.util.Collection;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.BlockLocation;
import org.apache.hadoop.fs.BlockStoragePolicySpi;
import org.apache.hadoop.fs.CreateFlag;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FSDataOutputStreamBuilder;
import org.apache.hadoop.fs.FileChecksum;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FsServerDefaults;
import org.apache.hadoop.fs.FsStatus;
import org.apache.hadoop.fs.LocatedFileStatus;
import org.apache.hadoop.fs.Options;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.PathFilter;
import org.apache.hadoop.fs.PathHandle;
import org.apache.hadoop.fs.RemoteIterator;
import org.apache.hadoop.fs.XAttrSetFlag;
import org.apache.hadoop.fs.permission.AclEntry;
import org.apache.hadoop.fs.permission.AclStatus;
import org.apache.hadoop.fs.permission.FsAction;
import org.apache.hadoop.fs.permission.FsPermission;
import org.apache.hadoop.util.Progressable;

public class FilterFileSystem extends FileSystem
{
    protected FSDataOutputStream primitiveCreate(Path p0, FsPermission p1, EnumSet<CreateFlag> p2, int p3, short p4, long p5, Progressable p6, Options.ChecksumOpt p7){ return null; }
    protected FileSystem fs = null;
    protected Path getInitialWorkingDirectory(){ return null; }
    protected Path resolveLink(Path p0){ return null; }
    protected PathHandle createPathHandle(FileStatus p0, Options.HandleOpt... p1){ return null; }
    protected RemoteIterator<LocatedFileStatus> listLocatedStatus(Path p0, PathFilter p1){ return null; }
    protected String swapScheme = null;
    protected URI canonicalizeUri(URI p0){ return null; }
    protected URI getCanonicalUri(){ return null; }
    protected boolean primitiveMkdir(Path p0, FsPermission p1){ return false; }
    protected void checkPath(Path p0){}
    protected void rename(Path p0, Path p1, Options.Rename... p2){}
    public AclStatus getAclStatus(Path p0){ return null; }
    public BlockLocation[] getFileBlockLocations(FileStatus p0, long p1, long p2){ return null; }
    public BlockStoragePolicySpi getStoragePolicy(Path p0){ return null; }
    public Collection<? extends BlockStoragePolicySpi> getAllStoragePolicies(){ return null; }
    public Collection<FileStatus> getTrashRoots(boolean p0){ return null; }
    public Configuration getConf(){ return null; }
    public FSDataInputStream open(Path p0, int p1){ return null; }
    public FSDataInputStream open(PathHandle p0, int p1){ return null; }
    public FSDataOutputStream append(Path p0, int p1, Progressable p2){ return null; }
    public FSDataOutputStream create(Path p0, FsPermission p1, EnumSet<CreateFlag> p2, int p3, short p4, long p5, Progressable p6, Options.ChecksumOpt p7){ return null; }
    public FSDataOutputStream create(Path p0, FsPermission p1, boolean p2, int p3, short p4, long p5, Progressable p6){ return null; }
    public FSDataOutputStream createNonRecursive(Path p0, FsPermission p1, EnumSet<CreateFlag> p2, int p3, short p4, long p5, Progressable p6){ return null; }
    public FSDataOutputStreamBuilder appendFile(Path p0){ return null; }
    public FSDataOutputStreamBuilder createFile(Path p0){ return null; }
    public FileChecksum getFileChecksum(Path p0){ return null; }
    public FileChecksum getFileChecksum(Path p0, long p1){ return null; }
    public FileStatus getFileLinkStatus(Path p0){ return null; }
    public FileStatus getFileStatus(Path p0){ return null; }
    public FileStatus[] listStatus(Path p0){ return null; }
    public FileSystem getRawFileSystem(){ return null; }
    public FileSystem[] getChildFileSystems(){ return null; }
    public FilterFileSystem(){}
    public FilterFileSystem(FileSystem p0){}
    public FsServerDefaults getServerDefaults(){ return null; }
    public FsServerDefaults getServerDefaults(Path p0){ return null; }
    public FsStatus getStatus(Path p0){ return null; }
    public List<String> listXAttrs(Path p0){ return null; }
    public Map<String, byte[]> getXAttrs(Path p0){ return null; }
    public Map<String, byte[]> getXAttrs(Path p0, List<String> p1){ return null; }
    public Path createSnapshot(Path p0, String p1){ return null; }
    public Path getHomeDirectory(){ return null; }
    public Path getLinkTarget(Path p0){ return null; }
    public Path getTrashRoot(Path p0){ return null; }
    public Path getWorkingDirectory(){ return null; }
    public Path makeQualified(Path p0){ return null; }
    public Path resolvePath(Path p0){ return null; }
    public Path startLocalOutput(Path p0, Path p1){ return null; }
    public RemoteIterator<FileStatus> listStatusIterator(Path p0){ return null; }
    public RemoteIterator<LocatedFileStatus> listLocatedStatus(Path p0){ return null; }
    public RemoteIterator<Path> listCorruptFileBlocks(Path p0){ return null; }
    public URI getUri(){ return null; }
    public boolean delete(Path p0, boolean p1){ return false; }
    public boolean mkdirs(Path p0, FsPermission p1){ return false; }
    public boolean rename(Path p0, Path p1){ return false; }
    public boolean setReplication(Path p0, short p1){ return false; }
    public boolean supportsSymlinks(){ return false; }
    public boolean truncate(Path p0, long p1){ return false; }
    public byte[] getXAttr(Path p0, String p1){ return null; }
    public long getDefaultBlockSize(){ return 0; }
    public long getDefaultBlockSize(Path p0){ return 0; }
    public long getUsed(){ return 0; }
    public long getUsed(Path p0){ return 0; }
    public short getDefaultReplication(){ return 0; }
    public short getDefaultReplication(Path p0){ return 0; }
    public void access(Path p0, FsAction p1){}
    public void close(){}
    public void completeLocalOutput(Path p0, Path p1){}
    public void concat(Path p0, Path[] p1){}
    public void copyFromLocalFile(boolean p0, Path p1, Path p2){}
    public void copyFromLocalFile(boolean p0, boolean p1, Path p2, Path p3){}
    public void copyFromLocalFile(boolean p0, boolean p1, Path[] p2, Path p3){}
    public void copyToLocalFile(boolean p0, Path p1, Path p2){}
    public void createSymlink(Path p0, Path p1, boolean p2){}
    public void deleteSnapshot(Path p0, String p1){}
    public void initialize(URI p0, Configuration p1){}
    public void modifyAclEntries(Path p0, List<AclEntry> p1){}
    public void removeAcl(Path p0){}
    public void removeAclEntries(Path p0, List<AclEntry> p1){}
    public void removeDefaultAcl(Path p0){}
    public void removeXAttr(Path p0, String p1){}
    public void renameSnapshot(Path p0, String p1, String p2){}
    public void setAcl(Path p0, List<AclEntry> p1){}
    public void setOwner(Path p0, String p1, String p2){}
    public void setPermission(Path p0, FsPermission p1){}
    public void setStoragePolicy(Path p0, String p1){}
    public void setTimes(Path p0, long p1, long p2){}
    public void setVerifyChecksum(boolean p0){}
    public void setWorkingDirectory(Path p0){}
    public void setWriteChecksum(boolean p0){}
    public void setXAttr(Path p0, String p1, byte[] p2){}
    public void setXAttr(Path p0, String p1, byte[] p2, EnumSet<XAttrSetFlag> p3){}
    public void unsetStoragePolicy(Path p0){}
}
