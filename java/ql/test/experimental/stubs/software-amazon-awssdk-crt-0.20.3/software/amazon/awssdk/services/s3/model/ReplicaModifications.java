// Generated automatically from software.amazon.awssdk.services.s3.model.ReplicaModifications for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ReplicaModificationsStatus;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ReplicaModifications implements SdkPojo, Serializable, ToCopyableBuilder<ReplicaModifications.Builder, ReplicaModifications>
{
    protected ReplicaModifications() {}
    public ReplicaModifications.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ReplicaModificationsStatus status(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ReplicaModifications.Builder builder(){ return null; }
    public static java.lang.Class<? extends ReplicaModifications.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ReplicaModifications.Builder, ReplicaModifications>, SdkPojo
    {
        ReplicaModifications.Builder status(ReplicaModificationsStatus p0);
        ReplicaModifications.Builder status(String p0);
    }
}
