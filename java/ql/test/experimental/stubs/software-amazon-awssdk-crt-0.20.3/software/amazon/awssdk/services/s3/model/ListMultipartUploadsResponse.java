// Generated automatically from software.amazon.awssdk.services.s3.model.ListMultipartUploadsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CommonPrefix;
import software.amazon.awssdk.services.s3.model.EncodingType;
import software.amazon.awssdk.services.s3.model.MultipartUpload;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListMultipartUploadsResponse extends S3Response implements ToCopyableBuilder<ListMultipartUploadsResponse.Builder, ListMultipartUploadsResponse>
{
    protected ListMultipartUploadsResponse() {}
    public ListMultipartUploadsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final EncodingType encodingType(){ return null; }
    public final Integer maxUploads(){ return null; }
    public final List<CommonPrefix> commonPrefixes(){ return null; }
    public final List<MultipartUpload> uploads(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String delimiter(){ return null; }
    public final String encodingTypeAsString(){ return null; }
    public final String keyMarker(){ return null; }
    public final String nextKeyMarker(){ return null; }
    public final String nextUploadIdMarker(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final String uploadIdMarker(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasCommonPrefixes(){ return false; }
    public final boolean hasUploads(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListMultipartUploadsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListMultipartUploadsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListMultipartUploadsResponse.Builder, ListMultipartUploadsResponse>, S3Response.Builder, SdkPojo
    {
        ListMultipartUploadsResponse.Builder bucket(String p0);
        ListMultipartUploadsResponse.Builder commonPrefixes(Collection<CommonPrefix> p0);
        ListMultipartUploadsResponse.Builder commonPrefixes(CommonPrefix... p0);
        ListMultipartUploadsResponse.Builder commonPrefixes(java.util.function.Consumer<CommonPrefix.Builder>... p0);
        ListMultipartUploadsResponse.Builder delimiter(String p0);
        ListMultipartUploadsResponse.Builder encodingType(EncodingType p0);
        ListMultipartUploadsResponse.Builder encodingType(String p0);
        ListMultipartUploadsResponse.Builder isTruncated(Boolean p0);
        ListMultipartUploadsResponse.Builder keyMarker(String p0);
        ListMultipartUploadsResponse.Builder maxUploads(Integer p0);
        ListMultipartUploadsResponse.Builder nextKeyMarker(String p0);
        ListMultipartUploadsResponse.Builder nextUploadIdMarker(String p0);
        ListMultipartUploadsResponse.Builder prefix(String p0);
        ListMultipartUploadsResponse.Builder uploadIdMarker(String p0);
        ListMultipartUploadsResponse.Builder uploads(Collection<MultipartUpload> p0);
        ListMultipartUploadsResponse.Builder uploads(MultipartUpload... p0);
        ListMultipartUploadsResponse.Builder uploads(java.util.function.Consumer<MultipartUpload.Builder>... p0);
    }
}
