// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketAclResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Grant;
import software.amazon.awssdk.services.s3.model.Owner;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketAclResponse extends S3Response implements ToCopyableBuilder<GetBucketAclResponse.Builder, GetBucketAclResponse>
{
    protected GetBucketAclResponse() {}
    public GetBucketAclResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<Grant> grants(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Owner owner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasGrants(){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketAclResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketAclResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketAclResponse.Builder, GetBucketAclResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketAclResponse.Builder grants(Collection<Grant> p0);
        GetBucketAclResponse.Builder grants(Grant... p0);
        GetBucketAclResponse.Builder grants(java.util.function.Consumer<Grant.Builder>... p0);
        GetBucketAclResponse.Builder owner(Owner p0);
        default GetBucketAclResponse.Builder owner(java.util.function.Consumer<Owner.Builder> p0){ return null; }
    }
}
