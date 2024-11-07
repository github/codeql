// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketPolicyRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketPolicyRequest extends S3Request implements ToCopyableBuilder<PutBucketPolicyRequest.Builder, PutBucketPolicyRequest>
{
    protected PutBucketPolicyRequest() {}
    public PutBucketPolicyRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean confirmRemoveSelfBucketAccess(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String policy(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketPolicyRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketPolicyRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketPolicyRequest.Builder, PutBucketPolicyRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketPolicyRequest.Builder bucket(String p0);
        PutBucketPolicyRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketPolicyRequest.Builder checksumAlgorithm(String p0);
        PutBucketPolicyRequest.Builder confirmRemoveSelfBucketAccess(Boolean p0);
        PutBucketPolicyRequest.Builder contentMD5(String p0);
        PutBucketPolicyRequest.Builder expectedBucketOwner(String p0);
        PutBucketPolicyRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketPolicyRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutBucketPolicyRequest.Builder policy(String p0);
    }
}
