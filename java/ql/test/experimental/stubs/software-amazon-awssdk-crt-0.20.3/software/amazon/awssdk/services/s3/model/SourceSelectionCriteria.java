// Generated automatically from software.amazon.awssdk.services.s3.model.SourceSelectionCriteria for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ReplicaModifications;
import software.amazon.awssdk.services.s3.model.SseKmsEncryptedObjects;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class SourceSelectionCriteria implements SdkPojo, Serializable, ToCopyableBuilder<SourceSelectionCriteria.Builder, SourceSelectionCriteria>
{
    protected SourceSelectionCriteria() {}
    public SourceSelectionCriteria.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ReplicaModifications replicaModifications(){ return null; }
    public final SseKmsEncryptedObjects sseKmsEncryptedObjects(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static SourceSelectionCriteria.Builder builder(){ return null; }
    public static java.lang.Class<? extends SourceSelectionCriteria.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<SourceSelectionCriteria.Builder, SourceSelectionCriteria>, SdkPojo
    {
        SourceSelectionCriteria.Builder replicaModifications(ReplicaModifications p0);
        SourceSelectionCriteria.Builder sseKmsEncryptedObjects(SseKmsEncryptedObjects p0);
        default SourceSelectionCriteria.Builder replicaModifications(java.util.function.Consumer<ReplicaModifications.Builder> p0){ return null; }
        default SourceSelectionCriteria.Builder sseKmsEncryptedObjects(java.util.function.Consumer<SseKmsEncryptedObjects.Builder> p0){ return null; }
    }
}
