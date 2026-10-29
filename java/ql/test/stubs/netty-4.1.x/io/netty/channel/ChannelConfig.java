// Generated automatically from io.netty.channel.ChannelConfig for testing purposes

package io.netty.channel;

import io.netty.buffer.ByteBufAllocator;
import io.netty.channel.ChannelOption;
import io.netty.channel.MessageSizeEstimator;
import io.netty.channel.RecvByteBufAllocator;
import io.netty.channel.WriteBufferWaterMark;
import java.util.Map;

public interface ChannelConfig
{
    <T extends RecvByteBufAllocator> T getRecvByteBufAllocator();
    <T> T getOption(io.netty.channel.ChannelOption<T> p0);
    <T> boolean setOption(io.netty.channel.ChannelOption<T> p0, T p1);
    ByteBufAllocator getAllocator();
    ChannelConfig setAllocator(ByteBufAllocator p0);
    ChannelConfig setAutoClose(boolean p0);
    ChannelConfig setAutoRead(boolean p0);
    ChannelConfig setConnectTimeoutMillis(int p0);
    ChannelConfig setMaxMessagesPerRead(int p0);
    ChannelConfig setMessageSizeEstimator(MessageSizeEstimator p0);
    ChannelConfig setRecvByteBufAllocator(RecvByteBufAllocator p0);
    ChannelConfig setWriteBufferHighWaterMark(int p0);
    ChannelConfig setWriteBufferLowWaterMark(int p0);
    ChannelConfig setWriteBufferWaterMark(WriteBufferWaterMark p0);
    ChannelConfig setWriteSpinCount(int p0);
    Map<ChannelOption<? extends Object>, Object> getOptions();
    MessageSizeEstimator getMessageSizeEstimator();
    WriteBufferWaterMark getWriteBufferWaterMark();
    boolean isAutoClose();
    boolean isAutoRead();
    boolean setOptions(Map<ChannelOption<? extends Object>, ? extends Object> p0);
    int getConnectTimeoutMillis();
    int getMaxMessagesPerRead();
    int getWriteBufferHighWaterMark();
    int getWriteBufferLowWaterMark();
    int getWriteSpinCount();
}
