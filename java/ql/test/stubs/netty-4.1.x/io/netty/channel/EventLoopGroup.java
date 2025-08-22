// Generated automatically from io.netty.channel.EventLoopGroup for testing purposes

package io.netty.channel;

import io.netty.channel.Channel;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelPromise;
import io.netty.channel.EventLoop;
import io.netty.util.concurrent.EventExecutorGroup;

public interface EventLoopGroup extends EventExecutorGroup
{
    ChannelFuture register(Channel p0);
    ChannelFuture register(Channel p0, ChannelPromise p1);
    ChannelFuture register(ChannelPromise p0);
    EventLoop next();
}
