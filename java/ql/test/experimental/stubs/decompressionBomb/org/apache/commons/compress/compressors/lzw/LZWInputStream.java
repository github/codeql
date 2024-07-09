// Generated automatically from org.apache.commons.compress.compressors.lzw.LZWInputStream for testing purposes

package org.apache.commons.compress.compressors.lzw;

import java.io.InputStream;
import java.nio.ByteOrder;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.utils.BitInputStream;
import org.apache.commons.compress.utils.InputStreamStatistics;

abstract public class LZWInputStream extends CompressorInputStream implements InputStreamStatistics
{
    protected LZWInputStream() {}
    protected LZWInputStream(InputStream p0, ByteOrder p1){}
    protected abstract int addEntry(int p0, byte p1);
    protected abstract int decompressNextSymbol();
    protected final BitInputStream in = null;
    protected int addEntry(int p0, byte p1, int p2){ return 0; }
    protected int addRepeatOfPreviousCode(){ return 0; }
    protected int expandCodeToOutputStack(int p0, boolean p1){ return 0; }
    protected int getClearCode(){ return 0; }
    protected int getCodeSize(){ return 0; }
    protected int getPrefix(int p0){ return 0; }
    protected int getPrefixesLength(){ return 0; }
    protected int getTableSize(){ return 0; }
    protected int readNextCode(){ return 0; }
    protected static int DEFAULT_CODE_SIZE = 0;
    protected static int UNUSED_PREFIX = 0;
    protected void incrementCodeSize(){}
    protected void initializeTables(int p0){}
    protected void initializeTables(int p0, int p1){}
    protected void resetCodeSize(){}
    protected void resetPreviousCode(){}
    protected void setClearCode(int p0){}
    protected void setCodeSize(int p0){}
    protected void setPrefix(int p0, int p1){}
    protected void setTableSize(int p0){}
    public int read(){ return 0; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public long getCompressedCount(){ return 0; }
    public void close(){}
}
