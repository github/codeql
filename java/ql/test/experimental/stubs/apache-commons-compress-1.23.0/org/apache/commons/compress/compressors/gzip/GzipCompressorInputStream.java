// Generated automatically from org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream for testing purposes

package org.apache.commons.compress.compressors.gzip;

import java.io.InputStream;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.compressors.gzip.GzipParameters;
import org.apache.commons.compress.utils.InputStreamStatistics;

public class GzipCompressorInputStream extends CompressorInputStream implements InputStreamStatistics
{
    protected GzipCompressorInputStream() {}
    public GzipCompressorInputStream(InputStream p0){}
    public GzipCompressorInputStream(InputStream p0, boolean p1){}
    public GzipParameters getMetaData(){ return null; }
    public int read(){ return 0; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public long getCompressedCount(){ return 0; }
    public static boolean matches(byte[] p0, int p1){ return false; }
    public void close(){}
}
