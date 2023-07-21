// Generated automatically from org.apache.tools.zip.ZipEntry for testing purposes

package org.apache.tools.zip;

import java.io.File;
import java.util.Date;
import org.apache.tools.zip.GeneralPurposeBit;
import org.apache.tools.zip.UnparseableExtraFieldData;
import org.apache.tools.zip.ZipExtraField;
import org.apache.tools.zip.ZipShort;

public class ZipEntry extends java.util.zip.ZipEntry implements Cloneable {
    protected ZipEntry() {
        super("");
    }

    protected void setExtra() {}

    protected void setName(String p0) {}

    protected void setName(String p0, byte[] p1) {}

    protected void setPlatform(int p0) {}

    public Date getLastModifiedDate() {
        return null;
    }

    public GeneralPurposeBit getGeneralPurposeBit() {
        return null;
    }

    public Object clone() {
        return null;
    }

    public String getName() {
        return null;
    }

    public UnparseableExtraFieldData getUnparseableExtraFieldData() {
        return null;
    }

    public ZipEntry(File p0, String p1) {
        super("");
    }

    public ZipEntry(String p0) {
        super("");
    }

    public ZipEntry(java.util.zip.ZipEntry p0) {
        super("");
    }

    public ZipEntry(org.apache.tools.zip.ZipEntry p0) {
        super("");
    }

    public ZipExtraField getExtraField(ZipShort p0) {
        return null;
    }

    public ZipExtraField[] getExtraFields() {
        return null;
    }

    public ZipExtraField[] getExtraFields(boolean p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isDirectory() {
        return false;
    }

    public byte[] getCentralDirectoryExtra() {
        return null;
    }

    public byte[] getLocalFileDataExtra() {
        return null;
    }

    public byte[] getRawName() {
        return null;
    }

    public int getInternalAttributes() {
        return 0;
    }

    public int getMethod() {
        return 0;
    }

    public int getPlatform() {
        return 0;
    }

    public int getUnixMode() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getExternalAttributes() {
        return 0;
    }

    public long getSize() {
        return 0;
    }

    public static int CRC_UNKNOWN = 0;
    public static int PLATFORM_FAT = 0;
    public static int PLATFORM_UNIX = 0;

    public void addAsFirstExtraField(ZipExtraField p0) {}

    public void addExtraField(ZipExtraField p0) {}

    public void removeExtraField(ZipShort p0) {}

    public void removeUnparseableExtraFieldData() {}

    public void setCentralDirectoryExtra(byte[] p0) {}

    public void setComprSize(long p0) {}

    public void setExternalAttributes(long p0) {}

    public void setExtra(byte[] p0) {}

    public void setExtraFields(ZipExtraField[] p0) {}

    public void setGeneralPurposeBit(GeneralPurposeBit p0) {}

    public void setInternalAttributes(int p0) {}

    public void setMethod(int p0) {}

    public void setSize(long p0) {}

    public void setUnixMode(int p0) {}
}
