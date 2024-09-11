// Generated automatically from org.apache.commons.compress.archivers.cpio.CpioArchiveEntry for testing purposes

package org.apache.commons.compress.archivers.cpio;

import java.io.File;
import java.nio.charset.Charset;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.util.Date;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.cpio.CpioConstants;

public class CpioArchiveEntry implements ArchiveEntry, CpioConstants
{
    protected CpioArchiveEntry() {}
    public CpioArchiveEntry(File p0, String p1){}
    public CpioArchiveEntry(Path p0, String p1, LinkOption... p2){}
    public CpioArchiveEntry(String p0){}
    public CpioArchiveEntry(String p0, long p1){}
    public CpioArchiveEntry(short p0){}
    public CpioArchiveEntry(short p0, File p1, String p2){}
    public CpioArchiveEntry(short p0, Path p1, String p2, LinkOption... p3){}
    public CpioArchiveEntry(short p0, String p1){}
    public CpioArchiveEntry(short p0, String p1, long p2){}
    public Date getLastModifiedDate(){ return null; }
    public String getName(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isBlockDevice(){ return false; }
    public boolean isCharacterDevice(){ return false; }
    public boolean isDirectory(){ return false; }
    public boolean isNetwork(){ return false; }
    public boolean isPipe(){ return false; }
    public boolean isRegularFile(){ return false; }
    public boolean isSocket(){ return false; }
    public boolean isSymbolicLink(){ return false; }
    public int getAlignmentBoundary(){ return 0; }
    public int getDataPadCount(){ return 0; }
    public int getHeaderPadCount(){ return 0; }
    public int getHeaderPadCount(Charset p0){ return 0; }
    public int getHeaderPadCount(long p0){ return 0; }
    public int getHeaderSize(){ return 0; }
    public int hashCode(){ return 0; }
    public long getChksum(){ return 0; }
    public long getDevice(){ return 0; }
    public long getDeviceMaj(){ return 0; }
    public long getDeviceMin(){ return 0; }
    public long getGID(){ return 0; }
    public long getInode(){ return 0; }
    public long getMode(){ return 0; }
    public long getNumberOfLinks(){ return 0; }
    public long getRemoteDevice(){ return 0; }
    public long getRemoteDeviceMaj(){ return 0; }
    public long getRemoteDeviceMin(){ return 0; }
    public long getSize(){ return 0; }
    public long getTime(){ return 0; }
    public long getUID(){ return 0; }
    public short getFormat(){ return 0; }
    public void setChksum(long p0){}
    public void setDevice(long p0){}
    public void setDeviceMaj(long p0){}
    public void setDeviceMin(long p0){}
    public void setGID(long p0){}
    public void setInode(long p0){}
    public void setMode(long p0){}
    public void setName(String p0){}
    public void setNumberOfLinks(long p0){}
    public void setRemoteDevice(long p0){}
    public void setRemoteDeviceMaj(long p0){}
    public void setRemoteDeviceMin(long p0){}
    public void setSize(long p0){}
    public void setTime(FileTime p0){}
    public void setTime(long p0){}
    public void setUID(long p0){}
}
