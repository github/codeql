// Generated automatically from software.amazon.awssdk.services.s3.model.ReplicationRuleFilter for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ReplicationRuleAndOperator;
import software.amazon.awssdk.services.s3.model.Tag;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ReplicationRuleFilter implements SdkPojo, Serializable, ToCopyableBuilder<ReplicationRuleFilter.Builder, ReplicationRuleFilter>
{
    protected ReplicationRuleFilter() {}
    public ReplicationRuleFilter.Builder toBuilder(){ return null; }
    public ReplicationRuleFilter.Type type(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ReplicationRuleAndOperator and(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final Tag tag(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ReplicationRuleFilter fromAnd(ReplicationRuleAndOperator p0){ return null; }
    public static ReplicationRuleFilter fromAnd(java.util.function.Consumer<ReplicationRuleAndOperator.Builder> p0){ return null; }
    public static ReplicationRuleFilter fromPrefix(String p0){ return null; }
    public static ReplicationRuleFilter fromTag(Tag p0){ return null; }
    public static ReplicationRuleFilter fromTag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    public static ReplicationRuleFilter.Builder builder(){ return null; }
    public static java.lang.Class<? extends ReplicationRuleFilter.Builder> serializableBuilderClass(){ return null; }
    static public enum Type
    {
        AND, PREFIX, TAG, UNKNOWN_TO_SDK_VERSION;
        private Type() {}
    }
    static public interface Builder extends CopyableBuilder<ReplicationRuleFilter.Builder, ReplicationRuleFilter>, SdkPojo
    {
        ReplicationRuleFilter.Builder and(ReplicationRuleAndOperator p0);
        ReplicationRuleFilter.Builder prefix(String p0);
        ReplicationRuleFilter.Builder tag(Tag p0);
        default ReplicationRuleFilter.Builder and(java.util.function.Consumer<ReplicationRuleAndOperator.Builder> p0){ return null; }
        default ReplicationRuleFilter.Builder tag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    }
}
