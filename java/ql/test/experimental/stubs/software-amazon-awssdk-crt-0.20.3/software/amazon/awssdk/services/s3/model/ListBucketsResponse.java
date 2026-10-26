// Generated automatically from software.amazon.awssdk.services.s3.model.ListBucketsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Bucket;
import software.amazon.awssdk.services.s3.model.Owner;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListBucketsResponse extends S3Response implements ToCopyableBuilder<ListBucketsResponse.Builder, ListBucketsResponse>
{
    protected ListBucketsResponse() {}
    public ListBucketsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<Bucket> buckets(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Owner owner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasBuckets(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListBucketsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListBucketsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListBucketsResponse.Builder, ListBucketsResponse>, S3Response.Builder, SdkPojo
    {
        ListBucketsResponse.Builder buckets(Bucket... p0);
        ListBucketsResponse.Builder buckets(Collection<Bucket> p0);
        ListBucketsResponse.Builder buckets(java.util.function.Consumer<Bucket.Builder>... p0);
        ListBucketsResponse.Builder owner(Owner p0);
        default ListBucketsResponse.Builder owner(java.util.function.Consumer<Owner.Builder> p0){ return null; }
    }
}
