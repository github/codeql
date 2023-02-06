// Generated automatically from okhttp3.RequestBody for testing purposes

package okhttp3;

import java.io.File;
import okhttp3.MediaType;
import okio.BufferedSink;
import okio.ByteString;

abstract public class RequestBody
{
    public RequestBody(){}
    public abstract MediaType contentType();
    public abstract void writeTo(BufferedSink p0);
    public boolean isDuplex(){ return false; }
    public boolean isOneShot(){ return false; }
    public long contentLength(){ return 0; }
    public static RequestBody create(ByteString p0, MediaType p1){ return null; }
    public static RequestBody create(File p0, MediaType p1){ return null; }
    public static RequestBody create(MediaType p0, ByteString p1){ return null; }
    public static RequestBody create(MediaType p0, File p1){ return null; }
    public static RequestBody create(MediaType p0, String p1){ return null; }
    public static RequestBody create(MediaType p0, byte[] p1){ return null; }
    public static RequestBody create(MediaType p0, byte[] p1, int p2){ return null; }
    public static RequestBody create(MediaType p0, byte[] p1, int p2, int p3){ return null; }
    public static RequestBody create(String p0, MediaType p1){ return null; }
    public static RequestBody create(byte[] p0){ return null; }
    public static RequestBody create(byte[] p0, MediaType p1){ return null; }
    public static RequestBody create(byte[] p0, MediaType p1, int p2){ return null; }
    public static RequestBody create(byte[] p0, MediaType p1, int p2, int p3){ return null; }
    public static RequestBody.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final RequestBody create(ByteString p0, MediaType p1){ return null; }
        public final RequestBody create(File p0, MediaType p1){ return null; }
        public final RequestBody create(MediaType p0, ByteString p1){ return null; }
        public final RequestBody create(MediaType p0, File p1){ return null; }
        public final RequestBody create(MediaType p0, String p1){ return null; }
        public final RequestBody create(MediaType p0, byte[] p1){ return null; }
        public final RequestBody create(MediaType p0, byte[] p1, int p2){ return null; }
        public final RequestBody create(MediaType p0, byte[] p1, int p2, int p3){ return null; }
        public final RequestBody create(String p0, MediaType p1){ return null; }
        public final RequestBody create(byte[] p0){ return null; }
        public final RequestBody create(byte[] p0, MediaType p1){ return null; }
        public final RequestBody create(byte[] p0, MediaType p1, int p2){ return null; }
        public final RequestBody create(byte[] p0, MediaType p1, int p2, int p3){ return null; }
    }
}
