// Generated automatically from okhttp3.internal.http2.Http2Reader for testing purposes

package okhttp3.internal.http2;

import java.io.Closeable;
import java.util.List;
import java.util.logging.Logger;
import okhttp3.internal.http2.ErrorCode;
import okhttp3.internal.http2.Header;
import okhttp3.internal.http2.Settings;
import okio.BufferedSource;
import okio.ByteString;

public class Http2Reader implements Closeable
{
    protected Http2Reader() {}
    public Http2Reader(BufferedSource p0, boolean p1){}
    public final boolean nextFrame(boolean p0, Http2Reader.Handler p1){ return false; }
    public final void readConnectionPreface(Http2Reader.Handler p0){}
    public static Http2Reader.Companion Companion = null;
    public void close(){}
    static public class Companion
    {
        protected Companion() {}
        public final Logger getLogger(){ return null; }
        public final int lengthWithoutPadding(int p0, int p1, int p2){ return 0; }
    }
    static public interface Handler
    {
        void ackSettings();
        void alternateService(int p0, String p1, ByteString p2, String p3, int p4, long p5);
        void data(boolean p0, int p1, BufferedSource p2, int p3);
        void goAway(int p0, ErrorCode p1, ByteString p2);
        void headers(boolean p0, int p1, int p2, List<Header> p3);
        void ping(boolean p0, int p1, int p2);
        void priority(int p0, int p1, int p2, boolean p3);
        void pushPromise(int p0, int p1, List<Header> p2);
        void rstStream(int p0, ErrorCode p1);
        void settings(boolean p0, Settings p1);
        void windowUpdate(int p0, long p1);
    }
}
