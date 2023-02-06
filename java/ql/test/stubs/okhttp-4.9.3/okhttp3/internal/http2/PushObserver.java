// Generated automatically from okhttp3.internal.http2.PushObserver for testing purposes

package okhttp3.internal.http2;

import java.util.List;
import okhttp3.internal.http2.ErrorCode;
import okhttp3.internal.http2.Header;
import okio.BufferedSource;

public interface PushObserver
{
    boolean onData(int p0, BufferedSource p1, int p2, boolean p3);
    boolean onHeaders(int p0, List<Header> p1, boolean p2);
    boolean onRequest(int p0, List<Header> p1);
    static PushObserver CANCEL = null;
    static PushObserver.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
    }
    void onReset(int p0, ErrorCode p1);
}
