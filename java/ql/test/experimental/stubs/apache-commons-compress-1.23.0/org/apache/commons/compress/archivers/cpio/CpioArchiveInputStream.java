// Generated automatically from org.apache.commons.compress.archivers.cpio.CpioArchiveInputStream for testing purposes

package org.apache.commons.compress.archivers.cpio;

import java.io.InputStream;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.cpio.CpioArchiveEntry;
import org.apache.commons.compress.archivers.cpio.CpioConstants;

public class CpioArchiveInputStream extends ArchiveInputStream implements CpioConstants
{
    protected CpioArchiveInputStream() {}
    public ArchiveEntry getNextEntry(){ return null; }
    public CpioArchiveEntry getNextCPIOEntry(){ return null; }
    public CpioArchiveInputStream(InputStream p0){}
    public CpioArchiveInputStream(InputStream p0, String p1){}
    public CpioArchiveInputStream(InputStream p0, int p1){}
    public CpioArchiveInputStream(InputStream p0, int p1, String p2){}
    public int available(){ return 0; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public long skip(long p0){ return 0; }
    public static boolean matches(byte[] p0, int p1){ return false; }
    public void close(){}
}
