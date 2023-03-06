// Generated automatically from org.apache.hadoop.fs.LocalFileSystem for testing purposes

package org.apache.hadoop.fs;

import java.io.File;
import java.net.URI;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.ChecksumFileSystem;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;

public class LocalFileSystem extends ChecksumFileSystem
{
    public File pathToFile(Path p0){ return null; }
    public FileStatus getFileLinkStatus(Path p0){ return null; }
    public FileSystem getRaw(){ return null; }
    public LocalFileSystem(){}
    public LocalFileSystem(FileSystem p0){}
    public Path getLinkTarget(Path p0){ return null; }
    public String getScheme(){ return null; }
    public boolean reportChecksumFailure(Path p0, FSDataInputStream p1, long p2, FSDataInputStream p3, long p4){ return false; }
    public boolean supportsSymlinks(){ return false; }
    public void copyFromLocalFile(boolean p0, Path p1, Path p2){}
    public void copyToLocalFile(boolean p0, Path p1, Path p2){}
    public void createSymlink(Path p0, Path p1, boolean p2){}
    public void initialize(URI p0, Configuration p1){}
}
