// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectAttributesResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Checksum;
import software.amazon.awssdk.services.s3.model.GetObjectAttributesParts;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectAttributesResponse extends S3Response implements ToCopyableBuilder<GetObjectAttributesResponse.Builder, GetObjectAttributesResponse>
{
    protected GetObjectAttributesResponse() {}
    public GetObjectAttributesResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean deleteMarker(){ return null; }
    public final Checksum checksum(){ return null; }
    public final GetObjectAttributesParts objectParts(){ return null; }
    public final Instant lastModified(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Long objectSize(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final StorageClass storageClass(){ return null; }
    public final String eTag(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectAttributesResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectAttributesResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectAttributesResponse.Builder, GetObjectAttributesResponse>, S3Response.Builder, SdkPojo
    {
        GetObjectAttributesResponse.Builder checksum(Checksum p0);
        GetObjectAttributesResponse.Builder deleteMarker(Boolean p0);
        GetObjectAttributesResponse.Builder eTag(String p0);
        GetObjectAttributesResponse.Builder lastModified(Instant p0);
        GetObjectAttributesResponse.Builder objectParts(GetObjectAttributesParts p0);
        GetObjectAttributesResponse.Builder objectSize(Long p0);
        GetObjectAttributesResponse.Builder requestCharged(RequestCharged p0);
        GetObjectAttributesResponse.Builder requestCharged(String p0);
        GetObjectAttributesResponse.Builder storageClass(StorageClass p0);
        GetObjectAttributesResponse.Builder storageClass(String p0);
        GetObjectAttributesResponse.Builder versionId(String p0);
        default GetObjectAttributesResponse.Builder checksum(java.util.function.Consumer<Checksum.Builder> p0){ return null; }
        default GetObjectAttributesResponse.Builder objectParts(java.util.function.Consumer<GetObjectAttributesParts.Builder> p0){ return null; }
    }
}
