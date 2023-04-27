// Generated automatically from org.apache.hadoop.fs.Path for testing purposes

package org.apache.hadoop.fs;

import java.io.ObjectInputValidation;
import java.io.Serializable;
import java.net.URI;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;

public class Path implements Comparable, ObjectInputValidation, Serializable
{
    protected Path() {}
    public FileSystem getFileSystem(Configuration p0){ return null; }
    public Path getParent(){ return null; }
    public Path makeQualified(FileSystem p0){ return null; }
    public Path makeQualified(URI p0, Path p1){ return null; }
    public Path suffix(String p0){ return null; }
    public Path(Path p0, Path p1){}
    public Path(Path p0, String p1){}
    public Path(String p0){}
    public Path(String p0, Path p1){}
    public Path(String p0, String p1){}
    public Path(String p0, String p1, String p2){}
    public Path(URI p0){}
    public String getName(){ return null; }
    public String toString(){ return null; }
    public URI toUri(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isAbsolute(){ return false; }
    public boolean isAbsoluteAndSchemeAuthorityNull(){ return false; }
    public boolean isRoot(){ return false; }
    public boolean isUriPathAbsolute(){ return false; }
    public int compareTo(Object p0){ return 0; }
    public int depth(){ return 0; }
    public int hashCode(){ return 0; }
    public static Path getPathWithoutSchemeAndAuthority(Path p0){ return null; }
    public static Path mergePaths(Path p0, Path p1){ return null; }
    public static String CUR_DIR = null;
    public static String SEPARATOR = null;
    public static boolean WINDOWS = false;
    public static boolean isWindowsAbsolutePath(String p0, boolean p1){ return false; }
    public static char SEPARATOR_CHAR = '0';
    public void validateObject(){}
}
