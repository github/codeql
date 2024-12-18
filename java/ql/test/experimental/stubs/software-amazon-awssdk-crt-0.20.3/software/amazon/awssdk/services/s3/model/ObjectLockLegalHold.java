// Generated automatically from software.amazon.awssdk.services.s3.model.ObjectLockLegalHold for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectLockLegalHoldStatus;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ObjectLockLegalHold implements SdkPojo, Serializable, ToCopyableBuilder<ObjectLockLegalHold.Builder, ObjectLockLegalHold>
{
    protected ObjectLockLegalHold() {}
    public ObjectLockLegalHold.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockLegalHoldStatus status(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ObjectLockLegalHold.Builder builder(){ return null; }
    public static java.lang.Class<? extends ObjectLockLegalHold.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ObjectLockLegalHold.Builder, ObjectLockLegalHold>, SdkPojo
    {
        ObjectLockLegalHold.Builder status(ObjectLockLegalHoldStatus p0);
        ObjectLockLegalHold.Builder status(String p0);
    }
}
