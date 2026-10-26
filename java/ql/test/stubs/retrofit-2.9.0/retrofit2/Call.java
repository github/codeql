// Generated automatically from retrofit2.Call for testing purposes

package retrofit2;

import okhttp3.Request;
import okio.Timeout;
import retrofit2.Callback;
import retrofit2.Response;

public interface Call<T> extends Cloneable
{
    Call<T> clone();
    Request request();
    Response<T> execute();
    Timeout timeout();
    boolean isCanceled();
    boolean isExecuted();
    void cancel();
    void enqueue(Callback<T> p0);
}
