// Generated automatically from io.netty.util.ReferenceCounted for testing purposes

package io.netty.util;


public interface ReferenceCounted
{
    ReferenceCounted retain();
    ReferenceCounted retain(int p0);
    ReferenceCounted touch();
    ReferenceCounted touch(Object p0);
    boolean release();
    boolean release(int p0);
    int refCnt();
}
