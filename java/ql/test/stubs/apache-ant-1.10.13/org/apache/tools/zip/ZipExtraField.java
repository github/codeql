// Generated automatically from org.apache.tools.zip.ZipExtraField for testing purposes

package org.apache.tools.zip;

import org.apache.tools.zip.ZipShort;

public interface ZipExtraField
{
    ZipShort getCentralDirectoryLength();
    ZipShort getHeaderId();
    ZipShort getLocalFileDataLength();
    byte[] getCentralDirectoryData();
    byte[] getLocalFileDataData();
    void parseFromLocalFileData(byte[] p0, int p1, int p2);
}
