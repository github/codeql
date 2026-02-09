// Generated automatically from org.springframework.web.socket.handler.AbstractWebSocketHandler for testing purposes

package org.springframework.web.socket.handler;

import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.PongMessage;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

abstract public class AbstractWebSocketHandler implements WebSocketHandler
{
    protected void handleBinaryMessage(WebSocketSession p0, BinaryMessage p1){}
    protected void handlePongMessage(WebSocketSession p0, PongMessage p1){}
    protected void handleTextMessage(WebSocketSession p0, TextMessage p1){}
    public AbstractWebSocketHandler(){}
    public boolean supportsPartialMessages(){ return false; }
    public void afterConnectionClosed(WebSocketSession p0, CloseStatus p1){}
    public void afterConnectionEstablished(WebSocketSession p0){}
    public void handleMessage(WebSocketSession p0, WebSocketMessage<? extends Object> p1){}
    public void handleTransportError(WebSocketSession p0, Throwable p1){}
}
