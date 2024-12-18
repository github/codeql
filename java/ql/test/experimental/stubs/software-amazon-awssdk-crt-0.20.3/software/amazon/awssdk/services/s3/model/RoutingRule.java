// Generated automatically from software.amazon.awssdk.services.s3.model.RoutingRule for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Condition;
import software.amazon.awssdk.services.s3.model.Redirect;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class RoutingRule implements SdkPojo, Serializable, ToCopyableBuilder<RoutingRule.Builder, RoutingRule>
{
    protected RoutingRule() {}
    public RoutingRule.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Condition condition(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Redirect redirect(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static RoutingRule.Builder builder(){ return null; }
    public static java.lang.Class<? extends RoutingRule.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<RoutingRule.Builder, RoutingRule>, SdkPojo
    {
        RoutingRule.Builder condition(Condition p0);
        RoutingRule.Builder redirect(Redirect p0);
        default RoutingRule.Builder condition(java.util.function.Consumer<Condition.Builder> p0){ return null; }
        default RoutingRule.Builder redirect(java.util.function.Consumer<Redirect.Builder> p0){ return null; }
    }
}
