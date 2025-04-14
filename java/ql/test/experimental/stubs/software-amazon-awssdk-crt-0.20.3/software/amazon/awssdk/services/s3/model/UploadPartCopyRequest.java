// Generated automatically from software.amazon.awssdk.services.s3.model.UploadPartCopyRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class UploadPartCopyRequest extends S3Request implements ToCopyableBuilder<UploadPartCopyRequest.Builder, UploadPartCopyRequest>
{
    protected UploadPartCopyRequest() {}
    public UploadPartCopyRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Instant copySourceIfModifiedSince(){ return null; }
    public final Instant copySourceIfUnmodifiedSince(){ return null; }
    public final Integer partNumber(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String copySource(){ return null; }
    public final String copySourceIfMatch(){ return null; }
    public final String copySourceIfNoneMatch(){ return null; }
    public final String copySourceRange(){ return null; }
    public final String copySourceSSECustomerAlgorithm(){ return null; }
    public final String copySourceSSECustomerKey(){ return null; }
    public final String copySourceSSECustomerKeyMD5(){ return null; }
    public final String destinationBucket(){ return null; }
    public final String destinationKey(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String expectedSourceBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String sourceBucket(){ return null; }
    public final String sourceKey(){ return null; }
    public final String sourceVersionId(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKey(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String toString(){ return null; }
    public final String uploadId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static UploadPartCopyRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends UploadPartCopyRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<UploadPartCopyRequest.Builder, UploadPartCopyRequest>, S3Request.Builder, SdkPojo
    {
        UploadPartCopyRequest.Builder bucket(String p0);
        UploadPartCopyRequest.Builder copySource(String p0);
        UploadPartCopyRequest.Builder copySourceIfMatch(String p0);
        UploadPartCopyRequest.Builder copySourceIfModifiedSince(Instant p0);
        UploadPartCopyRequest.Builder copySourceIfNoneMatch(String p0);
        UploadPartCopyRequest.Builder copySourceIfUnmodifiedSince(Instant p0);
        UploadPartCopyRequest.Builder copySourceRange(String p0);
        UploadPartCopyRequest.Builder copySourceSSECustomerAlgorithm(String p0);
        UploadPartCopyRequest.Builder copySourceSSECustomerKey(String p0);
        UploadPartCopyRequest.Builder copySourceSSECustomerKeyMD5(String p0);
        UploadPartCopyRequest.Builder destinationBucket(String p0);
        UploadPartCopyRequest.Builder destinationKey(String p0);
        UploadPartCopyRequest.Builder expectedBucketOwner(String p0);
        UploadPartCopyRequest.Builder expectedSourceBucketOwner(String p0);
        UploadPartCopyRequest.Builder key(String p0);
        UploadPartCopyRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        UploadPartCopyRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        UploadPartCopyRequest.Builder partNumber(Integer p0);
        UploadPartCopyRequest.Builder requestPayer(RequestPayer p0);
        UploadPartCopyRequest.Builder requestPayer(String p0);
        UploadPartCopyRequest.Builder sourceBucket(String p0);
        UploadPartCopyRequest.Builder sourceKey(String p0);
        UploadPartCopyRequest.Builder sourceVersionId(String p0);
        UploadPartCopyRequest.Builder sseCustomerAlgorithm(String p0);
        UploadPartCopyRequest.Builder sseCustomerKey(String p0);
        UploadPartCopyRequest.Builder sseCustomerKeyMD5(String p0);
        UploadPartCopyRequest.Builder uploadId(String p0);
    }
}
