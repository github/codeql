// Generated automatically from org.springframework.web.socket.BinaryMessage for testing purposes

package org.springframework.web.socket;

import java.nio.ByteBuffer;
import org.springframework.web.socket.AbstractWebSocketMessage;

public class BinaryMessage extends AbstractWebSocketMessage<ByteBuffer>
{
    protected BinaryMessage() {}
    protected String toStringPayload(){ return null; }
    public BinaryMessage(ByteBuffer p0){}
    public BinaryMessage(ByteBuffer p0, boolean p1){}
    public BinaryMessage(byte[] p0){}
    public BinaryMessage(byte[] p0, boolean p1){}
    public BinaryMessage(byte[] p0, int p1, int p2, boolean p3){}
    public int getPayloadLength(){ return 0; }
}
