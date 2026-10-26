// Generated automatically from software.amazon.awssdk.services.s3.model.ObjectLockRetention for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectLockRetentionMode;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ObjectLockRetention implements SdkPojo, Serializable, ToCopyableBuilder<ObjectLockRetention.Builder, ObjectLockRetention>
{
    protected ObjectLockRetention() {}
    public ObjectLockRetention.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Instant retainUntilDate(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockRetentionMode mode(){ return null; }
    public final String modeAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ObjectLockRetention.Builder builder(){ return null; }
    public static java.lang.Class<? extends ObjectLockRetention.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ObjectLockRetention.Builder, ObjectLockRetention>, SdkPojo
    {
        ObjectLockRetention.Builder mode(ObjectLockRetentionMode p0);
        ObjectLockRetention.Builder mode(String p0);
        ObjectLockRetention.Builder retainUntilDate(Instant p0);
    }
}
