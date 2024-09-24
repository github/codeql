// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketLifecycleConfigurationRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketLifecycleConfiguration;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketLifecycleConfigurationRequest extends S3Request implements ToCopyableBuilder<PutBucketLifecycleConfigurationRequest.Builder, PutBucketLifecycleConfigurationRequest>
{
    protected PutBucketLifecycleConfigurationRequest() {}
    public PutBucketLifecycleConfigurationRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final BucketLifecycleConfiguration lifecycleConfiguration(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketLifecycleConfigurationRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketLifecycleConfigurationRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketLifecycleConfigurationRequest.Builder, PutBucketLifecycleConfigurationRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketLifecycleConfigurationRequest.Builder bucket(String p0);
        PutBucketLifecycleConfigurationRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketLifecycleConfigurationRequest.Builder checksumAlgorithm(String p0);
        PutBucketLifecycleConfigurationRequest.Builder expectedBucketOwner(String p0);
        PutBucketLifecycleConfigurationRequest.Builder lifecycleConfiguration(BucketLifecycleConfiguration p0);
        PutBucketLifecycleConfigurationRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketLifecycleConfigurationRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        default PutBucketLifecycleConfigurationRequest.Builder lifecycleConfiguration(java.util.function.Consumer<BucketLifecycleConfiguration.Builder> p0){ return null; }
    }
}
