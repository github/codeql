// Generated automatically from software.amazon.awssdk.http.async.SdkAsyncHttpClient for testing purposes

package software.amazon.awssdk.http.async;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.http.async.AsyncExecuteRequest;
import software.amazon.awssdk.utils.AttributeMap;
import software.amazon.awssdk.utils.SdkAutoCloseable;
import software.amazon.awssdk.utils.builder.SdkBuilder;

public interface SdkAsyncHttpClient extends SdkAutoCloseable
{
    CompletableFuture<Void> execute(AsyncExecuteRequest p0);
    default String clientName(){ return null; }
    static public interface Builder<T extends SdkAsyncHttpClient.Builder<T>> extends SdkBuilder<T, SdkAsyncHttpClient>
    {
        SdkAsyncHttpClient buildWithDefaults(AttributeMap p0);
        default SdkAsyncHttpClient build(){ return null; }
    }
}
