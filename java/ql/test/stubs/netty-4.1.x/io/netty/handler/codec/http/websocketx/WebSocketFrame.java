// Generated automatically from io.netty.handler.codec.http.websocketx.WebSocketFrame for testing purposes

package io.netty.handler.codec.http.websocketx;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.DefaultByteBufHolder;

abstract public class WebSocketFrame extends DefaultByteBufHolder
{
    protected WebSocketFrame() {}
    protected WebSocketFrame(ByteBuf p0){}
    protected WebSocketFrame(boolean p0, int p1, ByteBuf p2){}
    public String toString(){ return null; }
    public WebSocketFrame copy(){ return null; }
    public WebSocketFrame duplicate(){ return null; }
    public WebSocketFrame retain(){ return null; }
    public WebSocketFrame retain(int p0){ return null; }
    public WebSocketFrame retainedDuplicate(){ return null; }
    public WebSocketFrame touch(){ return null; }
    public WebSocketFrame touch(Object p0){ return null; }
    public abstract WebSocketFrame replace(ByteBuf p0);
    public boolean isFinalFragment(){ return false; }
    public int rsv(){ return 0; }
}
