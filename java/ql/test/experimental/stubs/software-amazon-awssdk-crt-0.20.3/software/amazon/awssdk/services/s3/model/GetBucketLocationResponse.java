// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketLocationResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketLocationConstraint;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketLocationResponse extends S3Response implements ToCopyableBuilder<GetBucketLocationResponse.Builder, GetBucketLocationResponse>
{
    protected GetBucketLocationResponse() {}
    public GetBucketLocationResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final BucketLocationConstraint locationConstraint(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String locationConstraintAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketLocationResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketLocationResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketLocationResponse.Builder, GetBucketLocationResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketLocationResponse.Builder locationConstraint(BucketLocationConstraint p0);
        GetBucketLocationResponse.Builder locationConstraint(String p0);
    }
}
