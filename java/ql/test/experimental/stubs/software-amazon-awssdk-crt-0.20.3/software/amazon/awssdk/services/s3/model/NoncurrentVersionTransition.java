// Generated automatically from software.amazon.awssdk.services.s3.model.NoncurrentVersionTransition for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.TransitionStorageClass;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class NoncurrentVersionTransition implements SdkPojo, Serializable, ToCopyableBuilder<NoncurrentVersionTransition.Builder, NoncurrentVersionTransition>
{
    protected NoncurrentVersionTransition() {}
    public NoncurrentVersionTransition.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Integer newerNoncurrentVersions(){ return null; }
    public final Integer noncurrentDays(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final TransitionStorageClass storageClass(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static NoncurrentVersionTransition.Builder builder(){ return null; }
    public static java.lang.Class<? extends NoncurrentVersionTransition.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<NoncurrentVersionTransition.Builder, NoncurrentVersionTransition>, SdkPojo
    {
        NoncurrentVersionTransition.Builder newerNoncurrentVersions(Integer p0);
        NoncurrentVersionTransition.Builder noncurrentDays(Integer p0);
        NoncurrentVersionTransition.Builder storageClass(String p0);
        NoncurrentVersionTransition.Builder storageClass(TransitionStorageClass p0);
    }
}
