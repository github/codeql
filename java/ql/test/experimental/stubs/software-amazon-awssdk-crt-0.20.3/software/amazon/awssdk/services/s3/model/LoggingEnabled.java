// Generated automatically from software.amazon.awssdk.services.s3.model.LoggingEnabled for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.TargetGrant;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class LoggingEnabled implements SdkPojo, Serializable, ToCopyableBuilder<LoggingEnabled.Builder, LoggingEnabled>
{
    protected LoggingEnabled() {}
    public LoggingEnabled.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<TargetGrant> targetGrants(){ return null; }
    public final String targetBucket(){ return null; }
    public final String targetPrefix(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasTargetGrants(){ return false; }
    public final int hashCode(){ return 0; }
    public static LoggingEnabled.Builder builder(){ return null; }
    public static java.lang.Class<? extends LoggingEnabled.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<LoggingEnabled.Builder, LoggingEnabled>, SdkPojo
    {
        LoggingEnabled.Builder targetBucket(String p0);
        LoggingEnabled.Builder targetGrants(Collection<TargetGrant> p0);
        LoggingEnabled.Builder targetGrants(TargetGrant... p0);
        LoggingEnabled.Builder targetGrants(java.util.function.Consumer<TargetGrant.Builder>... p0);
        LoggingEnabled.Builder targetPrefix(String p0);
    }
}
