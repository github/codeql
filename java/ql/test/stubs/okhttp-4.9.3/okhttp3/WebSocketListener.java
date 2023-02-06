// Generated automatically from okhttp3.WebSocketListener for testing purposes

package okhttp3;

import okhttp3.Response;
import okhttp3.WebSocket;
import okio.ByteString;

abstract public class WebSocketListener
{
    public WebSocketListener(){}
    public void onClosed(WebSocket p0, int p1, String p2){}
    public void onClosing(WebSocket p0, int p1, String p2){}
    public void onFailure(WebSocket p0, Throwable p1, Response p2){}
    public void onMessage(WebSocket p0, ByteString p1){}
    public void onMessage(WebSocket p0, String p1){}
    public void onOpen(WebSocket p0, Response p1){}
}
