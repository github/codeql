// Generated automatically from okio.BufferedSource for testing purposes

package okio;

import java.io.InputStream;
import java.nio.channels.ReadableByteChannel;
import java.nio.charset.Charset;
import okio.Buffer;
import okio.ByteString;
import okio.Options;
import okio.Sink;
import okio.Source;

public interface BufferedSource extends ReadableByteChannel, Source
{
    Buffer buffer();
    Buffer getBuffer();
    BufferedSource peek();
    ByteString readByteString();
    ByteString readByteString(long p0);
    InputStream inputStream();
    String readString(Charset p0);
    String readString(long p0, Charset p1);
    String readUtf8();
    String readUtf8(long p0);
    String readUtf8Line();
    String readUtf8LineStrict();
    String readUtf8LineStrict(long p0);
    boolean exhausted();
    boolean rangeEquals(long p0, ByteString p1);
    boolean rangeEquals(long p0, ByteString p1, int p2, int p3);
    boolean request(long p0);
    byte readByte();
    byte[] readByteArray();
    byte[] readByteArray(long p0);
    int read(byte[] p0);
    int read(byte[] p0, int p1, int p2);
    int readInt();
    int readIntLe();
    int readUtf8CodePoint();
    int select(Options p0);
    long indexOf(ByteString p0);
    long indexOf(ByteString p0, long p1);
    long indexOf(byte p0);
    long indexOf(byte p0, long p1);
    long indexOf(byte p0, long p1, long p2);
    long indexOfElement(ByteString p0);
    long indexOfElement(ByteString p0, long p1);
    long readAll(Sink p0);
    long readDecimalLong();
    long readHexadecimalUnsignedLong();
    long readLong();
    long readLongLe();
    short readShort();
    short readShortLe();
    void readFully(Buffer p0, long p1);
    void readFully(byte[] p0);
    void require(long p0);
    void skip(long p0);
}
