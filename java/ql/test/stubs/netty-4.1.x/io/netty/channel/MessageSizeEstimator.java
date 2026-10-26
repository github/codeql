// Generated automatically from io.netty.channel.MessageSizeEstimator for testing purposes

package io.netty.channel;


public interface MessageSizeEstimator
{
    MessageSizeEstimator.Handle newHandle();
    static public interface Handle
    {
        int size(Object p0);
    }
}
