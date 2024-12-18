// Generated automatically from org.apache.commons.compress.archivers.ar.ArArchiveEntry for testing purposes

package org.apache.commons.compress.archivers.ar;

import java.io.File;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.util.Date;
import org.apache.commons.compress.archivers.ArchiveEntry;

public class ArArchiveEntry implements ArchiveEntry
{
    protected ArArchiveEntry() {}
    public ArArchiveEntry(File p0, String p1){}
    public ArArchiveEntry(Path p0, String p1, LinkOption... p2){}
    public ArArchiveEntry(String p0, long p1){}
    public ArArchiveEntry(String p0, long p1, int p2, int p3, int p4, long p5){}
    public Date getLastModifiedDate(){ return null; }
    public String getName(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isDirectory(){ return false; }
    public int getGroupId(){ return 0; }
    public int getMode(){ return 0; }
    public int getUserId(){ return 0; }
    public int hashCode(){ return 0; }
    public long getLastModified(){ return 0; }
    public long getLength(){ return 0; }
    public long getSize(){ return 0; }
    public static String HEADER = null;
    public static String TRAILER = null;
}
