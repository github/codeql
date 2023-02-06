// Generated automatically from okio.ByteString for testing purposes

package okio;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import okio.Buffer;

public class ByteString implements Comparable<ByteString>, Serializable
{
    protected ByteString() {}
    public ByteBuffer asByteBuffer(){ return null; }
    public ByteString digest$okio(String p0){ return null; }
    public ByteString hmac$okio(String p0, ByteString p1){ return null; }
    public ByteString hmacSha1(ByteString p0){ return null; }
    public ByteString hmacSha256(ByteString p0){ return null; }
    public ByteString hmacSha512(ByteString p0){ return null; }
    public ByteString md5(){ return null; }
    public ByteString sha1(){ return null; }
    public ByteString sha256(){ return null; }
    public ByteString sha512(){ return null; }
    public ByteString substring(int p0, int p1){ return null; }
    public ByteString toAsciiLowercase(){ return null; }
    public ByteString toAsciiUppercase(){ return null; }
    public ByteString(byte[] p0){}
    public String base64(){ return null; }
    public String base64Url(){ return null; }
    public String hex(){ return null; }
    public String string(Charset p0){ return null; }
    public String toString(){ return null; }
    public String utf8(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean rangeEquals(int p0, ByteString p1, int p2, int p3){ return false; }
    public boolean rangeEquals(int p0, byte[] p1, int p2, int p3){ return false; }
    public byte internalGet$okio(int p0){ return 0; }
    public byte[] internalArray$okio(){ return null; }
    public byte[] toByteArray(){ return null; }
    public final ByteString substring(){ return null; }
    public final ByteString substring(int p0){ return null; }
    public final String getUtf8$okio(){ return null; }
    public final boolean endsWith(ByteString p0){ return false; }
    public final boolean endsWith(byte[] p0){ return false; }
    public final boolean startsWith(ByteString p0){ return false; }
    public final boolean startsWith(byte[] p0){ return false; }
    public final byte getByte(int p0){ return 0; }
    public final byte[] getData$okio(){ return null; }
    public final int getHashCode$okio(){ return 0; }
    public final int indexOf(ByteString p0){ return 0; }
    public final int indexOf(ByteString p0, int p1){ return 0; }
    public final int indexOf(byte[] p0){ return 0; }
    public final int lastIndexOf(ByteString p0){ return 0; }
    public final int lastIndexOf(ByteString p0, int p1){ return 0; }
    public final int lastIndexOf(byte[] p0){ return 0; }
    public final int size(){ return 0; }
    public final void setHashCode$okio(int p0){}
    public final void setUtf8$okio(String p0){}
    public int compareTo(ByteString p0){ return 0; }
    public int getSize$okio(){ return 0; }
    public int hashCode(){ return 0; }
    public int indexOf(byte[] p0, int p1){ return 0; }
    public int lastIndexOf(byte[] p0, int p1){ return 0; }
    public static ByteString EMPTY = null;
    public static ByteString decodeBase64(String p0){ return null; }
    public static ByteString decodeHex(String p0){ return null; }
    public static ByteString encodeString(String p0, Charset p1){ return null; }
    public static ByteString encodeUtf8(String p0){ return null; }
    public static ByteString of(ByteBuffer p0){ return null; }
    public static ByteString of(byte... p0){ return null; }
    public static ByteString of(byte[] p0, int p1, int p2){ return null; }
    public static ByteString read(InputStream p0, int p1){ return null; }
    public static ByteString.Companion Companion = null;
    public void write$okio(Buffer p0, int p1, int p2){}
    public void write(OutputStream p0){}
    static public class Companion
    {
        protected Companion() {}
        public final ByteString decodeBase64(String p0){ return null; }
        public final ByteString decodeHex(String p0){ return null; }
        public final ByteString encodeString(String p0, Charset p1){ return null; }
        public final ByteString encodeUtf8(String p0){ return null; }
        public final ByteString of(ByteBuffer p0){ return null; }
        public final ByteString of(byte... p0){ return null; }
        public final ByteString of(byte[] p0, int p1, int p2){ return null; }
        public final ByteString read(InputStream p0, int p1){ return null; }
    }
}
