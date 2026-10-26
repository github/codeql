// Generated automatically from okhttp3.internal.http.ExchangeCodec for testing purposes

package okhttp3.internal.http;

import okhttp3.Headers;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.internal.connection.RealConnection;
import okio.Sink;
import okio.Source;

public interface ExchangeCodec
{
    Headers trailers();
    RealConnection getConnection();
    Response.Builder readResponseHeaders(boolean p0);
    Sink createRequestBody(Request p0, long p1);
    Source openResponseBodySource(Response p0);
    long reportedContentLength(Response p0);
    static ExchangeCodec.Companion Companion = null;
    static int DISCARD_STREAM_TIMEOUT_MILLIS = 0;
    static public class Companion
    {
        protected Companion() {}
        public static int DISCARD_STREAM_TIMEOUT_MILLIS = 0;
    }
    void cancel();
    void finishRequest();
    void flushRequest();
    void writeRequestHeaders(Request p0);
}
