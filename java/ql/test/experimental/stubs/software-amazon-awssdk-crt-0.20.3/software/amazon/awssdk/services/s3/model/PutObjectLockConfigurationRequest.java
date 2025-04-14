// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectLockConfigurationRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.ObjectLockConfiguration;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutObjectLockConfigurationRequest extends S3Request implements ToCopyableBuilder<PutObjectLockConfigurationRequest.Builder, PutObjectLockConfigurationRequest>
{
    protected PutObjectLockConfigurationRequest() {}
    public PutObjectLockConfigurationRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockConfiguration objectLockConfiguration(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final String token(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutObjectLockConfigurationRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectLockConfigurationRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectLockConfigurationRequest.Builder, PutObjectLockConfigurationRequest>, S3Request.Builder, SdkPojo
    {
        PutObjectLockConfigurationRequest.Builder bucket(String p0);
        PutObjectLockConfigurationRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutObjectLockConfigurationRequest.Builder checksumAlgorithm(String p0);
        PutObjectLockConfigurationRequest.Builder contentMD5(String p0);
        PutObjectLockConfigurationRequest.Builder expectedBucketOwner(String p0);
        PutObjectLockConfigurationRequest.Builder objectLockConfiguration(ObjectLockConfiguration p0);
        PutObjectLockConfigurationRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutObjectLockConfigurationRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutObjectLockConfigurationRequest.Builder requestPayer(RequestPayer p0);
        PutObjectLockConfigurationRequest.Builder requestPayer(String p0);
        PutObjectLockConfigurationRequest.Builder token(String p0);
        default PutObjectLockConfigurationRequest.Builder objectLockConfiguration(java.util.function.Consumer<ObjectLockConfiguration.Builder> p0){ return null; }
    }
}
