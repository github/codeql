// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketTaggingRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.Tagging;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketTaggingRequest extends S3Request implements ToCopyableBuilder<PutBucketTaggingRequest.Builder, PutBucketTaggingRequest>
{
    protected PutBucketTaggingRequest() {}
    public PutBucketTaggingRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final Tagging tagging(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketTaggingRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketTaggingRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketTaggingRequest.Builder, PutBucketTaggingRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketTaggingRequest.Builder bucket(String p0);
        PutBucketTaggingRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketTaggingRequest.Builder checksumAlgorithm(String p0);
        PutBucketTaggingRequest.Builder contentMD5(String p0);
        PutBucketTaggingRequest.Builder expectedBucketOwner(String p0);
        PutBucketTaggingRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketTaggingRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutBucketTaggingRequest.Builder tagging(Tagging p0);
        default PutBucketTaggingRequest.Builder tagging(java.util.function.Consumer<Tagging.Builder> p0){ return null; }
    }
}
