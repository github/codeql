// Generated automatically from software.amazon.awssdk.services.s3.model.Stats for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Stats implements SdkPojo, Serializable, ToCopyableBuilder<Stats.Builder, Stats>
{
    protected Stats() {}
    public Stats.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Long bytesProcessed(){ return null; }
    public final Long bytesReturned(){ return null; }
    public final Long bytesScanned(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Stats.Builder builder(){ return null; }
    public static java.lang.Class<? extends Stats.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Stats.Builder, Stats>, SdkPojo
    {
        Stats.Builder bytesProcessed(Long p0);
        Stats.Builder bytesReturned(Long p0);
        Stats.Builder bytesScanned(Long p0);
    }

    public class BuilderImpl {
    }
}
