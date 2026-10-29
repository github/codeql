// Generated automatically from io.netty.handler.codec.ByteToMessageDecoder for testing purposes

package io.netty.handler.codec;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufAllocator;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import java.util.List;

abstract public class ByteToMessageDecoder extends ChannelInboundHandlerAdapter
{
    protected ByteBuf internalBuffer(){ return null; }
    protected ByteToMessageDecoder(){}
    protected abstract void decode(ChannelHandlerContext p0, ByteBuf p1, List<Object> p2);
    protected final void discardSomeReadBytes(){}
    protected int actualReadableBytes(){ return 0; }
    protected void callDecode(ChannelHandlerContext p0, ByteBuf p1, List<Object> p2){}
    protected void decodeLast(ChannelHandlerContext p0, ByteBuf p1, List<Object> p2){}
    protected void handlerRemoved0(ChannelHandlerContext p0){}
    public boolean isSingleDecode(){ return false; }
    public final void handlerRemoved(ChannelHandlerContext p0){}
    public static ByteToMessageDecoder.Cumulator COMPOSITE_CUMULATOR = null;
    public static ByteToMessageDecoder.Cumulator MERGE_CUMULATOR = null;
    public void channelInactive(ChannelHandlerContext p0){}
    public void channelRead(ChannelHandlerContext p0, Object p1){}
    public void channelReadComplete(ChannelHandlerContext p0){}
    public void setCumulator(ByteToMessageDecoder.Cumulator p0){}
    public void setDiscardAfterReads(int p0){}
    public void setSingleDecode(boolean p0){}
    public void userEventTriggered(ChannelHandlerContext p0, Object p1){}
    static public interface Cumulator
    {
        ByteBuf cumulate(ByteBufAllocator p0, ByteBuf p1, ByteBuf p2);
    }
}
