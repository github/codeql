// Generated automatically from io.netty.handler.codec.http2.Http2Connection for testing purposes

package io.netty.handler.codec.http2;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http2.Http2FlowController;
import io.netty.handler.codec.http2.Http2LocalFlowController;
import io.netty.handler.codec.http2.Http2RemoteFlowController;
import io.netty.handler.codec.http2.Http2Stream;
import io.netty.handler.codec.http2.Http2StreamVisitor;
import io.netty.util.concurrent.Promise;

public interface Http2Connection
{
    Http2Connection.Endpoint<Http2LocalFlowController> local();
    Http2Connection.Endpoint<Http2RemoteFlowController> remote();
    Http2Connection.PropertyKey newKey();
    Http2Stream connectionStream();
    Http2Stream forEachActiveStream(Http2StreamVisitor p0);
    Http2Stream stream(int p0);
    boolean goAwayReceived();
    boolean goAwaySent();
    boolean goAwaySent(int p0, long p1, ByteBuf p2);
    boolean isServer();
    boolean streamMayHaveExisted(int p0);
    int numActiveStreams();
    io.netty.util.concurrent.Future<Void> close(Promise<Void> p0);
    static public interface Endpoint<F extends Http2FlowController>
    {
        F flowController();
        Http2Connection.Endpoint<? extends Http2FlowController> opposite();
        Http2Stream createStream(int p0, boolean p1);
        Http2Stream reservePushStream(int p0, Http2Stream p1);
        boolean allowPushTo();
        boolean canOpenStream();
        boolean created(Http2Stream p0);
        boolean isServer();
        boolean isValidStreamId(int p0);
        boolean mayHaveCreatedStream(int p0);
        int incrementAndGetNextStreamId();
        int lastStreamCreated();
        int lastStreamKnownByPeer();
        int maxActiveStreams();
        int numActiveStreams();
        void allowPushTo(boolean p0);
        void flowController(F p0);
        void maxActiveStreams(int p0);
    }
    static public interface Listener
    {
        void onGoAwayReceived(int p0, long p1, ByteBuf p2);
        void onGoAwaySent(int p0, long p1, ByteBuf p2);
        void onStreamActive(Http2Stream p0);
        void onStreamAdded(Http2Stream p0);
        void onStreamClosed(Http2Stream p0);
        void onStreamHalfClosed(Http2Stream p0);
        void onStreamRemoved(Http2Stream p0);
    }
    static public interface PropertyKey
    {
    }
    void addListener(Http2Connection.Listener p0);
    void goAwayReceived(int p0, long p1, ByteBuf p2);
    void removeListener(Http2Connection.Listener p0);
}
