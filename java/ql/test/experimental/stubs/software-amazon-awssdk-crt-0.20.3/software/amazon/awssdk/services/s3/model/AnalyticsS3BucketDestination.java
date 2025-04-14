// Generated automatically from software.amazon.awssdk.services.s3.model.AnalyticsS3BucketDestination for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AnalyticsS3ExportFileFormat;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class AnalyticsS3BucketDestination implements SdkPojo, Serializable, ToCopyableBuilder<AnalyticsS3BucketDestination.Builder, AnalyticsS3BucketDestination>
{
    protected AnalyticsS3BucketDestination() {}
    public AnalyticsS3BucketDestination.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AnalyticsS3ExportFileFormat format(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String bucketAccountId(){ return null; }
    public final String formatAsString(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static AnalyticsS3BucketDestination.Builder builder(){ return null; }
    public static java.lang.Class<? extends AnalyticsS3BucketDestination.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<AnalyticsS3BucketDestination.Builder, AnalyticsS3BucketDestination>, SdkPojo
    {
        AnalyticsS3BucketDestination.Builder bucket(String p0);
        AnalyticsS3BucketDestination.Builder bucketAccountId(String p0);
        AnalyticsS3BucketDestination.Builder format(AnalyticsS3ExportFileFormat p0);
        AnalyticsS3BucketDestination.Builder format(String p0);
        AnalyticsS3BucketDestination.Builder prefix(String p0);
    }
}
