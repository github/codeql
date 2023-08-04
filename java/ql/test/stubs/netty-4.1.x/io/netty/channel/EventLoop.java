// Generated automatically from io.netty.channel.EventLoop for testing purposes

package io.netty.channel;

import io.netty.channel.EventLoopGroup;
import io.netty.util.concurrent.OrderedEventExecutor;

public interface EventLoop extends EventLoopGroup, OrderedEventExecutor
{
    EventLoopGroup parent();
}
