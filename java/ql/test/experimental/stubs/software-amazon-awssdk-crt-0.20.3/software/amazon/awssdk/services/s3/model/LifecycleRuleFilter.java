// Generated automatically from software.amazon.awssdk.services.s3.model.LifecycleRuleFilter for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.LifecycleRuleAndOperator;
import software.amazon.awssdk.services.s3.model.Tag;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class LifecycleRuleFilter implements SdkPojo, Serializable, ToCopyableBuilder<LifecycleRuleFilter.Builder, LifecycleRuleFilter>
{
    protected LifecycleRuleFilter() {}
    public LifecycleRuleFilter.Builder toBuilder(){ return null; }
    public LifecycleRuleFilter.Type type(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final LifecycleRuleAndOperator and(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Long objectSizeGreaterThan(){ return null; }
    public final Long objectSizeLessThan(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final Tag tag(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static LifecycleRuleFilter fromAnd(LifecycleRuleAndOperator p0){ return null; }
    public static LifecycleRuleFilter fromAnd(java.util.function.Consumer<LifecycleRuleAndOperator.Builder> p0){ return null; }
    public static LifecycleRuleFilter fromObjectSizeGreaterThan(Long p0){ return null; }
    public static LifecycleRuleFilter fromObjectSizeLessThan(Long p0){ return null; }
    public static LifecycleRuleFilter fromPrefix(String p0){ return null; }
    public static LifecycleRuleFilter fromTag(Tag p0){ return null; }
    public static LifecycleRuleFilter fromTag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    public static LifecycleRuleFilter.Builder builder(){ return null; }
    public static java.lang.Class<? extends LifecycleRuleFilter.Builder> serializableBuilderClass(){ return null; }
    static public enum Type
    {
        AND, OBJECT_SIZE_GREATER_THAN, OBJECT_SIZE_LESS_THAN, PREFIX, TAG, UNKNOWN_TO_SDK_VERSION;
        private Type() {}
    }
    static public interface Builder extends CopyableBuilder<LifecycleRuleFilter.Builder, LifecycleRuleFilter>, SdkPojo
    {
        LifecycleRuleFilter.Builder and(LifecycleRuleAndOperator p0);
        LifecycleRuleFilter.Builder objectSizeGreaterThan(Long p0);
        LifecycleRuleFilter.Builder objectSizeLessThan(Long p0);
        LifecycleRuleFilter.Builder prefix(String p0);
        LifecycleRuleFilter.Builder tag(Tag p0);
        default LifecycleRuleFilter.Builder and(java.util.function.Consumer<LifecycleRuleAndOperator.Builder> p0){ return null; }
        default LifecycleRuleFilter.Builder tag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    }
}
