// Generated automatically from software.amazon.awssdk.awscore.client.builder.AwsClientBuilder for testing purposes

package software.amazon.awssdk.awscore.client.builder;

import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.awscore.defaultsmode.DefaultsMode;
import software.amazon.awssdk.core.client.builder.SdkClientBuilder;
import software.amazon.awssdk.regions.Region;

public interface AwsClientBuilder<BuilderT extends AwsClientBuilder<BuilderT, ClientT>, ClientT> extends SdkClientBuilder<BuilderT, ClientT>
{
    BuilderT credentialsProvider(AwsCredentialsProvider p0);
    BuilderT dualstackEnabled(Boolean p0);
    BuilderT fipsEnabled(Boolean p0);
    BuilderT region(Region p0);
    default BuilderT defaultsMode(DefaultsMode p0){ return null; }
}
