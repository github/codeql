// Generated automatically from org.apache.sshd.common.util.buffer.ByteArrayBuffer for testing purposes

package org.apache.sshd.common.util.buffer;

import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.util.function.IntUnaryOperator;
import org.apache.sshd.common.util.Readable;
import org.apache.sshd.common.util.buffer.Buffer;

public class ByteArrayBuffer extends Buffer
{
    protected int size(){ return 0; }
    protected void copyRawBytes(int p0, byte[] p1, int p2, int p3){}
    public Buffer clear(boolean p0){ return null; }
    public Buffer ensureCapacity(int p0, IntUnaryOperator p1){ return null; }
    public ByteArrayBuffer(){}
    public ByteArrayBuffer(byte[] p0){}
    public ByteArrayBuffer(byte[] p0, boolean p1){}
    public ByteArrayBuffer(byte[] p0, int p1, int p2){}
    public ByteArrayBuffer(byte[] p0, int p1, int p2, boolean p3){}
    public ByteArrayBuffer(int p0){}
    public ByteArrayBuffer(int p0, boolean p1){}
    public String getString(Charset p0){ return null; }
    public byte getByte(){ return 0; }
    public byte rawByte(int p0){ return 0; }
    public byte[] array(){ return null; }
    public byte[] getBytesConsumed(){ return null; }
    public int available(){ return 0; }
    public int capacity(){ return 0; }
    public int putBuffer(Readable p0, boolean p1){ return 0; }
    public int rpos(){ return 0; }
    public int wpos(){ return 0; }
    public long rawUInt(int p0){ return 0; }
    public static ByteArrayBuffer getCompactClone(byte[] p0){ return null; }
    public static ByteArrayBuffer getCompactClone(byte[] p0, int p1, int p2){ return null; }
    public static int DEFAULT_SIZE = 0;
    public void compact(){}
    public void getRawBytes(byte[] p0, int p1, int p2){}
    public void putBuffer(ByteBuffer p0){}
    public void putByte(byte p0){}
    public void putRawBytes(byte[] p0, int p1, int p2){}
    public void rpos(int p0){}
    public void wpos(int p0){}
}
