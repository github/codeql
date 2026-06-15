// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketEncryptionResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.ServerSideEncryptionConfiguration;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketEncryptionResponse extends S3Response implements ToCopyableBuilder<GetBucketEncryptionResponse.Builder, GetBucketEncryptionResponse>
{
    protected GetBucketEncryptionResponse() {}
    public GetBucketEncryptionResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ServerSideEncryptionConfiguration serverSideEncryptionConfiguration(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketEncryptionResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketEncryptionResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketEncryptionResponse.Builder, GetBucketEncryptionResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketEncryptionResponse.Builder serverSideEncryptionConfiguration(ServerSideEncryptionConfiguration p0);
        default GetBucketEncryptionResponse.Builder serverSideEncryptionConfiguration(java.util.function.Consumer<ServerSideEncryptionConfiguration.Builder> p0){ return null; }
    }
}
