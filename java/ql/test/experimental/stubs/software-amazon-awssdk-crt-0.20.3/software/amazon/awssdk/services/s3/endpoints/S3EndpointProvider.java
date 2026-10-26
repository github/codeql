// Generated automatically from software.amazon.awssdk.services.s3.endpoints.S3EndpointProvider for testing purposes

package software.amazon.awssdk.services.s3.endpoints;

import java.util.concurrent.CompletableFuture;
import java.util.function.Consumer;
import software.amazon.awssdk.endpoints.Endpoint;
import software.amazon.awssdk.endpoints.EndpointProvider;
import software.amazon.awssdk.services.s3.endpoints.S3EndpointParams;

public interface S3EndpointProvider extends EndpointProvider
{
    CompletableFuture<Endpoint> resolveEndpoint(S3EndpointParams p0);
    default CompletableFuture<Endpoint> resolveEndpoint(java.util.function.Consumer<S3EndpointParams.Builder> p0){ return null; }
    static S3EndpointProvider defaultProvider(){ return null; }
}
