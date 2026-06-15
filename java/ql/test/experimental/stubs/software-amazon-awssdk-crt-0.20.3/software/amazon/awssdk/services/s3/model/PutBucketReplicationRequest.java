// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketReplicationRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.ReplicationConfiguration;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketReplicationRequest extends S3Request implements ToCopyableBuilder<PutBucketReplicationRequest.Builder, PutBucketReplicationRequest>
{
    protected PutBucketReplicationRequest() {}
    public PutBucketReplicationRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ReplicationConfiguration replicationConfiguration(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final String token(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketReplicationRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketReplicationRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketReplicationRequest.Builder, PutBucketReplicationRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketReplicationRequest.Builder bucket(String p0);
        PutBucketReplicationRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketReplicationRequest.Builder checksumAlgorithm(String p0);
        PutBucketReplicationRequest.Builder contentMD5(String p0);
        PutBucketReplicationRequest.Builder expectedBucketOwner(String p0);
        PutBucketReplicationRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketReplicationRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutBucketReplicationRequest.Builder replicationConfiguration(ReplicationConfiguration p0);
        PutBucketReplicationRequest.Builder token(String p0);
        default PutBucketReplicationRequest.Builder replicationConfiguration(java.util.function.Consumer<ReplicationConfiguration.Builder> p0){ return null; }
    }
}
