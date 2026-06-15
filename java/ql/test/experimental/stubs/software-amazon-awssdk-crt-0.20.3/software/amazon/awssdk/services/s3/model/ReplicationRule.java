// Generated automatically from software.amazon.awssdk.services.s3.model.ReplicationRule for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.DeleteMarkerReplication;
import software.amazon.awssdk.services.s3.model.Destination;
import software.amazon.awssdk.services.s3.model.ExistingObjectReplication;
import software.amazon.awssdk.services.s3.model.ReplicationRuleFilter;
import software.amazon.awssdk.services.s3.model.ReplicationRuleStatus;
import software.amazon.awssdk.services.s3.model.SourceSelectionCriteria;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ReplicationRule implements SdkPojo, Serializable, ToCopyableBuilder<ReplicationRule.Builder, ReplicationRule>
{
    protected ReplicationRule() {}
    public ReplicationRule.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final DeleteMarkerReplication deleteMarkerReplication(){ return null; }
    public final Destination destination(){ return null; }
    public final ExistingObjectReplication existingObjectReplication(){ return null; }
    public final Integer priority(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ReplicationRuleFilter filter(){ return null; }
    public final ReplicationRuleStatus status(){ return null; }
    public final SourceSelectionCriteria sourceSelectionCriteria(){ return null; }
    public final String id(){ return null; }
    public final String prefix(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ReplicationRule.Builder builder(){ return null; }
    public static java.lang.Class<? extends ReplicationRule.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ReplicationRule.Builder, ReplicationRule>, SdkPojo
    {
        ReplicationRule.Builder deleteMarkerReplication(DeleteMarkerReplication p0);
        ReplicationRule.Builder destination(Destination p0);
        ReplicationRule.Builder existingObjectReplication(ExistingObjectReplication p0);
        ReplicationRule.Builder filter(ReplicationRuleFilter p0);
        ReplicationRule.Builder id(String p0);
        ReplicationRule.Builder prefix(String p0);
        ReplicationRule.Builder priority(Integer p0);
        ReplicationRule.Builder sourceSelectionCriteria(SourceSelectionCriteria p0);
        ReplicationRule.Builder status(ReplicationRuleStatus p0);
        ReplicationRule.Builder status(String p0);
        default ReplicationRule.Builder deleteMarkerReplication(java.util.function.Consumer<DeleteMarkerReplication.Builder> p0){ return null; }
        default ReplicationRule.Builder destination(java.util.function.Consumer<Destination.Builder> p0){ return null; }
        default ReplicationRule.Builder existingObjectReplication(java.util.function.Consumer<ExistingObjectReplication.Builder> p0){ return null; }
        default ReplicationRule.Builder filter(java.util.function.Consumer<ReplicationRuleFilter.Builder> p0){ return null; }
        default ReplicationRule.Builder sourceSelectionCriteria(java.util.function.Consumer<SourceSelectionCriteria.Builder> p0){ return null; }
    }
}
