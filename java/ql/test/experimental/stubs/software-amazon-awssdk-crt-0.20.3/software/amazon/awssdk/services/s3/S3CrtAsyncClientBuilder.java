// Generated automatically from software.amazon.awssdk.services.s3.S3CrtAsyncClientBuilder for testing purposes

package software.amazon.awssdk.services.s3;

import java.net.URI;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.utils.builder.SdkBuilder;

public interface S3CrtAsyncClientBuilder extends SdkBuilder<S3CrtAsyncClientBuilder, S3AsyncClient>
{
    S3AsyncClient build();
    S3CrtAsyncClientBuilder checksumValidationEnabled(Boolean p0);
    S3CrtAsyncClientBuilder credentialsProvider(AwsCredentialsProvider p0);
    S3CrtAsyncClientBuilder endpointOverride(URI p0);
    S3CrtAsyncClientBuilder initialReadBufferSizeInBytes(Long p0);
    S3CrtAsyncClientBuilder maxConcurrency(Integer p0);
    S3CrtAsyncClientBuilder minimumPartSizeInBytes(Long p0);
    S3CrtAsyncClientBuilder region(Region p0);
    S3CrtAsyncClientBuilder targetThroughputInGbps(Double p0);
}
