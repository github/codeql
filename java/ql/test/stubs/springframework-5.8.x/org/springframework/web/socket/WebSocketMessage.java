// Generated automatically from org.springframework.web.socket.WebSocketMessage for testing purposes

package org.springframework.web.socket;


public interface WebSocketMessage<T>
{
    T getPayload();
    boolean isLast();
    int getPayloadLength();
}
