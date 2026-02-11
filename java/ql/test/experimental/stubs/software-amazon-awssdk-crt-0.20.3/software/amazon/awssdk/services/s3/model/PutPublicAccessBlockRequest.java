// Generated automatically from software.amazon.awssdk.services.s3.model.PutPublicAccessBlockRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.PublicAccessBlockConfiguration;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutPublicAccessBlockRequest extends S3Request implements ToCopyableBuilder<PutPublicAccessBlockRequest.Builder, PutPublicAccessBlockRequest>
{
    protected PutPublicAccessBlockRequest() {}
    public PutPublicAccessBlockRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final PublicAccessBlockConfiguration publicAccessBlockConfiguration(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutPublicAccessBlockRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutPublicAccessBlockRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutPublicAccessBlockRequest.Builder, PutPublicAccessBlockRequest>, S3Request.Builder, SdkPojo
    {
        PutPublicAccessBlockRequest.Builder bucket(String p0);
        PutPublicAccessBlockRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutPublicAccessBlockRequest.Builder checksumAlgorithm(String p0);
        PutPublicAccessBlockRequest.Builder contentMD5(String p0);
        PutPublicAccessBlockRequest.Builder expectedBucketOwner(String p0);
        PutPublicAccessBlockRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutPublicAccessBlockRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutPublicAccessBlockRequest.Builder publicAccessBlockConfiguration(PublicAccessBlockConfiguration p0);
        default PutPublicAccessBlockRequest.Builder publicAccessBlockConfiguration(java.util.function.Consumer<PublicAccessBlockConfiguration.Builder> p0){ return null; }
    }
}
