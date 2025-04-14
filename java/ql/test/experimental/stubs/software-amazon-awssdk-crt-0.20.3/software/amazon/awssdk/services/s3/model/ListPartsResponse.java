// Generated automatically from software.amazon.awssdk.services.s3.model.ListPartsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.Initiator;
import software.amazon.awssdk.services.s3.model.Owner;
import software.amazon.awssdk.services.s3.model.Part;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListPartsResponse extends S3Response implements ToCopyableBuilder<ListPartsResponse.Builder, ListPartsResponse>
{
    protected ListPartsResponse() {}
    public ListPartsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final Initiator initiator(){ return null; }
    public final Instant abortDate(){ return null; }
    public final Integer maxParts(){ return null; }
    public final Integer nextPartNumberMarker(){ return null; }
    public final Integer partNumberMarker(){ return null; }
    public final List<Part> parts(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Owner owner(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final StorageClass storageClass(){ return null; }
    public final String abortRuleId(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String key(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final String uploadId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasParts(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListPartsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListPartsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListPartsResponse.Builder, ListPartsResponse>, S3Response.Builder, SdkPojo
    {
        ListPartsResponse.Builder abortDate(Instant p0);
        ListPartsResponse.Builder abortRuleId(String p0);
        ListPartsResponse.Builder bucket(String p0);
        ListPartsResponse.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        ListPartsResponse.Builder checksumAlgorithm(String p0);
        ListPartsResponse.Builder initiator(Initiator p0);
        ListPartsResponse.Builder isTruncated(Boolean p0);
        ListPartsResponse.Builder key(String p0);
        ListPartsResponse.Builder maxParts(Integer p0);
        ListPartsResponse.Builder nextPartNumberMarker(Integer p0);
        ListPartsResponse.Builder owner(Owner p0);
        ListPartsResponse.Builder partNumberMarker(Integer p0);
        ListPartsResponse.Builder parts(Collection<Part> p0);
        ListPartsResponse.Builder parts(Part... p0);
        ListPartsResponse.Builder parts(java.util.function.Consumer<Part.Builder>... p0);
        ListPartsResponse.Builder requestCharged(RequestCharged p0);
        ListPartsResponse.Builder requestCharged(String p0);
        ListPartsResponse.Builder storageClass(StorageClass p0);
        ListPartsResponse.Builder storageClass(String p0);
        ListPartsResponse.Builder uploadId(String p0);
        default ListPartsResponse.Builder initiator(java.util.function.Consumer<Initiator.Builder> p0){ return null; }
        default ListPartsResponse.Builder owner(java.util.function.Consumer<Owner.Builder> p0){ return null; }
    }
}
