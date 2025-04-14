// Generated automatically from software.amazon.awssdk.services.s3.model.Destination for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AccessControlTranslation;
import software.amazon.awssdk.services.s3.model.EncryptionConfiguration;
import software.amazon.awssdk.services.s3.model.Metrics;
import software.amazon.awssdk.services.s3.model.ReplicationTime;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Destination implements SdkPojo, Serializable, ToCopyableBuilder<Destination.Builder, Destination>
{
    protected Destination() {}
    public Destination.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AccessControlTranslation accessControlTranslation(){ return null; }
    public final EncryptionConfiguration encryptionConfiguration(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Metrics metrics(){ return null; }
    public final ReplicationTime replicationTime(){ return null; }
    public final StorageClass storageClass(){ return null; }
    public final String account(){ return null; }
    public final String bucket(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Destination.Builder builder(){ return null; }
    public static java.lang.Class<? extends Destination.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Destination.Builder, Destination>, SdkPojo
    {
        Destination.Builder accessControlTranslation(AccessControlTranslation p0);
        Destination.Builder account(String p0);
        Destination.Builder bucket(String p0);
        Destination.Builder encryptionConfiguration(EncryptionConfiguration p0);
        Destination.Builder metrics(Metrics p0);
        Destination.Builder replicationTime(ReplicationTime p0);
        Destination.Builder storageClass(StorageClass p0);
        Destination.Builder storageClass(String p0);
        default Destination.Builder accessControlTranslation(java.util.function.Consumer<AccessControlTranslation.Builder> p0){ return null; }
        default Destination.Builder encryptionConfiguration(java.util.function.Consumer<EncryptionConfiguration.Builder> p0){ return null; }
        default Destination.Builder metrics(java.util.function.Consumer<Metrics.Builder> p0){ return null; }
        default Destination.Builder replicationTime(java.util.function.Consumer<ReplicationTime.Builder> p0){ return null; }
    }
}
