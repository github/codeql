// Generated automatically from software.amazon.awssdk.services.s3.model.AbortMultipartUploadResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class AbortMultipartUploadResponse extends S3Response implements ToCopyableBuilder<AbortMultipartUploadResponse.Builder, AbortMultipartUploadResponse>
{
    protected AbortMultipartUploadResponse() {}
    public AbortMultipartUploadResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static AbortMultipartUploadResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends AbortMultipartUploadResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<AbortMultipartUploadResponse.Builder, AbortMultipartUploadResponse>, S3Response.Builder, SdkPojo
    {
        AbortMultipartUploadResponse.Builder requestCharged(RequestCharged p0);
        AbortMultipartUploadResponse.Builder requestCharged(String p0);
    }
}
