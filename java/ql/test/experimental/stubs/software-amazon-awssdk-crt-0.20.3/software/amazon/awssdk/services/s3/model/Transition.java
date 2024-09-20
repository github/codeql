// Generated automatically from software.amazon.awssdk.services.s3.model.Transition for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.TransitionStorageClass;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Transition implements SdkPojo, Serializable, ToCopyableBuilder<Transition.Builder, Transition>
{
    protected Transition() {}
    public Transition.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Instant date(){ return null; }
    public final Integer days(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final TransitionStorageClass storageClass(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Transition.Builder builder(){ return null; }
    public static java.lang.Class<? extends Transition.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Transition.Builder, Transition>, SdkPojo
    {
        Transition.Builder date(Instant p0);
        Transition.Builder days(Integer p0);
        Transition.Builder storageClass(String p0);
        Transition.Builder storageClass(TransitionStorageClass p0);
    }
}
