// Generated automatically from io.netty.channel.RecvByteBufAllocator for testing purposes

package io.netty.channel;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufAllocator;
import io.netty.channel.ChannelConfig;

public interface RecvByteBufAllocator
{
    RecvByteBufAllocator.Handle newHandle();
    static public interface Handle
    {
        ByteBuf allocate(ByteBufAllocator p0);
        boolean continueReading();
        int attemptedBytesRead();
        int guess();
        int lastBytesRead();
        void attemptedBytesRead(int p0);
        void incMessagesRead(int p0);
        void lastBytesRead(int p0);
        void readComplete();
        void reset(ChannelConfig p0);
    }
}
