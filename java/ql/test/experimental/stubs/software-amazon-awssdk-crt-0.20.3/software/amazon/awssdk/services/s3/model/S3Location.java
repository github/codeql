// Generated automatically from software.amazon.awssdk.services.s3.model.S3Location for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Encryption;
import software.amazon.awssdk.services.s3.model.Grant;
import software.amazon.awssdk.services.s3.model.MetadataEntry;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.services.s3.model.Tagging;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class S3Location implements SdkPojo, Serializable, ToCopyableBuilder<S3Location.Builder, S3Location>
{
    protected S3Location() {}
    public S3Location.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Encryption encryption(){ return null; }
    public final List<Grant> accessControlList(){ return null; }
    public final List<MetadataEntry> userMetadata(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectCannedACL cannedACL(){ return null; }
    public final StorageClass storageClass(){ return null; }
    public final String bucketName(){ return null; }
    public final String cannedACLAsString(){ return null; }
    public final String prefix(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final Tagging tagging(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasAccessControlList(){ return false; }
    public final boolean hasUserMetadata(){ return false; }
    public final int hashCode(){ return 0; }
    public static S3Location.Builder builder(){ return null; }
    public static java.lang.Class<? extends S3Location.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<S3Location.Builder, S3Location>, SdkPojo
    {
        S3Location.Builder accessControlList(Collection<Grant> p0);
        S3Location.Builder accessControlList(Grant... p0);
        S3Location.Builder accessControlList(java.util.function.Consumer<Grant.Builder>... p0);
        S3Location.Builder bucketName(String p0);
        S3Location.Builder cannedACL(ObjectCannedACL p0);
        S3Location.Builder cannedACL(String p0);
        S3Location.Builder encryption(Encryption p0);
        S3Location.Builder prefix(String p0);
        S3Location.Builder storageClass(StorageClass p0);
        S3Location.Builder storageClass(String p0);
        S3Location.Builder tagging(Tagging p0);
        S3Location.Builder userMetadata(Collection<MetadataEntry> p0);
        S3Location.Builder userMetadata(MetadataEntry... p0);
        S3Location.Builder userMetadata(java.util.function.Consumer<MetadataEntry.Builder>... p0);
        default S3Location.Builder encryption(java.util.function.Consumer<Encryption.Builder> p0){ return null; }
        default S3Location.Builder tagging(java.util.function.Consumer<Tagging.Builder> p0){ return null; }
    }
}
