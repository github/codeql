// Generated automatically from io.netty.util.AbstractReferenceCounted for testing purposes

package io.netty.util;

import io.netty.util.ReferenceCounted;

abstract public class AbstractReferenceCounted implements ReferenceCounted
{
    protected abstract void deallocate();
    protected final void setRefCnt(int p0){}
    public AbstractReferenceCounted(){}
    public ReferenceCounted retain(){ return null; }
    public ReferenceCounted retain(int p0){ return null; }
    public ReferenceCounted touch(){ return null; }
    public boolean release(){ return false; }
    public boolean release(int p0){ return false; }
    public int refCnt(){ return 0; }
}
