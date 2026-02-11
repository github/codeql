// Generated automatically from software.amazon.awssdk.awscore.AwsResponse for testing purposes

package software.amazon.awssdk.awscore;

import software.amazon.awssdk.awscore.AwsResponseMetadata;
import software.amazon.awssdk.core.SdkResponse;

abstract public class AwsResponse extends SdkResponse
{
    protected AwsResponse() {}
    protected AwsResponse(AwsResponse.Builder p0){}
    public AwsResponseMetadata responseMetadata(){ return null; }
    public abstract AwsResponse.Builder toBuilder();
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    static public interface Builder extends SdkResponse.Builder
    {
        AwsResponse build();
        AwsResponse.Builder responseMetadata(AwsResponseMetadata p0);
        AwsResponseMetadata responseMetadata();
    }
}
