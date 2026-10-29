// Generated automatically from io.netty.channel.ChannelOption for testing purposes

package io.netty.channel;

import io.netty.buffer.ByteBufAllocator;
import io.netty.channel.MessageSizeEstimator;
import io.netty.channel.RecvByteBufAllocator;
import io.netty.channel.WriteBufferWaterMark;
import io.netty.util.AbstractConstant;
import java.net.InetAddress;
import java.net.NetworkInterface;

public class ChannelOption<T> extends AbstractConstant<ChannelOption<T>>
{
    protected ChannelOption() {}
    protected ChannelOption(String p0){}
    public static <T> io.netty.channel.ChannelOption<T> newInstance(String p0){ return null; }
    public static <T> io.netty.channel.ChannelOption<T> valueOf(Class<? extends Object> p0, String p1){ return null; }
    public static <T> io.netty.channel.ChannelOption<T> valueOf(String p0){ return null; }
    public static ChannelOption<Boolean> ALLOW_HALF_CLOSURE = null;
    public static ChannelOption<Boolean> AUTO_CLOSE = null;
    public static ChannelOption<Boolean> AUTO_READ = null;
    public static ChannelOption<Boolean> DATAGRAM_CHANNEL_ACTIVE_ON_REGISTRATION = null;
    public static ChannelOption<Boolean> IP_MULTICAST_LOOP_DISABLED = null;
    public static ChannelOption<Boolean> SINGLE_EVENTEXECUTOR_PER_GROUP = null;
    public static ChannelOption<Boolean> SO_BROADCAST = null;
    public static ChannelOption<Boolean> SO_KEEPALIVE = null;
    public static ChannelOption<Boolean> SO_REUSEADDR = null;
    public static ChannelOption<Boolean> TCP_FASTOPEN_CONNECT = null;
    public static ChannelOption<Boolean> TCP_NODELAY = null;
    public static ChannelOption<ByteBufAllocator> ALLOCATOR = null;
    public static ChannelOption<InetAddress> IP_MULTICAST_ADDR = null;
    public static ChannelOption<Integer> CONNECT_TIMEOUT_MILLIS = null;
    public static ChannelOption<Integer> IP_MULTICAST_TTL = null;
    public static ChannelOption<Integer> IP_TOS = null;
    public static ChannelOption<Integer> MAX_MESSAGES_PER_READ = null;
    public static ChannelOption<Integer> MAX_MESSAGES_PER_WRITE = null;
    public static ChannelOption<Integer> SO_BACKLOG = null;
    public static ChannelOption<Integer> SO_LINGER = null;
    public static ChannelOption<Integer> SO_RCVBUF = null;
    public static ChannelOption<Integer> SO_SNDBUF = null;
    public static ChannelOption<Integer> SO_TIMEOUT = null;
    public static ChannelOption<Integer> TCP_FASTOPEN = null;
    public static ChannelOption<Integer> WRITE_BUFFER_HIGH_WATER_MARK = null;
    public static ChannelOption<Integer> WRITE_BUFFER_LOW_WATER_MARK = null;
    public static ChannelOption<Integer> WRITE_SPIN_COUNT = null;
    public static ChannelOption<MessageSizeEstimator> MESSAGE_SIZE_ESTIMATOR = null;
    public static ChannelOption<NetworkInterface> IP_MULTICAST_IF = null;
    public static ChannelOption<RecvByteBufAllocator> RCVBUF_ALLOCATOR = null;
    public static ChannelOption<WriteBufferWaterMark> WRITE_BUFFER_WATER_MARK = null;
    public static boolean exists(String p0){ return false; }
    public void validate(T p0){}
}
