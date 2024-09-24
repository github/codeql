// Generated automatically from software.amazon.awssdk.services.s3.S3BaseClientBuilder for testing purposes

package software.amazon.awssdk.services.s3;

import java.util.function.Consumer;
import software.amazon.awssdk.awscore.client.builder.AwsClientBuilder;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.endpoints.S3EndpointProvider;

public interface S3BaseClientBuilder<B extends S3BaseClientBuilder<B, C>, C> extends AwsClientBuilder<B, C>
{
    B accelerate(Boolean p0);
    B disableMultiRegionAccessPoints(Boolean p0);
    B forcePathStyle(Boolean p0);
    B serviceConfiguration(S3Configuration p0);
    B useArnRegion(Boolean p0);
    default B endpointProvider(S3EndpointProvider p0){ return null; }
    default B serviceConfiguration(java.util.function.Consumer<S3Configuration.Builder> p0){ return null; }
}
