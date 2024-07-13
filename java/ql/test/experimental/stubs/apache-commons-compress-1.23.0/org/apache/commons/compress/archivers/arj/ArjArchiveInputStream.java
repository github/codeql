// Generated automatically from org.apache.commons.compress.archivers.arj.ArjArchiveInputStream for testing purposes

package org.apache.commons.compress.archivers.arj;

import java.io.InputStream;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.arj.ArjArchiveEntry;

public class ArjArchiveInputStream extends ArchiveInputStream
{
    protected ArjArchiveInputStream() {}
    public ArjArchiveEntry getNextEntry(){ return null; }
    public ArjArchiveInputStream(InputStream p0){}
    public ArjArchiveInputStream(InputStream p0, String p1){}
    public String getArchiveComment(){ return null; }
    public String getArchiveName(){ return null; }
    public boolean canReadEntryData(ArchiveEntry p0){ return false; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public static boolean matches(byte[] p0, int p1){ return false; }
    public void close(){}
}
