// Generated automatically from org.apache.commons.compress.compressors.z.ZCompressorInputStream for testing purposes

package org.apache.commons.compress.compressors.z;

import java.io.InputStream;
import org.apache.commons.compress.compressors.lzw.LZWInputStream;

public class ZCompressorInputStream extends LZWInputStream
{
    protected ZCompressorInputStream() {}
    protected int addEntry(int p0, byte p1){ return 0; }
    protected int decompressNextSymbol(){ return 0; }
    protected int readNextCode(){ return 0; }
    public ZCompressorInputStream(InputStream p0){}
    public ZCompressorInputStream(InputStream p0, int p1){}
    public static boolean matches(byte[] p0, int p1){ return false; }
}
