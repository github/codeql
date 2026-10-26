// Generated automatically from org.apache.commons.compress.compressors.bzip2.BZip2CompressorInputStream for testing purposes

package org.apache.commons.compress.compressors.bzip2;

import java.io.InputStream;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.compressors.bzip2.BZip2Constants;
import org.apache.commons.compress.utils.InputStreamStatistics;

public class BZip2CompressorInputStream extends CompressorInputStream implements BZip2Constants, InputStreamStatistics
{
    protected BZip2CompressorInputStream() {}
    public BZip2CompressorInputStream(InputStream p0){}
    public BZip2CompressorInputStream(InputStream p0, boolean p1){}
    public int read(){ return 0; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public long getCompressedCount(){ return 0; }
    public static boolean matches(byte[] p0, int p1){ return false; }
    public void close(){}
}
