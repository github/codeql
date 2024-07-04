// Generated automatically from net.lingala.zip4j.model.AbstractFileHeader for testing purposes

package net.lingala.zip4j.model;

import java.util.List;
import net.lingala.zip4j.model.AESExtraDataRecord;
import net.lingala.zip4j.model.ExtraDataRecord;
import net.lingala.zip4j.model.Zip64ExtendedInfo;
import net.lingala.zip4j.model.ZipHeader;
import net.lingala.zip4j.model.enums.CompressionMethod;
import net.lingala.zip4j.model.enums.EncryptionMethod;

abstract public class AbstractFileHeader extends ZipHeader
{
    public AESExtraDataRecord getAesExtraDataRecord(){ return null; }
    public AbstractFileHeader(){}
    public CompressionMethod getCompressionMethod(){ return null; }
    public EncryptionMethod getEncryptionMethod(){ return null; }
    public List<ExtraDataRecord> getExtraDataRecords(){ return null; }
    public String getFileName(){ return null; }
    public Zip64ExtendedInfo getZip64ExtendedInfo(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isDataDescriptorExists(){ return false; }
    public boolean isDirectory(){ return false; }
    public boolean isEncrypted(){ return false; }
    public boolean isFileNameUTF8Encoded(){ return false; }
    public byte[] getGeneralPurposeFlag(){ return null; }
    public int getExtraFieldLength(){ return 0; }
    public int getFileNameLength(){ return 0; }
    public int getVersionNeededToExtract(){ return 0; }
    public long getCompressedSize(){ return 0; }
    public long getCrc(){ return 0; }
    public long getLastModifiedTime(){ return 0; }
    public long getLastModifiedTimeEpoch(){ return 0; }
    public long getUncompressedSize(){ return 0; }
    public void setAesExtraDataRecord(AESExtraDataRecord p0){}
    public void setCompressedSize(long p0){}
    public void setCompressionMethod(CompressionMethod p0){}
    public void setCrc(long p0){}
    public void setDataDescriptorExists(boolean p0){}
    public void setDirectory(boolean p0){}
    public void setEncrypted(boolean p0){}
    public void setEncryptionMethod(EncryptionMethod p0){}
    public void setExtraDataRecords(List<ExtraDataRecord> p0){}
    public void setExtraFieldLength(int p0){}
    public void setFileName(String p0){}
    public void setFileNameLength(int p0){}
    public void setFileNameUTF8Encoded(boolean p0){}
    public void setGeneralPurposeFlag(byte[] p0){}
    public void setLastModifiedTime(long p0){}
    public void setUncompressedSize(long p0){}
    public void setVersionNeededToExtract(int p0){}
    public void setZip64ExtendedInfo(Zip64ExtendedInfo p0){}
}
