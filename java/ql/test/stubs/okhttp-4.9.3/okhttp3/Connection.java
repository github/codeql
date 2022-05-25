// Generated automatically from okhttp3.Connection for testing purposes

package okhttp3;

import java.net.Socket;
import okhttp3.Handshake;
import okhttp3.Protocol;
import okhttp3.Route;

public interface Connection
{
    Handshake handshake();
    Protocol protocol();
    Route route();
    Socket socket();
}
