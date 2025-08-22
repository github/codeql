// Generated automatically from io.netty.channel.ChannelOutboundBuffer for testing purposes

package io.netty.channel;

import io.netty.channel.ChannelPromise;
import java.nio.ByteBuffer;

public class ChannelOutboundBuffer
{
    protected ChannelOutboundBuffer() {}
    public ByteBuffer[] nioBuffers(){ return null; }
    public ByteBuffer[] nioBuffers(int p0, long p1){ return null; }
    public Object current(){ return null; }
    public boolean getUserDefinedWritability(int p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean isWritable(){ return false; }
    public boolean remove(){ return false; }
    public boolean remove(Throwable p0){ return false; }
    public int nioBufferCount(){ return 0; }
    public int size(){ return 0; }
    public long bytesBeforeUnwritable(){ return 0; }
    public long bytesBeforeWritable(){ return 0; }
    public long currentProgress(){ return 0; }
    public long nioBufferSize(){ return 0; }
    public long totalPendingWriteBytes(){ return 0; }
    public void addFlush(){}
    public void addMessage(Object p0, int p1, ChannelPromise p2){}
    public void forEachFlushedMessage(ChannelOutboundBuffer.MessageProcessor p0){}
    public void progress(long p0){}
    public void recycle(){}
    public void removeBytes(long p0){}
    public void setUserDefinedWritability(int p0, boolean p1){}
    static public interface MessageProcessor
    {
        boolean processMessage(Object p0);
    }
}
