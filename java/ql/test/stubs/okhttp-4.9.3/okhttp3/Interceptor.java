// Generated automatically from okhttp3.Interceptor for testing purposes

package okhttp3;

import java.util.concurrent.TimeUnit;
import kotlin.jvm.functions.Function1;
import okhttp3.Call;
import okhttp3.Connection;
import okhttp3.Request;
import okhttp3.Response;

public interface Interceptor
{
    Response intercept(Interceptor.Chain p0);
    static Interceptor.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final Interceptor invoke(Function1<? super Interceptor.Chain, Response> p0){ return null; }
    }
    static public interface Chain
    {
        Call call();
        Connection connection();
        Interceptor.Chain withConnectTimeout(int p0, TimeUnit p1);
        Interceptor.Chain withReadTimeout(int p0, TimeUnit p1);
        Interceptor.Chain withWriteTimeout(int p0, TimeUnit p1);
        Request request();
        Response proceed(Request p0);
        int connectTimeoutMillis();
        int readTimeoutMillis();
        int writeTimeoutMillis();
    }
}
