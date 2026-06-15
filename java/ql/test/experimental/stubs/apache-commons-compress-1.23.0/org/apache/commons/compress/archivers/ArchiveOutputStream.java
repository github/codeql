// Generated automatically from org.apache.commons.compress.archivers.ArchiveOutputStream for testing purposes

package org.apache.commons.compress.archivers;

import java.io.File;
import java.io.OutputStream;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import org.apache.commons.compress.archivers.ArchiveEntry;

abstract public class ArchiveOutputStream extends OutputStream
{
    protected void count(int p0){}
    protected void count(long p0){}
    public ArchiveEntry createArchiveEntry(Path p0, String p1, LinkOption... p2){ return null; }
    public ArchiveOutputStream(){}
    public abstract ArchiveEntry createArchiveEntry(File p0, String p1);
    public abstract void closeArchiveEntry();
    public abstract void finish();
    public abstract void putArchiveEntry(ArchiveEntry p0);
    public boolean canWriteEntryData(ArchiveEntry p0){ return false; }
    public int getCount(){ return 0; }
    public long getBytesWritten(){ return 0; }
    public void write(int p0){}
}
