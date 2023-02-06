// Generated automatically from okhttp3.internal.http2.Http2Writer for testing purposes

package okhttp3.internal.http2;

import java.io.Closeable;
import java.util.List;
import okhttp3.internal.http2.ErrorCode;
import okhttp3.internal.http2.Header;
import okhttp3.internal.http2.Hpack;
import okhttp3.internal.http2.Settings;
import okio.Buffer;
import okio.BufferedSink;

public class Http2Writer implements Closeable
{
    protected Http2Writer() {}
    public Http2Writer(BufferedSink p0, boolean p1){}
    public final Hpack.Writer getHpackWriter(){ return null; }
    public final int maxDataLength(){ return 0; }
    public final void applyAndAckSettings(Settings p0){}
    public final void connectionPreface(){}
    public final void data(boolean p0, int p1, Buffer p2, int p3){}
    public final void dataFrame(int p0, int p1, Buffer p2, int p3){}
    public final void flush(){}
    public final void frameHeader(int p0, int p1, int p2, int p3){}
    public final void goAway(int p0, ErrorCode p1, byte[] p2){}
    public final void headers(boolean p0, int p1, List<Header> p2){}
    public final void ping(boolean p0, int p1, int p2){}
    public final void pushPromise(int p0, int p1, List<Header> p2){}
    public final void rstStream(int p0, ErrorCode p1){}
    public final void settings(Settings p0){}
    public final void windowUpdate(int p0, long p1){}
    public static Http2Writer.Companion Companion = null;
    public void close(){}
    static public class Companion
    {
        protected Companion() {}
    }
}
