// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketOwnershipControlsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.OwnershipControls;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketOwnershipControlsResponse extends S3Response implements ToCopyableBuilder<GetBucketOwnershipControlsResponse.Builder, GetBucketOwnershipControlsResponse>
{
    protected GetBucketOwnershipControlsResponse() {}
    public GetBucketOwnershipControlsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final OwnershipControls ownershipControls(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketOwnershipControlsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketOwnershipControlsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketOwnershipControlsResponse.Builder, GetBucketOwnershipControlsResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketOwnershipControlsResponse.Builder ownershipControls(OwnershipControls p0);
        default GetBucketOwnershipControlsResponse.Builder ownershipControls(java.util.function.Consumer<OwnershipControls.Builder> p0){ return null; }
    }
}
