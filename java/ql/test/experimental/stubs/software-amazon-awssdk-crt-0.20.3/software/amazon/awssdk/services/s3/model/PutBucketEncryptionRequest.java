// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketEncryptionRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.ServerSideEncryptionConfiguration;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketEncryptionRequest extends S3Request implements ToCopyableBuilder<PutBucketEncryptionRequest.Builder, PutBucketEncryptionRequest>
{
    protected PutBucketEncryptionRequest() {}
    public PutBucketEncryptionRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ServerSideEncryptionConfiguration serverSideEncryptionConfiguration(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketEncryptionRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketEncryptionRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketEncryptionRequest.Builder, PutBucketEncryptionRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketEncryptionRequest.Builder bucket(String p0);
        PutBucketEncryptionRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketEncryptionRequest.Builder checksumAlgorithm(String p0);
        PutBucketEncryptionRequest.Builder contentMD5(String p0);
        PutBucketEncryptionRequest.Builder expectedBucketOwner(String p0);
        PutBucketEncryptionRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketEncryptionRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutBucketEncryptionRequest.Builder serverSideEncryptionConfiguration(ServerSideEncryptionConfiguration p0);
        default PutBucketEncryptionRequest.Builder serverSideEncryptionConfiguration(java.util.function.Consumer<ServerSideEncryptionConfiguration.Builder> p0){ return null; }
    }
}
