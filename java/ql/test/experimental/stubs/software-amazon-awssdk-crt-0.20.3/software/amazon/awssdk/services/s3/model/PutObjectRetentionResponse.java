// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectRetentionResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutObjectRetentionResponse extends S3Response implements ToCopyableBuilder<PutObjectRetentionResponse.Builder, PutObjectRetentionResponse>
{
    protected PutObjectRetentionResponse() {}
    public PutObjectRetentionResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutObjectRetentionResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectRetentionResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectRetentionResponse.Builder, PutObjectRetentionResponse>, S3Response.Builder, SdkPojo
    {
        PutObjectRetentionResponse.Builder requestCharged(RequestCharged p0);
        PutObjectRetentionResponse.Builder requestCharged(String p0);
    }
}
