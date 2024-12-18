// Generated automatically from software.amazon.awssdk.services.s3.model.ListObjectVersionsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CommonPrefix;
import software.amazon.awssdk.services.s3.model.DeleteMarkerEntry;
import software.amazon.awssdk.services.s3.model.EncodingType;
import software.amazon.awssdk.services.s3.model.ObjectVersion;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListObjectVersionsResponse extends S3Response implements ToCopyableBuilder<ListObjectVersionsResponse.Builder, ListObjectVersionsResponse>
{
    protected ListObjectVersionsResponse() {}
    public ListObjectVersionsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final EncodingType encodingType(){ return null; }
    public final Integer maxKeys(){ return null; }
    public final List<CommonPrefix> commonPrefixes(){ return null; }
    public final List<DeleteMarkerEntry> deleteMarkers(){ return null; }
    public final List<ObjectVersion> versions(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String delimiter(){ return null; }
    public final String encodingTypeAsString(){ return null; }
    public final String keyMarker(){ return null; }
    public final String name(){ return null; }
    public final String nextKeyMarker(){ return null; }
    public final String nextVersionIdMarker(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final String versionIdMarker(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasCommonPrefixes(){ return false; }
    public final boolean hasDeleteMarkers(){ return false; }
    public final boolean hasVersions(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListObjectVersionsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListObjectVersionsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListObjectVersionsResponse.Builder, ListObjectVersionsResponse>, S3Response.Builder, SdkPojo
    {
        ListObjectVersionsResponse.Builder commonPrefixes(Collection<CommonPrefix> p0);
        ListObjectVersionsResponse.Builder commonPrefixes(CommonPrefix... p0);
        ListObjectVersionsResponse.Builder commonPrefixes(java.util.function.Consumer<CommonPrefix.Builder>... p0);
        ListObjectVersionsResponse.Builder deleteMarkers(Collection<DeleteMarkerEntry> p0);
        ListObjectVersionsResponse.Builder deleteMarkers(DeleteMarkerEntry... p0);
        ListObjectVersionsResponse.Builder deleteMarkers(java.util.function.Consumer<DeleteMarkerEntry.Builder>... p0);
        ListObjectVersionsResponse.Builder delimiter(String p0);
        ListObjectVersionsResponse.Builder encodingType(EncodingType p0);
        ListObjectVersionsResponse.Builder encodingType(String p0);
        ListObjectVersionsResponse.Builder isTruncated(Boolean p0);
        ListObjectVersionsResponse.Builder keyMarker(String p0);
        ListObjectVersionsResponse.Builder maxKeys(Integer p0);
        ListObjectVersionsResponse.Builder name(String p0);
        ListObjectVersionsResponse.Builder nextKeyMarker(String p0);
        ListObjectVersionsResponse.Builder nextVersionIdMarker(String p0);
        ListObjectVersionsResponse.Builder prefix(String p0);
        ListObjectVersionsResponse.Builder versionIdMarker(String p0);
        ListObjectVersionsResponse.Builder versions(Collection<ObjectVersion> p0);
        ListObjectVersionsResponse.Builder versions(ObjectVersion... p0);
        ListObjectVersionsResponse.Builder versions(java.util.function.Consumer<ObjectVersion.Builder>... p0);
    }
}
