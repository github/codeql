// Generated automatically from net.lingala.zip4j.model.ZipParameters for testing purposes

package net.lingala.zip4j.model;

import net.lingala.zip4j.model.ExcludeFileFilter;
import net.lingala.zip4j.model.enums.AesKeyStrength;
import net.lingala.zip4j.model.enums.AesVersion;
import net.lingala.zip4j.model.enums.CompressionLevel;
import net.lingala.zip4j.model.enums.CompressionMethod;
import net.lingala.zip4j.model.enums.EncryptionMethod;

public class ZipParameters
{
    public AesKeyStrength getAesKeyStrength(){ return null; }
    public AesVersion getAesVersion(){ return null; }
    public CompressionLevel getCompressionLevel(){ return null; }
    public CompressionMethod getCompressionMethod(){ return null; }
    public EncryptionMethod getEncryptionMethod(){ return null; }
    public ExcludeFileFilter getExcludeFileFilter(){ return null; }
    public String getDefaultFolderPath(){ return null; }
    public String getFileComment(){ return null; }
    public String getFileNameInZip(){ return null; }
    public String getRootFolderNameInZip(){ return null; }
    public ZipParameters(){}
    public ZipParameters(ZipParameters p0){}
    public ZipParameters.SymbolicLinkAction getSymbolicLinkAction(){ return null; }
    public boolean isEncryptFiles(){ return false; }
    public boolean isIncludeRootFolder(){ return false; }
    public boolean isOverrideExistingFilesInZip(){ return false; }
    public boolean isReadHiddenFiles(){ return false; }
    public boolean isReadHiddenFolders(){ return false; }
    public boolean isUnixMode(){ return false; }
    public boolean isWriteExtendedLocalFileHeader(){ return false; }
    public long getEntryCRC(){ return 0; }
    public long getEntrySize(){ return 0; }
    public long getLastModifiedFileTime(){ return 0; }
    public void setAesKeyStrength(AesKeyStrength p0){}
    public void setAesVersion(AesVersion p0){}
    public void setCompressionLevel(CompressionLevel p0){}
    public void setCompressionMethod(CompressionMethod p0){}
    public void setDefaultFolderPath(String p0){}
    public void setEncryptFiles(boolean p0){}
    public void setEncryptionMethod(EncryptionMethod p0){}
    public void setEntryCRC(long p0){}
    public void setEntrySize(long p0){}
    public void setExcludeFileFilter(ExcludeFileFilter p0){}
    public void setFileComment(String p0){}
    public void setFileNameInZip(String p0){}
    public void setIncludeRootFolder(boolean p0){}
    public void setLastModifiedFileTime(long p0){}
    public void setOverrideExistingFilesInZip(boolean p0){}
    public void setReadHiddenFiles(boolean p0){}
    public void setReadHiddenFolders(boolean p0){}
    public void setRootFolderNameInZip(String p0){}
    public void setSymbolicLinkAction(ZipParameters.SymbolicLinkAction p0){}
    public void setUnixMode(boolean p0){}
    public void setWriteExtendedLocalFileHeader(boolean p0){}
    static public enum SymbolicLinkAction
    {
        INCLUDE_LINKED_FILE_ONLY, INCLUDE_LINK_AND_LINKED_FILE, INCLUDE_LINK_ONLY;
        private SymbolicLinkAction() {}
    }
}
