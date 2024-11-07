// Generated automatically from software.amazon.awssdk.services.s3.model.S3Request for testing purposes

package software.amazon.awssdk.services.s3.model;

import software.amazon.awssdk.awscore.AwsRequest;

abstract public class S3Request extends AwsRequest
{
    protected S3Request() {}
    protected S3Request(S3Request.Builder p0){}
    public abstract S3Request.Builder toBuilder();
    static public interface Builder extends AwsRequest.Builder
    {
        S3Request build();
    }
}
