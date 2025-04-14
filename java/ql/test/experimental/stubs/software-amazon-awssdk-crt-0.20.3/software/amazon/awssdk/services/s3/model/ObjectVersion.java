// Generated automatically from software.amazon.awssdk.services.s3.model.ObjectVersion for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.ObjectVersionStorageClass;
import software.amazon.awssdk.services.s3.model.Owner;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ObjectVersion implements SdkPojo, Serializable, ToCopyableBuilder<ObjectVersion.Builder, ObjectVersion>
{
    protected ObjectVersion() {}
    public ObjectVersion.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isLatest(){ return null; }
    public final Instant lastModified(){ return null; }
    public final List<ChecksumAlgorithm> checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<String> checksumAlgorithmAsStrings(){ return null; }
    public final Long size(){ return null; }
    public final ObjectVersionStorageClass storageClass(){ return null; }
    public final Owner owner(){ return null; }
    public final String eTag(){ return null; }
    public final String key(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasChecksumAlgorithm(){ return false; }
    public final int hashCode(){ return 0; }
    public static ObjectVersion.Builder builder(){ return null; }
    public static java.lang.Class<? extends ObjectVersion.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ObjectVersion.Builder, ObjectVersion>, SdkPojo
    {
        ObjectVersion.Builder checksumAlgorithm(ChecksumAlgorithm... p0);
        ObjectVersion.Builder checksumAlgorithm(Collection<ChecksumAlgorithm> p0);
        ObjectVersion.Builder checksumAlgorithmWithStrings(Collection<String> p0);
        ObjectVersion.Builder checksumAlgorithmWithStrings(String... p0);
        ObjectVersion.Builder eTag(String p0);
        ObjectVersion.Builder isLatest(Boolean p0);
        ObjectVersion.Builder key(String p0);
        ObjectVersion.Builder lastModified(Instant p0);
        ObjectVersion.Builder owner(Owner p0);
        ObjectVersion.Builder size(Long p0);
        ObjectVersion.Builder storageClass(ObjectVersionStorageClass p0);
        ObjectVersion.Builder storageClass(String p0);
        ObjectVersion.Builder versionId(String p0);
        default ObjectVersion.Builder owner(java.util.function.Consumer<Owner.Builder> p0){ return null; }
    }
}
