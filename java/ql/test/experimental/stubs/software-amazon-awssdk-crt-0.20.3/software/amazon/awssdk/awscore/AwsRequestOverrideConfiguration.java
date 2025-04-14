// Generated automatically from software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration for testing purposes

package software.amazon.awssdk.awscore;

import java.util.Optional;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.core.RequestOverrideConfiguration;
import software.amazon.awssdk.utils.builder.SdkBuilder;

public class AwsRequestOverrideConfiguration extends RequestOverrideConfiguration
{
    protected AwsRequestOverrideConfiguration() {}
    public AwsRequestOverrideConfiguration.Builder toBuilder(){ return null; }
    public Optional<AwsCredentialsProvider> credentialsProvider(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static AwsRequestOverrideConfiguration from(RequestOverrideConfiguration p0){ return null; }
    public static AwsRequestOverrideConfiguration.Builder builder(){ return null; }
    static public interface Builder extends RequestOverrideConfiguration.Builder<AwsRequestOverrideConfiguration.Builder>, SdkBuilder<AwsRequestOverrideConfiguration.Builder, AwsRequestOverrideConfiguration>
    {
        AwsCredentialsProvider credentialsProvider();
        AwsRequestOverrideConfiguration build();
        AwsRequestOverrideConfiguration.Builder credentialsProvider(AwsCredentialsProvider p0);
    }
}
