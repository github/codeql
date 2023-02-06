// Generated automatically from okhttp3.ResponseBody for testing purposes

package okhttp3;

import java.io.Closeable;
import java.io.InputStream;
import java.io.Reader;
import okhttp3.MediaType;
import okio.BufferedSource;
import okio.ByteString;

abstract public class ResponseBody implements Closeable
{
    public ResponseBody(){}
    public abstract BufferedSource source();
    public abstract MediaType contentType();
    public abstract long contentLength();
    public final ByteString byteString(){ return null; }
    public final InputStream byteStream(){ return null; }
    public final Reader charStream(){ return null; }
    public final String string(){ return null; }
    public final byte[] bytes(){ return null; }
    public static ResponseBody create(BufferedSource p0, MediaType p1, long p2){ return null; }
    public static ResponseBody create(ByteString p0, MediaType p1){ return null; }
    public static ResponseBody create(MediaType p0, ByteString p1){ return null; }
    public static ResponseBody create(MediaType p0, String p1){ return null; }
    public static ResponseBody create(MediaType p0, byte[] p1){ return null; }
    public static ResponseBody create(MediaType p0, long p1, BufferedSource p2){ return null; }
    public static ResponseBody create(String p0, MediaType p1){ return null; }
    public static ResponseBody create(byte[] p0, MediaType p1){ return null; }
    public static ResponseBody.Companion Companion = null;
    public void close(){}
    static public class Companion
    {
        protected Companion() {}
        public final ResponseBody create(BufferedSource p0, MediaType p1, long p2){ return null; }
        public final ResponseBody create(ByteString p0, MediaType p1){ return null; }
        public final ResponseBody create(MediaType p0, ByteString p1){ return null; }
        public final ResponseBody create(MediaType p0, String p1){ return null; }
        public final ResponseBody create(MediaType p0, byte[] p1){ return null; }
        public final ResponseBody create(MediaType p0, long p1, BufferedSource p2){ return null; }
        public final ResponseBody create(String p0, MediaType p1){ return null; }
        public final ResponseBody create(byte[] p0, MediaType p1){ return null; }
    }
}
