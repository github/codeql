// Generated automatically from org.apache.commons.compress.archivers.zip.ZipArchiveInputStream for testing purposes

package org.apache.commons.compress.archivers.zip;

import java.io.InputStream;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.utils.InputStreamStatistics;

public class ZipArchiveInputStream extends ArchiveInputStream implements InputStreamStatistics
{
    protected ZipArchiveInputStream() {}
    public ArchiveEntry getNextEntry(){ return null; }
    public ZipArchiveEntry getNextZipEntry(){ return null; }
    public ZipArchiveInputStream(InputStream p0){}
    public ZipArchiveInputStream(InputStream p0, String p1){}
    public ZipArchiveInputStream(InputStream p0, String p1, boolean p2){}
    public ZipArchiveInputStream(InputStream p0, String p1, boolean p2, boolean p3){}
    public ZipArchiveInputStream(InputStream p0, String p1, boolean p2, boolean p3, boolean p4){}
    public boolean canReadEntryData(ArchiveEntry p0){ return false; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public long getCompressedCount(){ return 0; }
    public long getUncompressedCount(){ return 0; }
    public long skip(long p0){ return 0; }
    public static boolean matches(byte[] p0, int p1){ return false; }
    public void close(){}
}
