// Generated automatically from okhttp3.internal.http2.Http2Stream for testing purposes

package okhttp3.internal.http2;

import java.io.IOException;
import java.util.List;
import okhttp3.Headers;
import okhttp3.internal.http2.ErrorCode;
import okhttp3.internal.http2.Header;
import okhttp3.internal.http2.Http2Connection;
import okio.AsyncTimeout;
import okio.Buffer;
import okio.BufferedSource;
import okio.Sink;
import okio.Source;
import okio.Timeout;

public class Http2Stream
{
    protected Http2Stream() {}
    public Http2Stream(int p0, Http2Connection p1, boolean p2, boolean p3, Headers p4){}
    public class FramingSink implements Sink
    {
        protected FramingSink() {}
        public FramingSink(boolean p0){}
        public Timeout timeout(){ return null; }
        public final Headers getTrailers(){ return null; }
        public final boolean getClosed(){ return false; }
        public final boolean getFinished(){ return false; }
        public final void setClosed(boolean p0){}
        public final void setFinished(boolean p0){}
        public final void setTrailers(Headers p0){}
        public void close(){}
        public void flush(){}
        public void write(Buffer p0, long p1){}
    }
    public class FramingSource implements Source
    {
        protected FramingSource() {}
        public FramingSource(long p0, boolean p1){}
        public Timeout timeout(){ return null; }
        public final Buffer getReadBuffer(){ return null; }
        public final Buffer getReceiveBuffer(){ return null; }
        public final Headers getTrailers(){ return null; }
        public final boolean getClosed$okhttp(){ return false; }
        public final boolean getFinished$okhttp(){ return false; }
        public final void receive$okhttp(BufferedSource p0, long p1){}
        public final void setClosed$okhttp(boolean p0){}
        public final void setFinished$okhttp(boolean p0){}
        public final void setTrailers(Headers p0){}
        public long read(Buffer p0, long p1){ return 0; }
        public void close(){}
    }
    public class StreamTimeout extends AsyncTimeout
    {
        protected IOException newTimeoutException(IOException p0){ return null; }
        protected void timedOut(){}
        public StreamTimeout(){}
        public final void exitAndThrowIfTimedOut(){}
    }
    public final ErrorCode getErrorCode$okhttp(){ return null; }
    public final Headers takeHeaders(){ return null; }
    public final Headers trailers(){ return null; }
    public final Http2Connection getConnection(){ return null; }
    public final Http2Stream.FramingSink getSink$okhttp(){ return null; }
    public final Http2Stream.FramingSource getSource$okhttp(){ return null; }
    public final Http2Stream.StreamTimeout getReadTimeout$okhttp(){ return null; }
    public final Http2Stream.StreamTimeout getWriteTimeout$okhttp(){ return null; }
    public final IOException getErrorException$okhttp(){ return null; }
    public final Sink getSink(){ return null; }
    public final Source getSource(){ return null; }
    public final Timeout readTimeout(){ return null; }
    public final Timeout writeTimeout(){ return null; }
    public final boolean isLocallyInitiated(){ return false; }
    public final boolean isOpen(){ return false; }
    public final int getId(){ return 0; }
    public final long getReadBytesAcknowledged(){ return 0; }
    public final long getReadBytesTotal(){ return 0; }
    public final long getWriteBytesMaximum(){ return 0; }
    public final long getWriteBytesTotal(){ return 0; }
    public final void addBytesToWriteWindow(long p0){}
    public final void cancelStreamIfNecessary$okhttp(){}
    public final void checkOutNotClosed$okhttp(){}
    public final void close(ErrorCode p0, IOException p1){}
    public final void closeLater(ErrorCode p0){}
    public final void enqueueTrailers(Headers p0){}
    public final void receiveData(BufferedSource p0, int p1){}
    public final void receiveHeaders(Headers p0, boolean p1){}
    public final void receiveRstStream(ErrorCode p0){}
    public final void setErrorCode$okhttp(ErrorCode p0){}
    public final void setErrorException$okhttp(IOException p0){}
    public final void setReadBytesAcknowledged$okhttp(long p0){}
    public final void setReadBytesTotal$okhttp(long p0){}
    public final void setWriteBytesMaximum$okhttp(long p0){}
    public final void setWriteBytesTotal$okhttp(long p0){}
    public final void waitForIo$okhttp(){}
    public final void writeHeaders(List<Header> p0, boolean p1, boolean p2){}
    public static Http2Stream.Companion Companion = null;
    public static long EMIT_BUFFER_SIZE = 0;
    static public class Companion
    {
        protected Companion() {}
    }
}
