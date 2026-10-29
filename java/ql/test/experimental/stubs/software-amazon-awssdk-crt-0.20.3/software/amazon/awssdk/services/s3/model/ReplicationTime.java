// Generated automatically from software.amazon.awssdk.services.s3.model.ReplicationTime for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ReplicationTimeStatus;
import software.amazon.awssdk.services.s3.model.ReplicationTimeValue;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ReplicationTime implements SdkPojo, Serializable, ToCopyableBuilder<ReplicationTime.Builder, ReplicationTime>
{
    protected ReplicationTime() {}
    public ReplicationTime.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ReplicationTimeStatus status(){ return null; }
    public final ReplicationTimeValue time(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ReplicationTime.Builder builder(){ return null; }
    public static java.lang.Class<? extends ReplicationTime.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ReplicationTime.Builder, ReplicationTime>, SdkPojo
    {
        ReplicationTime.Builder status(ReplicationTimeStatus p0);
        ReplicationTime.Builder status(String p0);
        ReplicationTime.Builder time(ReplicationTimeValue p0);
        default ReplicationTime.Builder time(java.util.function.Consumer<ReplicationTimeValue.Builder> p0){ return null; }
    }
}
