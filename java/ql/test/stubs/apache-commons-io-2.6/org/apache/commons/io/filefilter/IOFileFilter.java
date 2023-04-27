// Generated automatically from org.apache.commons.io.filefilter.IOFileFilter for testing purposes

package org.apache.commons.io.filefilter;

import java.io.File;
import java.io.FileFilter;
import java.io.FilenameFilter;
import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import org.apache.commons.io.file.PathFilter;

public interface IOFileFilter extends FileFilter, FilenameFilter, PathFilter
{
    boolean accept(File p0);
    boolean accept(File p0, String p1);
    default FileVisitResult accept(Path p0, BasicFileAttributes p1){ return null; }
    default IOFileFilter and(IOFileFilter p0){ return null; }
    default IOFileFilter negate(){ return null; }
    default IOFileFilter or(IOFileFilter p0){ return null; }
    static String[] EMPTY_STRING_ARRAY = null;
}
