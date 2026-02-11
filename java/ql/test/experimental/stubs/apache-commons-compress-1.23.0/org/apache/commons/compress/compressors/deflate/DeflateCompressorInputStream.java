// Generated automatically from org.apache.commons.compress.compressors.deflate.DeflateCompressorInputStream for testing purposes

package org.apache.commons.compress.compressors.deflate;

import java.io.InputStream;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.compressors.deflate.DeflateParameters;
import org.apache.commons.compress.utils.InputStreamStatistics;

public class DeflateCompressorInputStream extends CompressorInputStream implements InputStreamStatistics
{
    protected DeflateCompressorInputStream() {}
    public DeflateCompressorInputStream(InputStream p0){}
    public DeflateCompressorInputStream(InputStream p0, DeflateParameters p1){}
    public int available(){ return 0; }
    public int read(){ return 0; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public long getCompressedCount(){ return 0; }
    public long skip(long p0){ return 0; }
    public static boolean matches(byte[] p0, int p1){ return false; }
    public void close(){}
}
