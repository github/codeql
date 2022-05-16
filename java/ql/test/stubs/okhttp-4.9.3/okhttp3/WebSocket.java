// Generated automatically from okhttp3.WebSocket for testing purposes

package okhttp3;

import okhttp3.Request;
import okhttp3.WebSocketListener;
import okio.ByteString;

public interface WebSocket
{
    Request request();
    boolean close(int p0, String p1);
    boolean send(ByteString p0);
    boolean send(String p0);
    long queueSize();
    static public interface Factory
    {
        WebSocket newWebSocket(Request p0, WebSocketListener p1);
    }
    void cancel();
}
