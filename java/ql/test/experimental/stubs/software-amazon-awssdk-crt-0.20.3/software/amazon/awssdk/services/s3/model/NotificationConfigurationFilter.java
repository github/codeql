// Generated automatically from software.amazon.awssdk.services.s3.model.NotificationConfigurationFilter for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.S3KeyFilter;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class NotificationConfigurationFilter implements SdkPojo, Serializable, ToCopyableBuilder<NotificationConfigurationFilter.Builder, NotificationConfigurationFilter>
{
    protected NotificationConfigurationFilter() {}
    public NotificationConfigurationFilter.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final S3KeyFilter key(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static NotificationConfigurationFilter.Builder builder(){ return null; }
    public static java.lang.Class<? extends NotificationConfigurationFilter.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<NotificationConfigurationFilter.Builder, NotificationConfigurationFilter>, SdkPojo
    {
        NotificationConfigurationFilter.Builder key(S3KeyFilter p0);
        default NotificationConfigurationFilter.Builder key(java.util.function.Consumer<S3KeyFilter.Builder> p0){ return null; }
    }
}
