// Generated automatically from org.apache.tools.zip.UnparseableExtraFieldData for testing purposes

package org.apache.tools.zip;

import org.apache.tools.zip.CentralDirectoryParsingZipExtraField;
import org.apache.tools.zip.ZipShort;

public class UnparseableExtraFieldData implements CentralDirectoryParsingZipExtraField
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
