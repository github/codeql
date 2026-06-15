// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketVersioningRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.VersioningConfiguration;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketVersioningRequest extends S3Request implements ToCopyableBuilder<PutBucketVersioningRequest.Builder, PutBucketVersioningRequest>
{
    protected PutBucketVersioningRequest() {}
    public PutBucketVersioningRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String mfa(){ return null; }
    public final String toString(){ return null; }
    public final VersioningConfiguration versioningConfiguration(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketVersioningRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketVersioningRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketVersioningRequest.Builder, PutBucketVersioningRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketVersioningRequest.Builder bucket(String p0);
        PutBucketVersioningRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketVersioningRequest.Builder checksumAlgorithm(String p0);
        PutBucketVersioningRequest.Builder contentMD5(String p0);
        PutBucketVersioningRequest.Builder expectedBucketOwner(String p0);
        PutBucketVersioningRequest.Builder mfa(String p0);
        PutBucketVersioningRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketVersioningRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutBucketVersioningRequest.Builder versioningConfiguration(VersioningConfiguration p0);
        default PutBucketVersioningRequest.Builder versioningConfiguration(java.util.function.Consumer<VersioningConfiguration.Builder> p0){ return null; }
    }
}
