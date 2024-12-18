// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketAccelerateConfigurationRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AccelerateConfiguration;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketAccelerateConfigurationRequest extends S3Request implements ToCopyableBuilder<PutBucketAccelerateConfigurationRequest.Builder, PutBucketAccelerateConfigurationRequest>
{
    protected PutBucketAccelerateConfigurationRequest() {}
    public PutBucketAccelerateConfigurationRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AccelerateConfiguration accelerateConfiguration(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketAccelerateConfigurationRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketAccelerateConfigurationRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketAccelerateConfigurationRequest.Builder, PutBucketAccelerateConfigurationRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketAccelerateConfigurationRequest.Builder accelerateConfiguration(AccelerateConfiguration p0);
        PutBucketAccelerateConfigurationRequest.Builder bucket(String p0);
        PutBucketAccelerateConfigurationRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketAccelerateConfigurationRequest.Builder checksumAlgorithm(String p0);
        PutBucketAccelerateConfigurationRequest.Builder expectedBucketOwner(String p0);
        PutBucketAccelerateConfigurationRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketAccelerateConfigurationRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        default PutBucketAccelerateConfigurationRequest.Builder accelerateConfiguration(java.util.function.Consumer<AccelerateConfiguration.Builder> p0){ return null; }
    }
}
