// Generated automatically from okhttp3.internal.ws.RealWebSocket for testing purposes

package okhttp3.internal.ws;

import java.io.Closeable;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import okhttp3.internal.concurrent.TaskRunner;
import okhttp3.internal.connection.Exchange;
import okhttp3.internal.ws.WebSocketExtensions;
import okhttp3.internal.ws.WebSocketReader;
import okio.BufferedSink;
import okio.BufferedSource;
import okio.ByteString;

public class RealWebSocket implements WebSocket, WebSocketReader.FrameCallback
{
    protected RealWebSocket() {}
    abstract static public class Streams implements Closeable
    {
        protected Streams() {}
        public Streams(boolean p0, BufferedSource p1, BufferedSink p2){}
        public final BufferedSink getSink(){ return null; }
        public final BufferedSource getSource(){ return null; }
        public final boolean getClient(){ return false; }
    }
    public RealWebSocket(TaskRunner p0, Request p1, WebSocketListener p2, Random p3, long p4, WebSocketExtensions p5, long p6){}
    public Request request(){ return null; }
    public boolean close(int p0, String p1){ return false; }
    public boolean send(ByteString p0){ return false; }
    public boolean send(String p0){ return false; }
    public final WebSocketListener getListener$okhttp(){ return null; }
    public final boolean close(int p0, String p1, long p2){ return false; }
    public final boolean pong(ByteString p0){ return false; }
    public final boolean processNextFrame(){ return false; }
    public final boolean writeOneFrame$okhttp(){ return false; }
    public final int receivedPingCount(){ return 0; }
    public final int receivedPongCount(){ return 0; }
    public final int sentPingCount(){ return 0; }
    public final void awaitTermination(long p0, TimeUnit p1){}
    public final void checkUpgradeSuccess$okhttp(Response p0, Exchange p1){}
    public final void connect(OkHttpClient p0){}
    public final void failWebSocket(Exception p0, Response p1){}
    public final void initReaderAndWriter(String p0, RealWebSocket.Streams p1){}
    public final void loopReader(){}
    public final void tearDown(){}
    public final void writePingFrame$okhttp(){}
    public long queueSize(){ return 0; }
    public static RealWebSocket.Companion Companion = null;
    public static long DEFAULT_MINIMUM_DEFLATE_SIZE = 0;
    public void cancel(){}
    public void onReadClose(int p0, String p1){}
    public void onReadMessage(ByteString p0){}
    public void onReadMessage(String p0){}
    public void onReadPing(ByteString p0){}
    public void onReadPong(ByteString p0){}
    static public class Companion
    {
        protected Companion() {}
    }
}
