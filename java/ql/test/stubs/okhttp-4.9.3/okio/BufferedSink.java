// Generated automatically from okio.BufferedSink for testing purposes

package okio;

import java.io.OutputStream;
import java.nio.channels.WritableByteChannel;
import java.nio.charset.Charset;
import okio.Buffer;
import okio.ByteString;
import okio.Sink;
import okio.Source;

public interface BufferedSink extends Sink, WritableByteChannel
{
    Buffer buffer();
    Buffer getBuffer();
    BufferedSink emit();
    BufferedSink emitCompleteSegments();
    BufferedSink write(ByteString p0);
    BufferedSink write(ByteString p0, int p1, int p2);
    BufferedSink write(Source p0, long p1);
    BufferedSink write(byte[] p0);
    BufferedSink write(byte[] p0, int p1, int p2);
    BufferedSink writeByte(int p0);
    BufferedSink writeDecimalLong(long p0);
    BufferedSink writeHexadecimalUnsignedLong(long p0);
    BufferedSink writeInt(int p0);
    BufferedSink writeIntLe(int p0);
    BufferedSink writeLong(long p0);
    BufferedSink writeLongLe(long p0);
    BufferedSink writeShort(int p0);
    BufferedSink writeShortLe(int p0);
    BufferedSink writeString(String p0, Charset p1);
    BufferedSink writeString(String p0, int p1, int p2, Charset p3);
    BufferedSink writeUtf8(String p0);
    BufferedSink writeUtf8(String p0, int p1, int p2);
    BufferedSink writeUtf8CodePoint(int p0);
    OutputStream outputStream();
    long writeAll(Source p0);
    void flush();
}
