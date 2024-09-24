// Generated automatically from software.amazon.awssdk.services.s3.model.MetricsFilter for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.MetricsAndOperator;
import software.amazon.awssdk.services.s3.model.Tag;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class MetricsFilter implements SdkPojo, Serializable, ToCopyableBuilder<MetricsFilter.Builder, MetricsFilter>
{
    protected MetricsFilter() {}
    public MetricsFilter.Builder toBuilder(){ return null; }
    public MetricsFilter.Type type(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final MetricsAndOperator and(){ return null; }
    public final String accessPointArn(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final Tag tag(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static MetricsFilter fromAccessPointArn(String p0){ return null; }
    public static MetricsFilter fromAnd(MetricsAndOperator p0){ return null; }
    public static MetricsFilter fromAnd(java.util.function.Consumer<MetricsAndOperator.Builder> p0){ return null; }
    public static MetricsFilter fromPrefix(String p0){ return null; }
    public static MetricsFilter fromTag(Tag p0){ return null; }
    public static MetricsFilter fromTag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    public static MetricsFilter.Builder builder(){ return null; }
    public static java.lang.Class<? extends MetricsFilter.Builder> serializableBuilderClass(){ return null; }
    static public enum Type
    {
        ACCESS_POINT_ARN, AND, PREFIX, TAG, UNKNOWN_TO_SDK_VERSION;
        private Type() {}
    }
    static public interface Builder extends CopyableBuilder<MetricsFilter.Builder, MetricsFilter>, SdkPojo
    {
        MetricsFilter.Builder accessPointArn(String p0);
        MetricsFilter.Builder and(MetricsAndOperator p0);
        MetricsFilter.Builder prefix(String p0);
        MetricsFilter.Builder tag(Tag p0);
        default MetricsFilter.Builder and(java.util.function.Consumer<MetricsAndOperator.Builder> p0){ return null; }
        default MetricsFilter.Builder tag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    }
}
