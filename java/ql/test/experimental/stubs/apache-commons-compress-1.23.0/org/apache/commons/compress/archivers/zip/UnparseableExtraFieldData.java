// Generated automatically from org.apache.commons.compress.archivers.zip.UnparseableExtraFieldData for testing purposes

package org.apache.commons.compress.archivers.zip;

import org.apache.commons.compress.archivers.zip.ZipExtraField;
import org.apache.commons.compress.archivers.zip.ZipShort;

public class UnparseableExtraFieldData implements ZipExtraField
{
    public UnparseableExtraFieldData(){}
    public ZipShort getCentralDirectoryLength(){ return null; }
    public ZipShort getHeaderId(){ return null; }
    public ZipShort getLocalFileDataLength(){ return null; }
    public byte[] getCentralDirectoryData(){ return null; }
    public byte[] getLocalFileDataData(){ return null; }
    public void parseFromCentralDirectoryData(byte[] p0, int p1, int p2){}
    public void parseFromLocalFileData(byte[] p0, int p1, int p2){}
}
