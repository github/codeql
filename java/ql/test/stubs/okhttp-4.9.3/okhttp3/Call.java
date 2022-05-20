// Generated automatically from okhttp3.Call for testing purposes

package okhttp3;

import okhttp3.Callback;
import okhttp3.Request;
import okhttp3.Response;
import okio.Timeout;

public interface Call extends Cloneable
{
    Call clone();
    Request request();
    Response execute();
    Timeout timeout();
    boolean isCanceled();
    boolean isExecuted();
    static public interface Factory
    {
        Call newCall(Request p0);
    }
    void cancel();
    void enqueue(Callback p0);
}
