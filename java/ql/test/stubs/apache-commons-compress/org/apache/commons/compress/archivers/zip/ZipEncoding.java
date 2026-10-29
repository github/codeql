// Generated automatically from org.apache.commons.compress.archivers.zip.ZipEncoding for testing purposes

package org.apache.commons.compress.archivers.zip;

import java.nio.ByteBuffer;

public interface ZipEncoding
{
    ByteBuffer encode(String p0);
    String decode(byte[] p0);
    boolean canEncode(String p0);
}
