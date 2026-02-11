// Generated automatically from software.amazon.awssdk.core.interceptor.Context for testing purposes

package software.amazon.awssdk.core.interceptor;

import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.Optional;
import org.reactivestreams.Publisher;
import software.amazon.awssdk.core.SdkRequest;
import software.amazon.awssdk.core.SdkResponse;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.http.SdkHttpRequest;
import software.amazon.awssdk.http.SdkHttpResponse;

public class Context
{
    protected Context() {}
    static public interface AfterExecution extends Context.ModifyResponse
    {
    }
    static public interface AfterMarshalling extends Context.BeforeMarshalling
    {
        Optional<AsyncRequestBody> asyncRequestBody();
        Optional<RequestBody> requestBody();
        SdkHttpRequest httpRequest();
    }
    static public interface AfterTransmission extends Context.BeforeTransmission
    {
        Optional<InputStream> responseBody();
        Optional<Publisher<ByteBuffer>> responsePublisher();
        SdkHttpResponse httpResponse();
    }
    static public interface AfterUnmarshalling extends Context.BeforeUnmarshalling
    {
        SdkResponse response();
    }
    static public interface BeforeExecution
    {
        SdkRequest request();
    }
    static public interface BeforeMarshalling extends Context.ModifyRequest
    {
    }
    static public interface BeforeTransmission extends Context.ModifyHttpRequest
    {
    }
    static public interface BeforeUnmarshalling extends Context.ModifyHttpResponse
    {
    }
    static public interface FailedExecution
    {
        Optional<SdkHttpRequest> httpRequest();
        Optional<SdkHttpResponse> httpResponse();
        Optional<SdkResponse> response();
        SdkRequest request();
        Throwable exception();
    }
    static public interface ModifyHttpRequest extends Context.AfterMarshalling
    {
    }
    static public interface ModifyHttpResponse extends Context.AfterTransmission
    {
    }
    static public interface ModifyRequest extends Context.BeforeExecution
    {
    }
    static public interface ModifyResponse extends Context.AfterUnmarshalling
    {
    }
}
