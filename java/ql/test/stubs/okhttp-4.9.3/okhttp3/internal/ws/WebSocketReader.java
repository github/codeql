// Generated automatically from okhttp3.internal.ws.WebSocketReader for testing purposes

package okhttp3.internal.ws;

import java.io.Closeable;
import okio.BufferedSource;
import okio.ByteString;

public class WebSocketReader implements Closeable
{
    protected WebSocketReader() {}
    public WebSocketReader(boolean p0, BufferedSource p1, WebSocketReader.FrameCallback p2, boolean p3, boolean p4){}
    public final BufferedSource getSource(){ return null; }
    public final void processNextFrame(){}
    public void close(){}
    static public interface FrameCallback
    {
        void onReadClose(int p0, String p1);
        void onReadMessage(ByteString p0);
        void onReadMessage(String p0);
        void onReadPing(ByteString p0);
        void onReadPong(ByteString p0);
    }
}
