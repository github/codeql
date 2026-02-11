// Generated automatically from software.amazon.awssdk.services.s3.model.Metrics for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.MetricsStatus;
import software.amazon.awssdk.services.s3.model.ReplicationTimeValue;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Metrics implements SdkPojo, Serializable, ToCopyableBuilder<Metrics.Builder, Metrics>
{
    protected Metrics() {}
    public Metrics.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final MetricsStatus status(){ return null; }
    public final ReplicationTimeValue eventThreshold(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Metrics.Builder builder(){ return null; }
    public static java.lang.Class<? extends Metrics.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Metrics.Builder, Metrics>, SdkPojo
    {
        Metrics.Builder eventThreshold(ReplicationTimeValue p0);
        Metrics.Builder status(MetricsStatus p0);
        Metrics.Builder status(String p0);
        default Metrics.Builder eventThreshold(java.util.function.Consumer<ReplicationTimeValue.Builder> p0){ return null; }
    }
}
