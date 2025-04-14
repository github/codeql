// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketLoggingRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketLoggingStatus;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketLoggingRequest extends S3Request implements ToCopyableBuilder<PutBucketLoggingRequest.Builder, PutBucketLoggingRequest>
{
    protected PutBucketLoggingRequest() {}
    public PutBucketLoggingRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final BucketLoggingStatus bucketLoggingStatus(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketLoggingRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketLoggingRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketLoggingRequest.Builder, PutBucketLoggingRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketLoggingRequest.Builder bucket(String p0);
        PutBucketLoggingRequest.Builder bucketLoggingStatus(BucketLoggingStatus p0);
        PutBucketLoggingRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketLoggingRequest.Builder checksumAlgorithm(String p0);
        PutBucketLoggingRequest.Builder contentMD5(String p0);
        PutBucketLoggingRequest.Builder expectedBucketOwner(String p0);
        PutBucketLoggingRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketLoggingRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        default PutBucketLoggingRequest.Builder bucketLoggingStatus(java.util.function.Consumer<BucketLoggingStatus.Builder> p0){ return null; }
    }
}
