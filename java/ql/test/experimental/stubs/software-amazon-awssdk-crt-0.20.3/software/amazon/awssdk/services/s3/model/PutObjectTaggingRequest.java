// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectTaggingRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.Tagging;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutObjectTaggingRequest extends S3Request implements ToCopyableBuilder<PutObjectTaggingRequest.Builder, PutObjectTaggingRequest>
{
    protected PutObjectTaggingRequest() {}
    public PutObjectTaggingRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final Tagging tagging(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutObjectTaggingRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectTaggingRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectTaggingRequest.Builder, PutObjectTaggingRequest>, S3Request.Builder, SdkPojo
    {
        PutObjectTaggingRequest.Builder bucket(String p0);
        PutObjectTaggingRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutObjectTaggingRequest.Builder checksumAlgorithm(String p0);
        PutObjectTaggingRequest.Builder contentMD5(String p0);
        PutObjectTaggingRequest.Builder expectedBucketOwner(String p0);
        PutObjectTaggingRequest.Builder key(String p0);
        PutObjectTaggingRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutObjectTaggingRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutObjectTaggingRequest.Builder requestPayer(RequestPayer p0);
        PutObjectTaggingRequest.Builder requestPayer(String p0);
        PutObjectTaggingRequest.Builder tagging(Tagging p0);
        PutObjectTaggingRequest.Builder versionId(String p0);
        default PutObjectTaggingRequest.Builder tagging(java.util.function.Consumer<Tagging.Builder> p0){ return null; }
    }
}
