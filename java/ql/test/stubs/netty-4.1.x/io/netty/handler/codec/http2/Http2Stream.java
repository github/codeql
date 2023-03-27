// Generated automatically from io.netty.handler.codec.http2.Http2Stream for testing purposes

package io.netty.handler.codec.http2;

import io.netty.handler.codec.http2.Http2Connection;

public interface Http2Stream
{
    <V> V getProperty(Http2Connection.PropertyKey p0);
    <V> V removeProperty(Http2Connection.PropertyKey p0);
    <V> V setProperty(Http2Connection.PropertyKey p0, V p1);
    Http2Stream close();
    Http2Stream closeLocalSide();
    Http2Stream closeRemoteSide();
    Http2Stream headersReceived(boolean p0);
    Http2Stream headersSent(boolean p0);
    Http2Stream open(boolean p0);
    Http2Stream pushPromiseSent();
    Http2Stream resetSent();
    Http2Stream.State state();
    boolean isHeadersReceived();
    boolean isHeadersSent();
    boolean isPushPromiseSent();
    boolean isResetSent();
    boolean isTrailersReceived();
    boolean isTrailersSent();
    int id();
    static public enum State
    {
        CLOSED, HALF_CLOSED_LOCAL, HALF_CLOSED_REMOTE, IDLE, OPEN, RESERVED_LOCAL, RESERVED_REMOTE;
        private State() {}
        public boolean localSideOpen(){ return false; }
        public boolean remoteSideOpen(){ return false; }
    }
}
