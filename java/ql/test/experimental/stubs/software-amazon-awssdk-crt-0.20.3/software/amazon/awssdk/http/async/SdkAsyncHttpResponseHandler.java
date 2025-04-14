// Generated automatically from software.amazon.awssdk.http.async.SdkAsyncHttpResponseHandler for testing purposes

package software.amazon.awssdk.http.async;

import java.nio.ByteBuffer;
import org.reactivestreams.Publisher;
import software.amazon.awssdk.http.SdkHttpResponse;

public interface SdkAsyncHttpResponseHandler
{
    void onError(Throwable p0);
    void onHeaders(SdkHttpResponse p0);
    void onStream(Publisher<ByteBuffer> p0);
}
