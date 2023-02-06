// Generated automatically from okio.Buffer for testing purposes

package okio;

import java.io.Closeable;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.ByteChannel;
import java.nio.charset.Charset;
import okio.BufferedSink;
import okio.BufferedSource;
import okio.ByteString;
import okio.Options;
import okio.Segment;
import okio.Sink;
import okio.Source;
import okio.Timeout;

public class Buffer implements BufferedSink, BufferedSource, ByteChannel, Cloneable
{
    public Buffer buffer(){ return null; }
    public Buffer clone(){ return null; }
    public Buffer emit(){ return null; }
    public Buffer emitCompleteSegments(){ return null; }
    public Buffer getBuffer(){ return null; }
    public Buffer write(ByteString p0){ return null; }
    public Buffer write(ByteString p0, int p1, int p2){ return null; }
    public Buffer write(Source p0, long p1){ return null; }
    public Buffer write(byte[] p0){ return null; }
    public Buffer write(byte[] p0, int p1, int p2){ return null; }
    public Buffer writeByte(int p0){ return null; }
    public Buffer writeDecimalLong(long p0){ return null; }
    public Buffer writeHexadecimalUnsignedLong(long p0){ return null; }
    public Buffer writeInt(int p0){ return null; }
    public Buffer writeIntLe(int p0){ return null; }
    public Buffer writeLong(long p0){ return null; }
    public Buffer writeLongLe(long p0){ return null; }
    public Buffer writeShort(int p0){ return null; }
    public Buffer writeShortLe(int p0){ return null; }
    public Buffer writeString(String p0, Charset p1){ return null; }
    public Buffer writeString(String p0, int p1, int p2, Charset p3){ return null; }
    public Buffer writeUtf8(String p0){ return null; }
    public Buffer writeUtf8(String p0, int p1, int p2){ return null; }
    public Buffer writeUtf8CodePoint(int p0){ return null; }
    public Buffer(){}
    public BufferedSource peek(){ return null; }
    public ByteString readByteString(){ return null; }
    public ByteString readByteString(long p0){ return null; }
    public InputStream inputStream(){ return null; }
    public OutputStream outputStream(){ return null; }
    public Segment head = null;
    public String readString(Charset p0){ return null; }
    public String readString(long p0, Charset p1){ return null; }
    public String readUtf8(){ return null; }
    public String readUtf8(long p0){ return null; }
    public String readUtf8Line(){ return null; }
    public String readUtf8LineStrict(){ return null; }
    public String readUtf8LineStrict(long p0){ return null; }
    public String toString(){ return null; }
    public Timeout timeout(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean exhausted(){ return false; }
    public boolean isOpen(){ return false; }
    public boolean rangeEquals(long p0, ByteString p1){ return false; }
    public boolean rangeEquals(long p0, ByteString p1, int p2, int p3){ return false; }
    public boolean request(long p0){ return false; }
    public byte readByte(){ return 0; }
    public byte[] readByteArray(){ return null; }
    public byte[] readByteArray(long p0){ return null; }
    public final Buffer copy(){ return null; }
    public final Buffer copyTo(Buffer p0, long p1){ return null; }
    public final Buffer copyTo(Buffer p0, long p1, long p2){ return null; }
    public final Buffer copyTo(OutputStream p0){ return null; }
    public final Buffer copyTo(OutputStream p0, long p1){ return null; }
    public final Buffer copyTo(OutputStream p0, long p1, long p2){ return null; }
    public final Buffer readFrom(InputStream p0){ return null; }
    public final Buffer readFrom(InputStream p0, long p1){ return null; }
    public final Buffer writeTo(OutputStream p0){ return null; }
    public final Buffer writeTo(OutputStream p0, long p1){ return null; }
    public final Buffer.UnsafeCursor readAndWriteUnsafe(){ return null; }
    public final Buffer.UnsafeCursor readAndWriteUnsafe(Buffer.UnsafeCursor p0){ return null; }
    public final Buffer.UnsafeCursor readUnsafe(){ return null; }
    public final Buffer.UnsafeCursor readUnsafe(Buffer.UnsafeCursor p0){ return null; }
    public final ByteString hmacSha1(ByteString p0){ return null; }
    public final ByteString hmacSha256(ByteString p0){ return null; }
    public final ByteString hmacSha512(ByteString p0){ return null; }
    public final ByteString md5(){ return null; }
    public final ByteString sha1(){ return null; }
    public final ByteString sha256(){ return null; }
    public final ByteString sha512(){ return null; }
    public final ByteString snapshot(){ return null; }
    public final ByteString snapshot(int p0){ return null; }
    public final Segment writableSegment$okio(int p0){ return null; }
    public final byte getByte(long p0){ return 0; }
    public final long completeSegmentByteCount(){ return 0; }
    public final long size(){ return 0; }
    public final void clear(){}
    public final void setSize$okio(long p0){}
    public int hashCode(){ return 0; }
    public int read(ByteBuffer p0){ return 0; }
    public int read(byte[] p0){ return 0; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public int readInt(){ return 0; }
    public int readIntLe(){ return 0; }
    public int readUtf8CodePoint(){ return 0; }
    public int select(Options p0){ return 0; }
    public int write(ByteBuffer p0){ return 0; }
    public long indexOf(ByteString p0){ return 0; }
    public long indexOf(ByteString p0, long p1){ return 0; }
    public long indexOf(byte p0){ return 0; }
    public long indexOf(byte p0, long p1){ return 0; }
    public long indexOf(byte p0, long p1, long p2){ return 0; }
    public long indexOfElement(ByteString p0){ return 0; }
    public long indexOfElement(ByteString p0, long p1){ return 0; }
    public long read(Buffer p0, long p1){ return 0; }
    public long readAll(Sink p0){ return 0; }
    public long readDecimalLong(){ return 0; }
    public long readHexadecimalUnsignedLong(){ return 0; }
    public long readLong(){ return 0; }
    public long readLongLe(){ return 0; }
    public long writeAll(Source p0){ return 0; }
    public short readShort(){ return 0; }
    public short readShortLe(){ return 0; }
    public void close(){}
    public void flush(){}
    public void readFully(Buffer p0, long p1){}
    public void readFully(byte[] p0){}
    public void require(long p0){}
    public void skip(long p0){}
    public void write(Buffer p0, long p1){}
    static public class UnsafeCursor implements Closeable
    {
        public Buffer buffer = null;
        public UnsafeCursor(){}
        public boolean readWrite = false;
        public byte[] data = null;
        public final int next(){ return 0; }
        public final int seek(long p0){ return 0; }
        public final long expandBuffer(int p0){ return 0; }
        public final long resizeBuffer(long p0){ return 0; }
        public int end = 0;
        public int start = 0;
        public long offset = 0;
        public void close(){}
    }
}
