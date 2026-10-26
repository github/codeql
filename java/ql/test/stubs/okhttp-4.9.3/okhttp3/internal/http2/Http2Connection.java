// Generated automatically from okhttp3.internal.http2.Http2Connection for testing purposes

package okhttp3.internal.http2;

import java.io.Closeable;
import java.io.IOException;
import java.net.Socket;
import java.util.List;
import java.util.Map;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import okhttp3.internal.concurrent.TaskRunner;
import okhttp3.internal.http2.ErrorCode;
import okhttp3.internal.http2.Header;
import okhttp3.internal.http2.Http2Reader;
import okhttp3.internal.http2.Http2Stream;
import okhttp3.internal.http2.Http2Writer;
import okhttp3.internal.http2.PushObserver;
import okhttp3.internal.http2.Settings;
import okio.Buffer;
import okio.BufferedSink;
import okio.BufferedSource;
import okio.ByteString;

public class Http2Connection implements Closeable
{
    protected Http2Connection() {}
    abstract static public class Listener
    {
        public Listener(){}
        public abstract void onStream(Http2Stream p0);
        public static Http2Connection.Listener REFUSE_INCOMING_STREAMS = null;
        public static Http2Connection.Listener.Companion Companion = null;
        public void onSettings(Http2Connection p0, Settings p1){}
        static public class Companion
        {
            protected Companion() {}
        }
    }
    public Http2Connection(Http2Connection.Builder p0){}
    public class ReaderRunnable implements Function0<Void>, Http2Reader.Handler
    {
        protected ReaderRunnable() {}
        public ReaderRunnable(Http2Reader p0){}
        public final Http2Reader getReader$okhttp(){ return null; }
        public final void applyAndAckSettings(boolean p0, Settings p1){}
        public void ackSettings(){}
        public void alternateService(int p0, String p1, ByteString p2, String p3, int p4, long p5){}
        public void data(boolean p0, int p1, BufferedSource p2, int p3){}
        public void goAway(int p0, ErrorCode p1, ByteString p2){}
        public void headers(boolean p0, int p1, int p2, List<Header> p3){}
        public Void invoke(){ return null; }
        public void ping(boolean p0, int p1, int p2){}
        public void priority(int p0, int p1, int p2, boolean p3){}
        public void pushPromise(int p0, int p1, List<Header> p2){}
        public void rstStream(int p0, ErrorCode p1){}
        public void settings(boolean p0, Settings p1){}
        public void windowUpdate(int p0, long p1){}
    }
    public final Http2Connection.Listener getListener$okhttp(){ return null; }
    public final Http2Connection.ReaderRunnable getReaderRunnable(){ return null; }
    public final Http2Stream getStream(int p0){ return null; }
    public final Http2Stream newStream(List<Header> p0, boolean p1){ return null; }
    public final Http2Stream pushStream(int p0, List<Header> p1, boolean p2){ return null; }
    public final Http2Stream removeStream$okhttp(int p0){ return null; }
    public final Http2Writer getWriter(){ return null; }
    public final Map<Integer, Http2Stream> getStreams$okhttp(){ return null; }
    public final Settings getOkHttpSettings(){ return null; }
    public final Settings getPeerSettings(){ return null; }
    public final Socket getSocket$okhttp(){ return null; }
    public final String getConnectionName$okhttp(){ return null; }
    public final boolean getClient$okhttp(){ return false; }
    public final boolean isHealthy(long p0){ return false; }
    public final boolean pushedStream$okhttp(int p0){ return false; }
    public final int getLastGoodStreamId$okhttp(){ return 0; }
    public final int getNextStreamId$okhttp(){ return 0; }
    public final int openStreamCount(){ return 0; }
    public final long getReadBytesAcknowledged(){ return 0; }
    public final long getReadBytesTotal(){ return 0; }
    public final long getWriteBytesMaximum(){ return 0; }
    public final long getWriteBytesTotal(){ return 0; }
    public final void awaitPong(){}
    public final void close$okhttp(ErrorCode p0, ErrorCode p1, IOException p2){}
    public final void flush(){}
    public final void pushDataLater$okhttp(int p0, BufferedSource p1, int p2, boolean p3){}
    public final void pushHeadersLater$okhttp(int p0, List<Header> p1, boolean p2){}
    public final void pushRequestLater$okhttp(int p0, List<Header> p1){}
    public final void pushResetLater$okhttp(int p0, ErrorCode p1){}
    public final void sendDegradedPingLater$okhttp(){}
    public final void setLastGoodStreamId$okhttp(int p0){}
    public final void setNextStreamId$okhttp(int p0){}
    public final void setPeerSettings(Settings p0){}
    public final void setSettings(Settings p0){}
    public final void shutdown(ErrorCode p0){}
    public final void start(){}
    public final void start(boolean p0){}
    public final void start(boolean p0, TaskRunner p1){}
    public final void updateConnectionFlowControl$okhttp(long p0){}
    public final void writeData(int p0, boolean p1, Buffer p2, long p3){}
    public final void writeHeaders$okhttp(int p0, boolean p1, List<Header> p2){}
    public final void writePing(){}
    public final void writePing(boolean p0, int p1, int p2){}
    public final void writePingAndAwaitPong(){}
    public final void writeSynReset$okhttp(int p0, ErrorCode p1){}
    public final void writeSynResetLater$okhttp(int p0, ErrorCode p1){}
    public final void writeWindowUpdateLater$okhttp(int p0, long p1){}
    public static Http2Connection.Companion Companion = null;
    public static int AWAIT_PING = 0;
    public static int DEGRADED_PING = 0;
    public static int DEGRADED_PONG_TIMEOUT_NS = 0;
    public static int INTERVAL_PING = 0;
    public static int OKHTTP_CLIENT_WINDOW_SIZE = 0;
    public void close(){}
    static public class Builder
    {
        protected Builder() {}
        public BufferedSink sink = null;
        public BufferedSource source = null;
        public Builder(boolean p0, TaskRunner p1){}
        public Socket socket = null;
        public String connectionName = null;
        public final BufferedSink getSink$okhttp(){ return null; }
        public final BufferedSource getSource$okhttp(){ return null; }
        public final Http2Connection build(){ return null; }
        public final Http2Connection.Builder listener(Http2Connection.Listener p0){ return null; }
        public final Http2Connection.Builder pingIntervalMillis(int p0){ return null; }
        public final Http2Connection.Builder pushObserver(PushObserver p0){ return null; }
        public final Http2Connection.Builder socket(Socket p0){ return null; }
        public final Http2Connection.Builder socket(Socket p0, String p1){ return null; }
        public final Http2Connection.Builder socket(Socket p0, String p1, BufferedSource p2){ return null; }
        public final Http2Connection.Builder socket(Socket p0, String p1, BufferedSource p2, BufferedSink p3){ return null; }
        public final Http2Connection.Listener getListener$okhttp(){ return null; }
        public final PushObserver getPushObserver$okhttp(){ return null; }
        public final Socket getSocket$okhttp(){ return null; }
        public final String getConnectionName$okhttp(){ return null; }
        public final TaskRunner getTaskRunner$okhttp(){ return null; }
        public final boolean getClient$okhttp(){ return false; }
        public final int getPingIntervalMillis$okhttp(){ return 0; }
        public final void setClient$okhttp(boolean p0){}
        public final void setConnectionName$okhttp(String p0){}
        public final void setListener$okhttp(Http2Connection.Listener p0){}
        public final void setPingIntervalMillis$okhttp(int p0){}
        public final void setPushObserver$okhttp(PushObserver p0){}
        public final void setSink$okhttp(BufferedSink p0){}
        public final void setSocket$okhttp(Socket p0){}
        public final void setSource$okhttp(BufferedSource p0){}
    }
    static public class Companion
    {
        protected Companion() {}
        public final Settings getDEFAULT_SETTINGS(){ return null; }
    }
}
