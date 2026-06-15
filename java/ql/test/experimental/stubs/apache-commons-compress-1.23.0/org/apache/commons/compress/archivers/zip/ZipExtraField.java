// Generated automatically from org.apache.commons.compress.archivers.zip.ZipExtraField for testing purposes

package org.apache.commons.compress.archivers.zip;

import org.apache.commons.compress.archivers.zip.ZipShort;

public interface ZipExtraField
{
    ZipShort getCentralDirectoryLength();
    ZipShort getHeaderId();
    ZipShort getLocalFileDataLength();
    byte[] getCentralDirectoryData();
    byte[] getLocalFileDataData();
    static int EXTRAFIELD_HEADER_SIZE = 0;
    void parseFromCentralDirectoryData(byte[] p0, int p1, int p2);
    void parseFromLocalFileData(byte[] p0, int p1, int p2);
}
