// Generated automatically from software.amazon.awssdk.services.s3.model.DeleteBucketReplicationRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DeleteBucketReplicationRequest extends S3Request implements ToCopyableBuilder<DeleteBucketReplicationRequest.Builder, DeleteBucketReplicationRequest>
{
    protected DeleteBucketReplicationRequest() {}
    public DeleteBucketReplicationRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static DeleteBucketReplicationRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends DeleteBucketReplicationRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DeleteBucketReplicationRequest.Builder, DeleteBucketReplicationRequest>, S3Request.Builder, SdkPojo
    {
        DeleteBucketReplicationRequest.Builder bucket(String p0);
        DeleteBucketReplicationRequest.Builder expectedBucketOwner(String p0);
        DeleteBucketReplicationRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        DeleteBucketReplicationRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
    }
}
