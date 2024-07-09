// Generated automatically from org.apache.commons.compress.compressors.zstandard.ZstdCompressorInputStream for testing purposes

package org.apache.commons.compress.compressors.zstandard;

import com.github.luben.zstd.BufferPool;
import java.io.InputStream;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.utils.InputStreamStatistics;

public class ZstdCompressorInputStream extends CompressorInputStream implements InputStreamStatistics
{
    protected ZstdCompressorInputStream() {}
    public String toString(){ return null; }
    public ZstdCompressorInputStream(InputStream p0){}
    public ZstdCompressorInputStream(InputStream p0, BufferPool p1){}
    public boolean markSupported(){ return false; }
    public int available(){ return 0; }
    public int read(){ return 0; }
    public int read(byte[] p0){ return 0; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public long getCompressedCount(){ return 0; }
    public long skip(long p0){ return 0; }
    public void close(){}
    public void mark(int p0){}
    public void reset(){}
}
