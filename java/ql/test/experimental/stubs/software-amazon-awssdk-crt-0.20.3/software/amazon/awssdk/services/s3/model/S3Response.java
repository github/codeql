// Generated automatically from software.amazon.awssdk.services.s3.model.S3Response for testing purposes

package software.amazon.awssdk.services.s3.model;

import software.amazon.awssdk.awscore.AwsResponse;
import software.amazon.awssdk.awscore.AwsResponseMetadata;
import software.amazon.awssdk.services.s3.model.S3ResponseMetadata;

abstract public class S3Response extends AwsResponse
{
    protected S3Response() {}
    protected S3Response(S3Response.Builder p0){}
    public S3ResponseMetadata responseMetadata(){ return null; }
    static public interface Builder extends AwsResponse.Builder
    {
        S3Response build();
        S3Response.Builder responseMetadata(AwsResponseMetadata p0);
        S3ResponseMetadata responseMetadata();
    }
}
