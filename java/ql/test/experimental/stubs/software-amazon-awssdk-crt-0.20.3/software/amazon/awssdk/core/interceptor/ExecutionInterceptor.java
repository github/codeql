// Generated automatically from software.amazon.awssdk.core.interceptor.ExecutionInterceptor for testing purposes

package software.amazon.awssdk.core.interceptor;

import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.Optional;
import org.reactivestreams.Publisher;
import software.amazon.awssdk.core.SdkRequest;
import software.amazon.awssdk.core.SdkResponse;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.core.interceptor.Context;
import software.amazon.awssdk.core.interceptor.ExecutionAttributes;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.http.SdkHttpRequest;
import software.amazon.awssdk.http.SdkHttpResponse;

public interface ExecutionInterceptor
{
    default Optional<AsyncRequestBody> modifyAsyncHttpContent(Context.ModifyHttpRequest p0, ExecutionAttributes p1){ return null; }
    default Optional<InputStream> modifyHttpResponseContent(Context.ModifyHttpResponse p0, ExecutionAttributes p1){ return null; }
    default Optional<Publisher<ByteBuffer>> modifyAsyncHttpResponseContent(Context.ModifyHttpResponse p0, ExecutionAttributes p1){ return null; }
    default Optional<RequestBody> modifyHttpContent(Context.ModifyHttpRequest p0, ExecutionAttributes p1){ return null; }
    default SdkHttpRequest modifyHttpRequest(Context.ModifyHttpRequest p0, ExecutionAttributes p1){ return null; }
    default SdkHttpResponse modifyHttpResponse(Context.ModifyHttpResponse p0, ExecutionAttributes p1){ return null; }
    default SdkRequest modifyRequest(Context.ModifyRequest p0, ExecutionAttributes p1){ return null; }
    default SdkResponse modifyResponse(Context.ModifyResponse p0, ExecutionAttributes p1){ return null; }
    default Throwable modifyException(Context.FailedExecution p0, ExecutionAttributes p1){ return null; }
    default void afterExecution(Context.AfterExecution p0, ExecutionAttributes p1){}
    default void afterMarshalling(Context.AfterMarshalling p0, ExecutionAttributes p1){}
    default void afterTransmission(Context.AfterTransmission p0, ExecutionAttributes p1){}
    default void afterUnmarshalling(Context.AfterUnmarshalling p0, ExecutionAttributes p1){}
    default void beforeExecution(Context.BeforeExecution p0, ExecutionAttributes p1){}
    default void beforeMarshalling(Context.BeforeMarshalling p0, ExecutionAttributes p1){}
    default void beforeTransmission(Context.BeforeTransmission p0, ExecutionAttributes p1){}
    default void beforeUnmarshalling(Context.BeforeUnmarshalling p0, ExecutionAttributes p1){}
    default void onExecutionFailure(Context.FailedExecution p0, ExecutionAttributes p1){}
}
