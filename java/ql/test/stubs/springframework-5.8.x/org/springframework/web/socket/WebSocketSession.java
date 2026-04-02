// Generated automatically from org.springframework.web.socket.WebSocketSession for testing purposes

package org.springframework.web.socket;

import java.io.Closeable;
import java.net.InetSocketAddress;
import java.net.URI;
import java.security.Principal;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpHeaders;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketExtension;
import org.springframework.web.socket.WebSocketMessage;

public interface WebSocketSession extends Closeable
{
    HttpHeaders getHandshakeHeaders();
    InetSocketAddress getLocalAddress();
    InetSocketAddress getRemoteAddress();
    List<WebSocketExtension> getExtensions();
    Map<String, Object> getAttributes();
    Principal getPrincipal();
    String getAcceptedProtocol();
    String getId();
    URI getUri();
    boolean isOpen();
    int getBinaryMessageSizeLimit();
    int getTextMessageSizeLimit();
    void close();
    void close(CloseStatus p0);
    void sendMessage(WebSocketMessage<? extends Object> p0);
    void setBinaryMessageSizeLimit(int p0);
    void setTextMessageSizeLimit(int p0);
}
