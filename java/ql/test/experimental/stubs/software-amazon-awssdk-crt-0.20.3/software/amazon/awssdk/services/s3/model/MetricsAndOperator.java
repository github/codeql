// Generated automatically from software.amazon.awssdk.services.s3.model.MetricsAndOperator for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Tag;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class MetricsAndOperator implements SdkPojo, Serializable, ToCopyableBuilder<MetricsAndOperator.Builder, MetricsAndOperator>
{
    protected MetricsAndOperator() {}
    public MetricsAndOperator.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<Tag> tags(){ return null; }
    public final String accessPointArn(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasTags(){ return false; }
    public final int hashCode(){ return 0; }
    public static MetricsAndOperator.Builder builder(){ return null; }
    public static java.lang.Class<? extends MetricsAndOperator.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<MetricsAndOperator.Builder, MetricsAndOperator>, SdkPojo
    {
        MetricsAndOperator.Builder accessPointArn(String p0);
        MetricsAndOperator.Builder prefix(String p0);
        MetricsAndOperator.Builder tags(Collection<Tag> p0);
        MetricsAndOperator.Builder tags(Tag... p0);
        MetricsAndOperator.Builder tags(java.util.function.Consumer<Tag.Builder>... p0);
    }
}
