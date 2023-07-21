// Generated automatically from org.apache.tools.ant.util.FileUtils for testing purposes

package org.apache.tools.ant.util;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;
import java.net.URL;
import java.net.URLConnection;
import java.nio.channels.Channel;
import java.nio.file.Path;
import java.util.List;
import java.util.Optional;
import java.util.Vector;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.FilterChain;
import org.apache.tools.ant.types.FilterSetCollection;

public class FileUtils
{
    protected FileUtils(){}
    public File createTempFile(Project p0, String p1, String p2, File p3, boolean p4, boolean p5){ return null; }
    public File createTempFile(String p0, String p1, File p2){ return null; }
    public File createTempFile(String p0, String p1, File p2, boolean p3){ return null; }
    public File createTempFile(String p0, String p1, File p2, boolean p3, boolean p4){ return null; }
    public File getParentFile(File p0){ return null; }
    public File normalize(String p0){ return null; }
    public File resolveFile(File p0, String p1){ return null; }
    public String fromURI(String p0){ return null; }
    public String getDefaultEncoding(){ return null; }
    public String removeLeadingPath(File p0, File p1){ return null; }
    public String toURI(String p0){ return null; }
    public String toVMSPath(File p0){ return null; }
    public String[] dissect(String p0){ return null; }
    public URL getFileURL(File p0){ return null; }
    public boolean areSame(File p0, File p1){ return false; }
    public boolean contentEquals(File p0, File p1){ return false; }
    public boolean contentEquals(File p0, File p1, boolean p2){ return false; }
    public boolean createNewFile(File p0){ return false; }
    public boolean createNewFile(File p0, boolean p1){ return false; }
    public boolean fileNameEquals(File p0, File p1){ return false; }
    public boolean hasErrorInCase(File p0){ return false; }
    public boolean isLeadingPath(File p0, File p1){ return false; }
    public boolean isLeadingPath(File p0, File p1, boolean p2){ return false; }
    public boolean isSymbolicLink(File p0, String p1){ return false; }
    public boolean isUpToDate(File p0, File p1){ return false; }
    public boolean isUpToDate(File p0, File p1, long p2){ return false; }
    public boolean isUpToDate(long p0, long p1){ return false; }
    public boolean isUpToDate(long p0, long p1, long p2){ return false; }
    public boolean tryHardToDelete(File p0){ return false; }
    public boolean tryHardToDelete(File p0, boolean p1){ return false; }
    public long getFileTimestampGranularity(){ return 0; }
    public static FileUtils getFileUtils(){ return null; }
    public static FileUtils newFileUtils(){ return null; }
    public static Optional<Boolean> isCaseSensitiveFileSystem(Path p0){ return null; }
    public static OutputStream newOutputStream(Path p0, boolean p1){ return null; }
    public static String getPath(List<String> p0){ return null; }
    public static String getPath(List<String> p0, char p1){ return null; }
    public static String getRelativePath(File p0, File p1){ return null; }
    public static String readFully(Reader p0){ return null; }
    public static String readFully(Reader p0, int p1){ return null; }
    public static String safeReadFully(Reader p0){ return null; }
    public static String translatePath(String p0){ return null; }
    public static String[] getPathStack(String p0){ return null; }
    public static boolean isAbsolutePath(String p0){ return false; }
    public static boolean isContextRelativePath(String p0){ return false; }
    public static long FAT_FILE_TIMESTAMP_GRANULARITY = 0;
    public static long NTFS_FILE_TIMESTAMP_GRANULARITY = 0;
    public static long UNIX_FILE_TIMESTAMP_GRANULARITY = 0;
    public static void close(AutoCloseable p0){}
    public static void close(Channel p0){}
    public static void close(InputStream p0){}
    public static void close(OutputStream p0){}
    public static void close(Reader p0){}
    public static void close(URLConnection p0){}
    public static void close(Writer p0){}
    public static void delete(File p0){}
    public void copyFile(File p0, File p1){}
    public void copyFile(File p0, File p1, FilterSetCollection p2){}
    public void copyFile(File p0, File p1, FilterSetCollection p2, Vector<FilterChain> p3, boolean p4, boolean p5, String p6, Project p7){}
    public void copyFile(File p0, File p1, FilterSetCollection p2, Vector<FilterChain> p3, boolean p4, boolean p5, String p6, String p7, Project p8){}
    public void copyFile(File p0, File p1, FilterSetCollection p2, Vector<FilterChain> p3, boolean p4, boolean p5, boolean p6, String p7, String p8, Project p9){}
    public void copyFile(File p0, File p1, FilterSetCollection p2, Vector<FilterChain> p3, boolean p4, boolean p5, boolean p6, String p7, String p8, Project p9, boolean p10){}
    public void copyFile(File p0, File p1, FilterSetCollection p2, boolean p3){}
    public void copyFile(File p0, File p1, FilterSetCollection p2, boolean p3, boolean p4){}
    public void copyFile(File p0, File p1, FilterSetCollection p2, boolean p3, boolean p4, String p5){}
    public void copyFile(String p0, String p1){}
    public void copyFile(String p0, String p1, FilterSetCollection p2){}
    public void copyFile(String p0, String p1, FilterSetCollection p2, Vector<FilterChain> p3, boolean p4, boolean p5, String p6, Project p7){}
    public void copyFile(String p0, String p1, FilterSetCollection p2, Vector<FilterChain> p3, boolean p4, boolean p5, String p6, String p7, Project p8){}
    public void copyFile(String p0, String p1, FilterSetCollection p2, boolean p3){}
    public void copyFile(String p0, String p1, FilterSetCollection p2, boolean p3, boolean p4){}
    public void copyFile(String p0, String p1, FilterSetCollection p2, boolean p3, boolean p4, String p5){}
    public void rename(File p0, File p1){}
    public void setFileLastModified(File p0, long p1){}
}
