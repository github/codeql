// Generated automatically from software.amazon.awssdk.services.s3.model.ObjectLockConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectLockEnabled;
import software.amazon.awssdk.services.s3.model.ObjectLockRule;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ObjectLockConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<ObjectLockConfiguration.Builder, ObjectLockConfiguration>
{
    protected ObjectLockConfiguration() {}
    public ObjectLockConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockEnabled objectLockEnabled(){ return null; }
    public final ObjectLockRule rule(){ return null; }
    public final String objectLockEnabledAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ObjectLockConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends ObjectLockConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ObjectLockConfiguration.Builder, ObjectLockConfiguration>, SdkPojo
    {
        ObjectLockConfiguration.Builder objectLockEnabled(ObjectLockEnabled p0);
        ObjectLockConfiguration.Builder objectLockEnabled(String p0);
        ObjectLockConfiguration.Builder rule(ObjectLockRule p0);
        default ObjectLockConfiguration.Builder rule(java.util.function.Consumer<ObjectLockRule.Builder> p0){ return null; }
    }
}
