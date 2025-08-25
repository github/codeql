// Generated automatically from software.amazon.awssdk.services.s3.model.MultipartUpload for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.Initiator;
import software.amazon.awssdk.services.s3.model.Owner;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class MultipartUpload implements SdkPojo, Serializable, ToCopyableBuilder<MultipartUpload.Builder, MultipartUpload>
{
    protected MultipartUpload() {}
    public MultipartUpload.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final Initiator initiator(){ return null; }
    public final Instant initiated(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Owner owner(){ return null; }
    public final StorageClass storageClass(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String key(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final String uploadId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static MultipartUpload.Builder builder(){ return null; }
    public static java.lang.Class<? extends MultipartUpload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<MultipartUpload.Builder, MultipartUpload>, SdkPojo
    {
        MultipartUpload.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        MultipartUpload.Builder checksumAlgorithm(String p0);
        MultipartUpload.Builder initiated(Instant p0);
        MultipartUpload.Builder initiator(Initiator p0);
        MultipartUpload.Builder key(String p0);
        MultipartUpload.Builder owner(Owner p0);
        MultipartUpload.Builder storageClass(StorageClass p0);
        MultipartUpload.Builder storageClass(String p0);
        MultipartUpload.Builder uploadId(String p0);
        default MultipartUpload.Builder initiator(java.util.function.Consumer<Initiator.Builder> p0){ return null; }
        default MultipartUpload.Builder owner(java.util.function.Consumer<Owner.Builder> p0){ return null; }
    }
}
