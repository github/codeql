// Generated automatically from software.amazon.awssdk.services.s3.endpoints.S3EndpointParams for testing purposes

package software.amazon.awssdk.services.s3.endpoints;

import software.amazon.awssdk.regions.Region;

public class S3EndpointParams
{
    protected S3EndpointParams() {}
    public Boolean accelerate(){ return null; }
    public Boolean disableAccessPoints(){ return null; }
    public Boolean disableMultiRegionAccessPoints(){ return null; }
    public Boolean forcePathStyle(){ return null; }
    public Boolean useArnRegion(){ return null; }
    public Boolean useDualStack(){ return null; }
    public Boolean useFips(){ return null; }
    public Boolean useGlobalEndpoint(){ return null; }
    public Boolean useObjectLambdaEndpoint(){ return null; }
    public Region region(){ return null; }
    public String bucket(){ return null; }
    public String endpoint(){ return null; }
    public static S3EndpointParams.Builder builder(){ return null; }
    static public interface Builder
    {
        S3EndpointParams build();
        S3EndpointParams.Builder accelerate(Boolean p0);
        S3EndpointParams.Builder bucket(String p0);
        S3EndpointParams.Builder disableAccessPoints(Boolean p0);
        S3EndpointParams.Builder disableMultiRegionAccessPoints(Boolean p0);
        S3EndpointParams.Builder endpoint(String p0);
        S3EndpointParams.Builder forcePathStyle(Boolean p0);
        S3EndpointParams.Builder region(Region p0);
        S3EndpointParams.Builder useArnRegion(Boolean p0);
        S3EndpointParams.Builder useDualStack(Boolean p0);
        S3EndpointParams.Builder useFips(Boolean p0);
        S3EndpointParams.Builder useGlobalEndpoint(Boolean p0);
        S3EndpointParams.Builder useObjectLambdaEndpoint(Boolean p0);
    }
}
