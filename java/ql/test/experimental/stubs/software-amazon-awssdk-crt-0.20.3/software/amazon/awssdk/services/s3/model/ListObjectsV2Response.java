// Generated automatically from software.amazon.awssdk.services.s3.model.ListObjectsV2Response for testing purposes

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

public class ListObjectsV2Response extends S3Response implements ToCopyableBuilder<ListObjectsV2Response.Builder, ListObjectsV2Response>
{
    protected ListObjectsV2Response() {}
    public ListObjectsV2Response.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final EncodingType encodingType(){ return null; }
    public final Integer keyCount(){ return null; }
    public final Integer maxKeys(){ return null; }
    public final List<CommonPrefix> commonPrefixes(){ return null; }
    public final List<S3Object> contents(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String continuationToken(){ return null; }
    public final String delimiter(){ return null; }
    public final String encodingTypeAsString(){ return null; }
    public final String name(){ return null; }
    public final String nextContinuationToken(){ return null; }
    public final String prefix(){ return null; }
    public final String startAfter(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasCommonPrefixes(){ return false; }
    public final boolean hasContents(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListObjectsV2Response.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListObjectsV2Response.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListObjectsV2Response.Builder, ListObjectsV2Response>, S3Response.Builder, SdkPojo
    {
        ListObjectsV2Response.Builder commonPrefixes(Collection<CommonPrefix> p0);
        ListObjectsV2Response.Builder commonPrefixes(CommonPrefix... p0);
        ListObjectsV2Response.Builder commonPrefixes(java.util.function.Consumer<CommonPrefix.Builder>... p0);
        ListObjectsV2Response.Builder contents(Collection<S3Object> p0);
        ListObjectsV2Response.Builder contents(S3Object... p0);
        ListObjectsV2Response.Builder contents(java.util.function.Consumer<S3Object.Builder>... p0);
        ListObjectsV2Response.Builder continuationToken(String p0);
        ListObjectsV2Response.Builder delimiter(String p0);
        ListObjectsV2Response.Builder encodingType(EncodingType p0);
        ListObjectsV2Response.Builder encodingType(String p0);
        ListObjectsV2Response.Builder isTruncated(Boolean p0);
        ListObjectsV2Response.Builder keyCount(Integer p0);
        ListObjectsV2Response.Builder maxKeys(Integer p0);
        ListObjectsV2Response.Builder name(String p0);
        ListObjectsV2Response.Builder nextContinuationToken(String p0);
        ListObjectsV2Response.Builder prefix(String p0);
        ListObjectsV2Response.Builder startAfter(String p0);
    }
}
