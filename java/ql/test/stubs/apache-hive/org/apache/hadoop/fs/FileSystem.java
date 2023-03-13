// Generated automatically from org.apache.hadoop.fs.FileSystem for testing purposes

package org.apache.hadoop.fs;

import java.io.Closeable;
import java.net.URI;
import java.util.Collection;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import org.apache.commons.logging.Log;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.BlockLocation;
import org.apache.hadoop.fs.BlockStoragePolicySpi;
import org.apache.hadoop.fs.ContentSummary;
import org.apache.hadoop.fs.CreateFlag;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FSDataOutputStreamBuilder;
import org.apache.hadoop.fs.FileChecksum;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FsServerDefaults;
import org.apache.hadoop.fs.FsStatus;
import org.apache.hadoop.fs.GlobalStorageStatistics;
import org.apache.hadoop.fs.LocalFileSystem;
import org.apache.hadoop.fs.LocatedFileStatus;
import org.apache.hadoop.fs.Options;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.PathFilter;
import org.apache.hadoop.fs.PathHandle;
import org.apache.hadoop.fs.QuotaUsage;
import org.apache.hadoop.fs.RemoteIterator;
import org.apache.hadoop.fs.StorageStatistics;
import org.apache.hadoop.fs.XAttrSetFlag;
import org.apache.hadoop.fs.permission.AclEntry;
import org.apache.hadoop.fs.permission.AclStatus;
import org.apache.hadoop.fs.permission.FsAction;
import org.apache.hadoop.fs.permission.FsPermission;
import org.apache.hadoop.security.Credentials;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hadoop.security.token.Token;
import org.apache.hadoop.security.token.TokenIdentifier;
import org.apache.hadoop.util.Progressable;

abstract public class FileSystem extends Configured implements Closeable
{
    protected FSDataOutputStream primitiveCreate(Path p0, FsPermission p1, EnumSet<CreateFlag> p2, int p3, short p4, long p5, Progressable p6, Options.ChecksumOpt p7){ return null; }
    protected FileSystem(){}
    protected FileSystem.DirectoryEntries listStatusBatch(Path p0, byte[] p1){ return null; }
    protected FileSystem.Statistics statistics = null;
    protected Path fixRelativePart(Path p0){ return null; }
    protected Path getInitialWorkingDirectory(){ return null; }
    protected Path resolveLink(Path p0){ return null; }
    protected PathHandle createPathHandle(FileStatus p0, Options.HandleOpt... p1){ return null; }
    protected RemoteIterator<LocatedFileStatus> listLocatedStatus(Path p0, PathFilter p1){ return null; }
    protected URI canonicalizeUri(URI p0){ return null; }
    protected URI getCanonicalUri(){ return null; }
    protected boolean primitiveMkdir(Path p0, FsPermission p1){ return false; }
    protected int getDefaultPort(){ return 0; }
    protected static FileSystem getFSofPath(Path p0, Configuration p1){ return null; }
    protected void checkPath(Path p0){}
    protected void primitiveMkdir(Path p0, FsPermission p1, boolean p2){}
    protected void processDeleteOnExit(){}
    protected void rename(Path p0, Path p1, Options.Rename... p2){}
    public AclStatus getAclStatus(Path p0){ return null; }
    public BlockLocation[] getFileBlockLocations(FileStatus p0, long p1, long p2){ return null; }
    public BlockLocation[] getFileBlockLocations(Path p0, long p1, long p2){ return null; }
    public BlockStoragePolicySpi getStoragePolicy(Path p0){ return null; }
    public Collection<? extends BlockStoragePolicySpi> getAllStoragePolicies(){ return null; }
    public Collection<FileStatus> getTrashRoots(boolean p0){ return null; }
    public ContentSummary getContentSummary(Path p0){ return null; }
    public FSDataInputStream open(Path p0){ return null; }
    public FSDataInputStream open(PathHandle p0){ return null; }
    public FSDataInputStream open(PathHandle p0, int p1){ return null; }
    public FSDataOutputStream append(Path p0){ return null; }
    public FSDataOutputStream append(Path p0, int p1){ return null; }
    public FSDataOutputStream create(Path p0){ return null; }
    public FSDataOutputStream create(Path p0, FsPermission p1, EnumSet<CreateFlag> p2, int p3, short p4, long p5, Progressable p6){ return null; }
    public FSDataOutputStream create(Path p0, FsPermission p1, EnumSet<CreateFlag> p2, int p3, short p4, long p5, Progressable p6, Options.ChecksumOpt p7){ return null; }
    public FSDataOutputStream create(Path p0, Progressable p1){ return null; }
    public FSDataOutputStream create(Path p0, boolean p1){ return null; }
    public FSDataOutputStream create(Path p0, boolean p1, int p2){ return null; }
    public FSDataOutputStream create(Path p0, boolean p1, int p2, Progressable p3){ return null; }
    public FSDataOutputStream create(Path p0, boolean p1, int p2, short p3, long p4){ return null; }
    public FSDataOutputStream create(Path p0, boolean p1, int p2, short p3, long p4, Progressable p5){ return null; }
    public FSDataOutputStream create(Path p0, short p1){ return null; }
    public FSDataOutputStream create(Path p0, short p1, Progressable p2){ return null; }
    public FSDataOutputStream createNonRecursive(Path p0, FsPermission p1, EnumSet<CreateFlag> p2, int p3, short p4, long p5, Progressable p6){ return null; }
    public FSDataOutputStream createNonRecursive(Path p0, FsPermission p1, boolean p2, int p3, short p4, long p5, Progressable p6){ return null; }
    public FSDataOutputStream createNonRecursive(Path p0, boolean p1, int p2, short p3, long p4, Progressable p5){ return null; }
    public FSDataOutputStreamBuilder appendFile(Path p0){ return null; }
    public FSDataOutputStreamBuilder createFile(Path p0){ return null; }
    public FileChecksum getFileChecksum(Path p0){ return null; }
    public FileChecksum getFileChecksum(Path p0, long p1){ return null; }
    public FileStatus getFileLinkStatus(Path p0){ return null; }
    public FileStatus[] globStatus(Path p0){ return null; }
    public FileStatus[] globStatus(Path p0, PathFilter p1){ return null; }
    public FileStatus[] listStatus(Path p0, PathFilter p1){ return null; }
    public FileStatus[] listStatus(Path[] p0){ return null; }
    public FileStatus[] listStatus(Path[] p0, PathFilter p1){ return null; }
    public FileSystem[] getChildFileSystems(){ return null; }
    public FsServerDefaults getServerDefaults(){ return null; }
    public FsServerDefaults getServerDefaults(Path p0){ return null; }
    public FsStatus getStatus(){ return null; }
    public FsStatus getStatus(Path p0){ return null; }
    public List<String> listXAttrs(Path p0){ return null; }
    public Map<String, byte[]> getXAttrs(Path p0){ return null; }
    public Map<String, byte[]> getXAttrs(Path p0, List<String> p1){ return null; }
    public Path createSnapshot(Path p0, String p1){ return null; }
    public Path getHomeDirectory(){ return null; }
    public Path getLinkTarget(Path p0){ return null; }
    public Path getTrashRoot(Path p0){ return null; }
    public Path makeQualified(Path p0){ return null; }
    public Path resolvePath(Path p0){ return null; }
    public Path startLocalOutput(Path p0, Path p1){ return null; }
    public QuotaUsage getQuotaUsage(Path p0){ return null; }
    public RemoteIterator<FileStatus> listStatusIterator(Path p0){ return null; }
    public RemoteIterator<LocatedFileStatus> listFiles(Path p0, boolean p1){ return null; }
    public RemoteIterator<LocatedFileStatus> listLocatedStatus(Path p0){ return null; }
    public RemoteIterator<Path> listCorruptFileBlocks(Path p0){ return null; }
    public StorageStatistics getStorageStatistics(){ return null; }
    public String getCanonicalServiceName(){ return null; }
    public String getName(){ return null; }
    public String getScheme(){ return null; }
    public Token<? extends Object> getDelegationToken(String p0){ return null; }
    public Token<? extends Object>[] addDelegationTokens(String p0, Credentials p1){ return null; }
    public abstract FSDataInputStream open(Path p0, int p1);
    public abstract FSDataOutputStream append(Path p0, int p1, Progressable p2);
    public abstract FSDataOutputStream create(Path p0, FsPermission p1, boolean p2, int p3, short p4, long p5, Progressable p6);
    public abstract FileStatus getFileStatus(Path p0);
    public abstract FileStatus[] listStatus(Path p0);
    public abstract Path getWorkingDirectory();
    public abstract URI getUri();
    public abstract boolean delete(Path p0, boolean p1);
    public abstract boolean mkdirs(Path p0, FsPermission p1);
    public abstract boolean rename(Path p0, Path p1);
    public abstract void setWorkingDirectory(Path p0);
    public boolean cancelDeleteOnExit(Path p0){ return false; }
    public boolean createNewFile(Path p0){ return false; }
    public boolean delete(Path p0){ return false; }
    public boolean deleteOnExit(Path p0){ return false; }
    public boolean exists(Path p0){ return false; }
    public boolean isDirectory(Path p0){ return false; }
    public boolean isFile(Path p0){ return false; }
    public boolean mkdirs(Path p0){ return false; }
    public boolean setReplication(Path p0, short p1){ return false; }
    public boolean supportsSymlinks(){ return false; }
    public boolean truncate(Path p0, long p1){ return false; }
    public byte[] getXAttr(Path p0, String p1){ return null; }
    public final Path createSnapshot(Path p0){ return null; }
    public final PathHandle getPathHandle(FileStatus p0, Options.HandleOpt... p1){ return null; }
    public long getBlockSize(Path p0){ return 0; }
    public long getDefaultBlockSize(){ return 0; }
    public long getDefaultBlockSize(Path p0){ return 0; }
    public long getLength(Path p0){ return 0; }
    public long getUsed(){ return 0; }
    public long getUsed(Path p0){ return 0; }
    public short getDefaultReplication(){ return 0; }
    public short getDefaultReplication(Path p0){ return 0; }
    public short getReplication(Path p0){ return 0; }
    public static Class<? extends FileSystem> getFileSystemClass(String p0, Configuration p1){ return null; }
    public static FSDataOutputStream create(FileSystem p0, Path p1, FsPermission p2){ return null; }
    public static FileSystem get(Configuration p0){ return null; }
    public static FileSystem get(URI p0, Configuration p1){ return null; }
    public static FileSystem get(URI p0, Configuration p1, String p2){ return null; }
    public static FileSystem getNamed(String p0, Configuration p1){ return null; }
    public static FileSystem newInstance(Configuration p0){ return null; }
    public static FileSystem newInstance(URI p0, Configuration p1){ return null; }
    public static FileSystem newInstance(URI p0, Configuration p1, String p2){ return null; }
    public static FileSystem.Statistics getStatistics(String p0, Class<? extends FileSystem> p1){ return null; }
    public static GlobalStorageStatistics getGlobalStorageStatistics(){ return null; }
    public static List<FileSystem.Statistics> getAllStatistics(){ return null; }
    public static LocalFileSystem getLocal(Configuration p0){ return null; }
    public static LocalFileSystem newInstanceLocal(Configuration p0){ return null; }
    public static Log LOG = null;
    public static Map<String, FileSystem.Statistics> getStatistics(){ return null; }
    public static String DEFAULT_FS = null;
    public static String FS_DEFAULT_NAME_KEY = null;
    public static String TRASH_PREFIX = null;
    public static String USER_HOME_PREFIX = null;
    public static URI getDefaultUri(Configuration p0){ return null; }
    public static boolean areSymlinksEnabled(){ return false; }
    public static boolean mkdirs(FileSystem p0, Path p1, FsPermission p2){ return false; }
    public static int SHUTDOWN_HOOK_PRIORITY = 0;
    public static void clearStatistics(){}
    public static void closeAll(){}
    public static void closeAllForUGI(UserGroupInformation p0){}
    public static void enableSymlinks(){}
    public static void printStatistics(){}
    public static void setDefaultUri(Configuration p0, String p1){}
    public static void setDefaultUri(Configuration p0, URI p1){}
    public void access(Path p0, FsAction p1){}
    public void close(){}
    public void completeLocalOutput(Path p0, Path p1){}
    public void concat(Path p0, Path[] p1){}
    public void copyFromLocalFile(Path p0, Path p1){}
    public void copyFromLocalFile(boolean p0, Path p1, Path p2){}
    public void copyFromLocalFile(boolean p0, boolean p1, Path p2, Path p3){}
    public void copyFromLocalFile(boolean p0, boolean p1, Path[] p2, Path p3){}
    public void copyToLocalFile(Path p0, Path p1){}
    public void copyToLocalFile(boolean p0, Path p1, Path p2){}
    public void copyToLocalFile(boolean p0, Path p1, Path p2, boolean p3){}
    public void createSymlink(Path p0, Path p1, boolean p2){}
    public void deleteSnapshot(Path p0, String p1){}
    public void initialize(URI p0, Configuration p1){}
    public void modifyAclEntries(Path p0, List<AclEntry> p1){}
    public void moveFromLocalFile(Path p0, Path p1){}
    public void moveFromLocalFile(Path[] p0, Path p1){}
    public void moveToLocalFile(Path p0, Path p1){}
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
    public void setWriteChecksum(boolean p0){}
    public void setXAttr(Path p0, String p1, byte[] p2){}
    public void setXAttr(Path p0, String p1, byte[] p2, EnumSet<XAttrSetFlag> p3){}
    public void unsetStoragePolicy(Path p0){}
    static public class DirectoryEntries
    {
        protected DirectoryEntries() {}
        public DirectoryEntries(FileStatus[] p0, byte[] p1, boolean p2){}
        public FileStatus[] getEntries(){ return null; }
        public boolean hasMore(){ return false; }
        public byte[] getToken(){ return null; }
    }
    static public class Statistics
    {
        protected Statistics() {}
        public FileSystem.Statistics.StatisticsData getData(){ return null; }
        public FileSystem.Statistics.StatisticsData getThreadStatistics(){ return null; }
        public Statistics(FileSystem.Statistics p0){}
        public Statistics(String p0){}
        public String getScheme(){ return null; }
        public String toString(){ return null; }
        public int getLargeReadOps(){ return 0; }
        public int getReadOps(){ return 0; }
        public int getWriteOps(){ return 0; }
        public long getBytesRead(){ return 0; }
        public long getBytesReadByDistance(int p0){ return 0; }
        public long getBytesWritten(){ return 0; }
        public void incrementBytesRead(long p0){}
        public void incrementBytesReadByDistance(int p0, long p1){}
        public void incrementBytesWritten(long p0){}
        public void incrementLargeReadOps(int p0){}
        public void incrementReadOps(int p0){}
        public void incrementWriteOps(int p0){}
        public void reset(){}
        static public class StatisticsData
        {
            public StatisticsData(){}
            public String toString(){ return null; }
            public int getLargeReadOps(){ return 0; }
            public int getReadOps(){ return 0; }
            public int getWriteOps(){ return 0; }
            public long getBytesRead(){ return 0; }
            public long getBytesReadDistanceOfFiveOrLarger(){ return 0; }
            public long getBytesReadDistanceOfOneOrTwo(){ return 0; }
            public long getBytesReadDistanceOfThreeOrFour(){ return 0; }
            public long getBytesReadLocalHost(){ return 0; }
            public long getBytesWritten(){ return 0; }
        }
    }
}
