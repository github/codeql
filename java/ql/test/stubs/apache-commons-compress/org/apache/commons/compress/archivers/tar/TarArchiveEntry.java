// Generated automatically from org.apache.commons.compress.archivers.tar.TarArchiveEntry for testing purposes

package org.apache.commons.compress.archivers.tar;

import java.io.File;
import java.util.Date;
import java.util.Map;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarConstants;
import org.apache.commons.compress.archivers.zip.ZipEncoding;

public class TarArchiveEntry implements ArchiveEntry, TarConstants
{
    protected TarArchiveEntry() {}
    public Date getLastModifiedDate(){ return null; }
    public Date getModTime(){ return null; }
    public File getFile(){ return null; }
    public Map<String, String> getExtraPaxHeaders(){ return null; }
    public String getExtraPaxHeader(String p0){ return null; }
    public String getGroupName(){ return null; }
    public String getLinkName(){ return null; }
    public String getName(){ return null; }
    public String getUserName(){ return null; }
    public TarArchiveEntry(File p0){}
    public TarArchiveEntry(File p0, String p1){}
    public TarArchiveEntry(String p0){}
    public TarArchiveEntry(String p0, boolean p1){}
    public TarArchiveEntry(String p0, byte p1){}
    public TarArchiveEntry(String p0, byte p1, boolean p2){}
    public TarArchiveEntry(byte[] p0){}
    public TarArchiveEntry(byte[] p0, ZipEncoding p1){}
    public TarArchiveEntry(byte[] p0, ZipEncoding p1, boolean p2){}
    public TarArchiveEntry[] getDirectoryEntries(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean equals(TarArchiveEntry p0){ return false; }
    public boolean isBlockDevice(){ return false; }
    public boolean isCharacterDevice(){ return false; }
    public boolean isCheckSumOK(){ return false; }
    public boolean isDescendent(TarArchiveEntry p0){ return false; }
    public boolean isDirectory(){ return false; }
    public boolean isExtended(){ return false; }
    public boolean isFIFO(){ return false; }
    public boolean isFile(){ return false; }
    public boolean isGNULongLinkEntry(){ return false; }
    public boolean isGNULongNameEntry(){ return false; }
    public boolean isGNUSparse(){ return false; }
    public boolean isGlobalPaxHeader(){ return false; }
    public boolean isLink(){ return false; }
    public boolean isOldGNUSparse(){ return false; }
    public boolean isPaxGNUSparse(){ return false; }
    public boolean isPaxHeader(){ return false; }
    public boolean isSparse(){ return false; }
    public boolean isStarSparse(){ return false; }
    public boolean isSymbolicLink(){ return false; }
    public int getDevMajor(){ return 0; }
    public int getDevMinor(){ return 0; }
    public int getGroupId(){ return 0; }
    public int getMode(){ return 0; }
    public int getUserId(){ return 0; }
    public int hashCode(){ return 0; }
    public long getLongGroupId(){ return 0; }
    public long getLongUserId(){ return 0; }
    public long getRealSize(){ return 0; }
    public long getSize(){ return 0; }
    public static int DEFAULT_DIR_MODE = 0;
    public static int DEFAULT_FILE_MODE = 0;
    public static int MAX_NAMELEN = 0;
    public static int MILLIS_PER_SECOND = 0;
    public static long UNKNOWN = 0;
    public void addPaxHeader(String p0, String p1){}
    public void clearExtraPaxHeaders(){}
    public void parseTarHeader(byte[] p0){}
    public void parseTarHeader(byte[] p0, ZipEncoding p1){}
    public void setDevMajor(int p0){}
    public void setDevMinor(int p0){}
    public void setGroupId(int p0){}
    public void setGroupId(long p0){}
    public void setGroupName(String p0){}
    public void setIds(int p0, int p1){}
    public void setLinkName(String p0){}
    public void setModTime(Date p0){}
    public void setModTime(long p0){}
    public void setMode(int p0){}
    public void setName(String p0){}
    public void setNames(String p0, String p1){}
    public void setSize(long p0){}
    public void setUserId(int p0){}
    public void setUserId(long p0){}
    public void setUserName(String p0){}
    public void writeEntryHeader(byte[] p0){}
    public void writeEntryHeader(byte[] p0, ZipEncoding p1, boolean p2){}
}
