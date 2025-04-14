// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketVersioningResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketVersioningStatus;
import software.amazon.awssdk.services.s3.model.MFADeleteStatus;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketVersioningResponse extends S3Response implements ToCopyableBuilder<GetBucketVersioningResponse.Builder, GetBucketVersioningResponse>
{
    protected GetBucketVersioningResponse() {}
    public GetBucketVersioningResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final BucketVersioningStatus status(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final MFADeleteStatus mfaDelete(){ return null; }
    public final String mfaDeleteAsString(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketVersioningResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketVersioningResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketVersioningResponse.Builder, GetBucketVersioningResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketVersioningResponse.Builder mfaDelete(MFADeleteStatus p0);
        GetBucketVersioningResponse.Builder mfaDelete(String p0);
        GetBucketVersioningResponse.Builder status(BucketVersioningStatus p0);
        GetBucketVersioningResponse.Builder status(String p0);
    }
}
