// Generated automatically from software.amazon.awssdk.services.s3.model.MetricsConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.MetricsFilter;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class MetricsConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<MetricsConfiguration.Builder, MetricsConfiguration>
{
    protected MetricsConfiguration() {}
    public MetricsConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final MetricsFilter filter(){ return null; }
    public final String id(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static MetricsConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends MetricsConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<MetricsConfiguration.Builder, MetricsConfiguration>, SdkPojo
    {
        MetricsConfiguration.Builder filter(MetricsFilter p0);
        MetricsConfiguration.Builder id(String p0);
        default MetricsConfiguration.Builder filter(java.util.function.Consumer<MetricsFilter.Builder> p0){ return null; }
    }
}
