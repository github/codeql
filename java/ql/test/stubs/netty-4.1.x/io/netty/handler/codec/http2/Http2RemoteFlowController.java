// Generated automatically from io.netty.handler.codec.http2.Http2RemoteFlowController for testing purposes

package io.netty.handler.codec.http2;

import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http2.Http2FlowController;
import io.netty.handler.codec.http2.Http2Stream;

public interface Http2RemoteFlowController extends Http2FlowController
{
    ChannelHandlerContext channelHandlerContext();
    boolean hasFlowControlled(Http2Stream p0);
    boolean isWritable(Http2Stream p0);
    static public interface FlowControlled
    {
        boolean merge(ChannelHandlerContext p0, Http2RemoteFlowController.FlowControlled p1);
        int size();
        void error(ChannelHandlerContext p0, Throwable p1);
        void write(ChannelHandlerContext p0, int p1);
        void writeComplete();
    }
    static public interface Listener
    {
        void writabilityChanged(Http2Stream p0);
    }
    void addFlowControlled(Http2Stream p0, Http2RemoteFlowController.FlowControlled p1);
    void channelWritabilityChanged();
    void listener(Http2RemoteFlowController.Listener p0);
    void updateDependencyTree(int p0, int p1, short p2, boolean p3);
    void writePendingBytes();
}
