// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketWebsiteRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.WebsiteConfiguration;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketWebsiteRequest extends S3Request implements ToCopyableBuilder<PutBucketWebsiteRequest.Builder, PutBucketWebsiteRequest>
{
    protected PutBucketWebsiteRequest() {}
    public PutBucketWebsiteRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final WebsiteConfiguration websiteConfiguration(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketWebsiteRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketWebsiteRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketWebsiteRequest.Builder, PutBucketWebsiteRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketWebsiteRequest.Builder bucket(String p0);
        PutBucketWebsiteRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketWebsiteRequest.Builder checksumAlgorithm(String p0);
        PutBucketWebsiteRequest.Builder contentMD5(String p0);
        PutBucketWebsiteRequest.Builder expectedBucketOwner(String p0);
        PutBucketWebsiteRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketWebsiteRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutBucketWebsiteRequest.Builder websiteConfiguration(WebsiteConfiguration p0);
        default PutBucketWebsiteRequest.Builder websiteConfiguration(java.util.function.Consumer<WebsiteConfiguration.Builder> p0){ return null; }
    }
}
