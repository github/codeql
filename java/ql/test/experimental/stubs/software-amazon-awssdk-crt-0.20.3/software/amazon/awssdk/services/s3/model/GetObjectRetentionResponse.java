// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectRetentionResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectLockRetention;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectRetentionResponse extends S3Response implements ToCopyableBuilder<GetObjectRetentionResponse.Builder, GetObjectRetentionResponse>
{
    protected GetObjectRetentionResponse() {}
    public GetObjectRetentionResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockRetention retention(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectRetentionResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectRetentionResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectRetentionResponse.Builder, GetObjectRetentionResponse>, S3Response.Builder, SdkPojo
    {
        GetObjectRetentionResponse.Builder retention(ObjectLockRetention p0);
        default GetObjectRetentionResponse.Builder retention(java.util.function.Consumer<ObjectLockRetention.Builder> p0){ return null; }
    }
}
