// Generated automatically from software.amazon.awssdk.services.s3.model.ListObjectsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CommonPrefix;
import software.amazon.awssdk.services.s3.model.EncodingType;
import software.amazon.awssdk.services.s3.model.S3Object;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListObjectsResponse extends S3Response implements ToCopyableBuilder<ListObjectsResponse.Builder, ListObjectsResponse>
{
    protected ListObjectsResponse() {}
    public ListObjectsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final EncodingType encodingType(){ return null; }
    public final Integer maxKeys(){ return null; }
    public final List<CommonPrefix> commonPrefixes(){ return null; }
    public final List<S3Object> contents(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String delimiter(){ return null; }
    public final String encodingTypeAsString(){ return null; }
    public final String marker(){ return null; }
    public final String name(){ return null; }
    public final String nextMarker(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasCommonPrefixes(){ return false; }
    public final boolean hasContents(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListObjectsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListObjectsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListObjectsResponse.Builder, ListObjectsResponse>, S3Response.Builder, SdkPojo
    {
        ListObjectsResponse.Builder commonPrefixes(Collection<CommonPrefix> p0);
        ListObjectsResponse.Builder commonPrefixes(CommonPrefix... p0);
        ListObjectsResponse.Builder commonPrefixes(java.util.function.Consumer<CommonPrefix.Builder>... p0);
        ListObjectsResponse.Builder contents(Collection<S3Object> p0);
        ListObjectsResponse.Builder contents(S3Object... p0);
        ListObjectsResponse.Builder contents(java.util.function.Consumer<S3Object.Builder>... p0);
        ListObjectsResponse.Builder delimiter(String p0);
        ListObjectsResponse.Builder encodingType(EncodingType p0);
        ListObjectsResponse.Builder encodingType(String p0);
        ListObjectsResponse.Builder isTruncated(Boolean p0);
        ListObjectsResponse.Builder marker(String p0);
        ListObjectsResponse.Builder maxKeys(Integer p0);
        ListObjectsResponse.Builder name(String p0);
        ListObjectsResponse.Builder nextMarker(String p0);
        ListObjectsResponse.Builder prefix(String p0);
    }
}
