// Generated automatically from software.amazon.awssdk.services.s3.model.ExistingObjectReplication for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ExistingObjectReplicationStatus;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ExistingObjectReplication implements SdkPojo, Serializable, ToCopyableBuilder<ExistingObjectReplication.Builder, ExistingObjectReplication>
{
    protected ExistingObjectReplication() {}
    public ExistingObjectReplication.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ExistingObjectReplicationStatus status(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ExistingObjectReplication.Builder builder(){ return null; }
    public static java.lang.Class<? extends ExistingObjectReplication.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ExistingObjectReplication.Builder, ExistingObjectReplication>, SdkPojo
    {
        ExistingObjectReplication.Builder status(ExistingObjectReplicationStatus p0);
        ExistingObjectReplication.Builder status(String p0);
    }
}
