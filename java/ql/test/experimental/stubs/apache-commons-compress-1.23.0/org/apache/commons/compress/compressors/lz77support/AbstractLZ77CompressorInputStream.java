// Generated automatically from org.apache.commons.compress.compressors.lz77support.AbstractLZ77CompressorInputStream for testing purposes

package org.apache.commons.compress.compressors.lz77support;

import java.io.InputStream;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.utils.ByteUtils;
import org.apache.commons.compress.utils.InputStreamStatistics;

abstract public class AbstractLZ77CompressorInputStream extends CompressorInputStream implements InputStreamStatistics
{
    protected AbstractLZ77CompressorInputStream() {}
    protected final ByteUtils.ByteSupplier supplier = null;
    protected final boolean hasMoreDataInBlock(){ return false; }
    protected final int readBackReference(byte[] p0, int p1, int p2){ return 0; }
    protected final int readLiteral(byte[] p0, int p1, int p2){ return 0; }
    protected final int readOneByte(){ return 0; }
    protected final void startBackReference(int p0, long p1){}
    protected final void startLiteral(long p0){}
    public AbstractLZ77CompressorInputStream(InputStream p0, int p1){}
    public int available(){ return 0; }
    public int getSize(){ return 0; }
    public int read(){ return 0; }
    public long getCompressedCount(){ return 0; }
    public void close(){}
    public void prefill(byte[] p0){}
}
