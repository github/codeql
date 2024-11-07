// Generated automatically from software.amazon.awssdk.services.s3.model.DeleteMarkerReplication for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.DeleteMarkerReplicationStatus;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DeleteMarkerReplication implements SdkPojo, Serializable, ToCopyableBuilder<DeleteMarkerReplication.Builder, DeleteMarkerReplication>
{
    protected DeleteMarkerReplication() {}
    public DeleteMarkerReplication.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final DeleteMarkerReplicationStatus status(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static DeleteMarkerReplication.Builder builder(){ return null; }
    public static java.lang.Class<? extends DeleteMarkerReplication.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DeleteMarkerReplication.Builder, DeleteMarkerReplication>, SdkPojo
    {
        DeleteMarkerReplication.Builder status(DeleteMarkerReplicationStatus p0);
        DeleteMarkerReplication.Builder status(String p0);
    }
}
