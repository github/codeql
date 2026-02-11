// Generated automatically from software.amazon.awssdk.services.s3.model.AccelerateConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketAccelerateStatus;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class AccelerateConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<AccelerateConfiguration.Builder, AccelerateConfiguration>
{
    protected AccelerateConfiguration() {}
    public AccelerateConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final BucketAccelerateStatus status(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static AccelerateConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends AccelerateConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<AccelerateConfiguration.Builder, AccelerateConfiguration>, SdkPojo
    {
        AccelerateConfiguration.Builder status(BucketAccelerateStatus p0);
        AccelerateConfiguration.Builder status(String p0);
    }
}
