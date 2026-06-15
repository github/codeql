// Generated automatically from software.amazon.awssdk.services.s3.model.AnalyticsExportDestination for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AnalyticsS3BucketDestination;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class AnalyticsExportDestination implements SdkPojo, Serializable, ToCopyableBuilder<AnalyticsExportDestination.Builder, AnalyticsExportDestination>
{
    protected AnalyticsExportDestination() {}
    public AnalyticsExportDestination.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AnalyticsS3BucketDestination s3BucketDestination(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static AnalyticsExportDestination.Builder builder(){ return null; }
    public static java.lang.Class<? extends AnalyticsExportDestination.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<AnalyticsExportDestination.Builder, AnalyticsExportDestination>, SdkPojo
    {
        AnalyticsExportDestination.Builder s3BucketDestination(AnalyticsS3BucketDestination p0);
        default AnalyticsExportDestination.Builder s3BucketDestination(java.util.function.Consumer<AnalyticsS3BucketDestination.Builder> p0){ return null; }
    }
}
