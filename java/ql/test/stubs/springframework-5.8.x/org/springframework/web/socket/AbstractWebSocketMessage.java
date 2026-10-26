// Generated automatically from org.springframework.web.socket.AbstractWebSocketMessage for testing purposes

package org.springframework.web.socket;

import org.springframework.web.socket.WebSocketMessage;

abstract public class AbstractWebSocketMessage<T> implements WebSocketMessage<T>
{
    protected AbstractWebSocketMessage() {}
    protected abstract String toStringPayload();
    public String toString(){ return null; }
    public T getPayload(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isLast(){ return false; }
    public int hashCode(){ return 0; }
}
