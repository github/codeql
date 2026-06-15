// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketLoggingResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.LoggingEnabled;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketLoggingResponse extends S3Response implements ToCopyableBuilder<GetBucketLoggingResponse.Builder, GetBucketLoggingResponse>
{
    protected GetBucketLoggingResponse() {}
    public GetBucketLoggingResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final LoggingEnabled loggingEnabled(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketLoggingResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketLoggingResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketLoggingResponse.Builder, GetBucketLoggingResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketLoggingResponse.Builder loggingEnabled(LoggingEnabled p0);
        default GetBucketLoggingResponse.Builder loggingEnabled(java.util.function.Consumer<LoggingEnabled.Builder> p0){ return null; }
    }
}
