// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketReplicationResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ReplicationConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketReplicationResponse extends S3Response implements ToCopyableBuilder<GetBucketReplicationResponse.Builder, GetBucketReplicationResponse>
{
    protected GetBucketReplicationResponse() {}
    public GetBucketReplicationResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ReplicationConfiguration replicationConfiguration(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketReplicationResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketReplicationResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketReplicationResponse.Builder, GetBucketReplicationResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketReplicationResponse.Builder replicationConfiguration(ReplicationConfiguration p0);
        default GetBucketReplicationResponse.Builder replicationConfiguration(java.util.function.Consumer<ReplicationConfiguration.Builder> p0){ return null; }
    }
}
