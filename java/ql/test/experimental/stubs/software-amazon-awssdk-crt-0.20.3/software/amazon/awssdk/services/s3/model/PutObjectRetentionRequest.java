// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectRetentionRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.ObjectLockRetention;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutObjectRetentionRequest extends S3Request implements ToCopyableBuilder<PutObjectRetentionRequest.Builder, PutObjectRetentionRequest>
{
    protected PutObjectRetentionRequest() {}
    public PutObjectRetentionRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bypassGovernanceRetention(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockRetention retention(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutObjectRetentionRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectRetentionRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectRetentionRequest.Builder, PutObjectRetentionRequest>, S3Request.Builder, SdkPojo
    {
        PutObjectRetentionRequest.Builder bucket(String p0);
        PutObjectRetentionRequest.Builder bypassGovernanceRetention(Boolean p0);
        PutObjectRetentionRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutObjectRetentionRequest.Builder checksumAlgorithm(String p0);
        PutObjectRetentionRequest.Builder contentMD5(String p0);
        PutObjectRetentionRequest.Builder expectedBucketOwner(String p0);
        PutObjectRetentionRequest.Builder key(String p0);
        PutObjectRetentionRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutObjectRetentionRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutObjectRetentionRequest.Builder requestPayer(RequestPayer p0);
        PutObjectRetentionRequest.Builder requestPayer(String p0);
        PutObjectRetentionRequest.Builder retention(ObjectLockRetention p0);
        PutObjectRetentionRequest.Builder versionId(String p0);
        default PutObjectRetentionRequest.Builder retention(java.util.function.Consumer<ObjectLockRetention.Builder> p0){ return null; }
    }
}
