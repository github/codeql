// Generated automatically from org.apache.commons.compress.archivers.zip.ZipArchiveEntry for testing purposes

package org.apache.commons.compress.archivers.zip;

import java.io.File;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.util.Date;
import java.util.zip.ZipEntry;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.EntryStreamOffsets;
import org.apache.commons.compress.archivers.zip.ExtraFieldParsingBehavior;
import org.apache.commons.compress.archivers.zip.GeneralPurposeBit;
import org.apache.commons.compress.archivers.zip.UnparseableExtraFieldData;
import org.apache.commons.compress.archivers.zip.ZipExtraField;
import org.apache.commons.compress.archivers.zip.ZipShort;

public class ZipArchiveEntry extends ZipEntry implements ArchiveEntry, EntryStreamOffsets
{
    protected ZipArchiveEntry(){super("");}
    protected int getAlignment(){ return 0; }
    protected long getLocalHeaderOffset(){ return 0; }
    protected void setDataOffset(long p0){}
    protected void setExtra(){}
    protected void setLocalHeaderOffset(long p0){}
    protected void setName(String p0){}
    protected void setName(String p0, byte[] p1){}
    protected void setPlatform(int p0){}
    protected void setStreamContiguous(boolean p0){}
    public Date getLastModifiedDate(){ return null; }
    public GeneralPurposeBit getGeneralPurposeBit(){ return null; }
    public Object clone(){ return null; }
    public String getName(){ return null; }
    public UnparseableExtraFieldData getUnparseableExtraFieldData(){ return null; }
    public ZipArchiveEntry(File p0, String p1){super("");}
    public ZipArchiveEntry(Path p0, String p1, LinkOption... p2){super("");}
    public ZipArchiveEntry(String p0){super("");}
    public ZipArchiveEntry(ZipArchiveEntry p0){super("");}
    public ZipArchiveEntry(ZipEntry p0){super("");}
    public ZipArchiveEntry.CommentSource getCommentSource(){ return null; }
    public ZipArchiveEntry.NameSource getNameSource(){ return null; }
    public ZipEntry setCreationTime(FileTime p0){ return null; }
    public ZipEntry setLastAccessTime(FileTime p0){ return null; }
    public ZipEntry setLastModifiedTime(FileTime p0){ return null; }
    public ZipExtraField getExtraField(ZipShort p0){ return null; }
    public ZipExtraField[] getExtraFields(){ return null; }
    public ZipExtraField[] getExtraFields(ExtraFieldParsingBehavior p0){ return null; }
    public ZipExtraField[] getExtraFields(boolean p0){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isDirectory(){ return false; }
    public boolean isStreamContiguous(){ return false; }
    public boolean isUnixSymlink(){ return false; }
    public byte[] getCentralDirectoryExtra(){ return null; }
    public byte[] getLocalFileDataExtra(){ return null; }
    public byte[] getRawName(){ return null; }
    public int getInternalAttributes(){ return 0; }
    public int getMethod(){ return 0; }
    public int getPlatform(){ return 0; }
    public int getRawFlag(){ return 0; }
    public int getUnixMode(){ return 0; }
    public int getVersionMadeBy(){ return 0; }
    public int getVersionRequired(){ return 0; }
    public int hashCode(){ return 0; }
    public long getDataOffset(){ return 0; }
    public long getDiskNumberStart(){ return 0; }
    public long getExternalAttributes(){ return 0; }
    public long getSize(){ return 0; }
    public long getTime(){ return 0; }
    public static int CRC_UNKNOWN = 0;
    public static int PLATFORM_FAT = 0;
    public static int PLATFORM_UNIX = 0;
    public void addAsFirstExtraField(ZipExtraField p0){}
    public void addExtraField(ZipExtraField p0){}
    public void removeExtraField(ZipShort p0){}
    public void removeUnparseableExtraFieldData(){}
    public void setAlignment(int p0){}
    public void setCentralDirectoryExtra(byte[] p0){}
    public void setCommentSource(ZipArchiveEntry.CommentSource p0){}
    public void setDiskNumberStart(long p0){}
    public void setExternalAttributes(long p0){}
    public void setExtra(byte[] p0){}
    public void setExtraFields(ZipExtraField[] p0){}
    public void setGeneralPurposeBit(GeneralPurposeBit p0){}
    public void setInternalAttributes(int p0){}
    public void setMethod(int p0){}
    public void setNameSource(ZipArchiveEntry.NameSource p0){}
    public void setRawFlag(int p0){}
    public void setSize(long p0){}
    public void setTime(FileTime p0){}
    public void setTime(long p0){}
    public void setUnixMode(int p0){}
    public void setVersionMadeBy(int p0){}
    public void setVersionRequired(int p0){}
    static public enum CommentSource
    {
        COMMENT, UNICODE_EXTRA_FIELD;
        private CommentSource() {}
    }
    static public enum NameSource
    {
        NAME, NAME_WITH_EFS_FLAG, UNICODE_EXTRA_FIELD;
        private NameSource() {}
    }
}
