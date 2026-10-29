// Generated automatically from io.netty.buffer.AbstractReferenceCountedByteBuf for testing purposes

package io.netty.buffer;

import io.netty.buffer.AbstractByteBuf;
import io.netty.buffer.ByteBuf;

abstract public class AbstractReferenceCountedByteBuf extends AbstractByteBuf
{
    protected AbstractReferenceCountedByteBuf() {}
    protected AbstractReferenceCountedByteBuf(int p0){}
    protected abstract void deallocate();
    protected final void resetRefCnt(){}
    protected final void setRefCnt(int p0){}
    public ByteBuf retain(){ return null; }
    public ByteBuf retain(int p0){ return null; }
    public ByteBuf touch(){ return null; }
    public ByteBuf touch(Object p0){ return null; }
    public boolean release(){ return false; }
    public boolean release(int p0){ return false; }
    public int refCnt(){ return 0; }
}
