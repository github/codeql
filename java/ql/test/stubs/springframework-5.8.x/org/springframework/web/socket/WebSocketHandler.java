// Generated automatically from org.springframework.web.socket.WebSocketHandler for testing purposes

package org.springframework.web.socket;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

public interface WebSocketHandler
{
    boolean supportsPartialMessages();
    void afterConnectionClosed(WebSocketSession p0, CloseStatus p1);
    void afterConnectionEstablished(WebSocketSession p0);
    void handleMessage(WebSocketSession p0, WebSocketMessage<? extends Object> p1);
    void handleTransportError(WebSocketSession p0, Throwable p1);
}
