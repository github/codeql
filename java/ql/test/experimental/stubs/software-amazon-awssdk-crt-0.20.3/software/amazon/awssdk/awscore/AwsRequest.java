// Generated automatically from software.amazon.awssdk.awscore.AwsRequest for testing purposes

package software.amazon.awssdk.awscore;

import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkRequest;

abstract public class AwsRequest extends SdkRequest
{
    protected AwsRequest() {}
    protected AwsRequest(AwsRequest.Builder p0){}
    public abstract AwsRequest.Builder toBuilder();
    public boolean equals(Object p0){ return false; }
    public final Optional<AwsRequestOverrideConfiguration> overrideConfiguration(){ return null; }
    public int hashCode(){ return 0; }
    static public interface Builder extends SdkRequest.Builder
    {
        AwsRequest build();
        AwsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        AwsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        AwsRequestOverrideConfiguration overrideConfiguration();
    }
}
