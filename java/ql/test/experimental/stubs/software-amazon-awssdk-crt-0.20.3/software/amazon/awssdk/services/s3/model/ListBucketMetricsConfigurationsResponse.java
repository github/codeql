// Generated automatically from software.amazon.awssdk.services.s3.model.ListBucketMetricsConfigurationsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.MetricsConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListBucketMetricsConfigurationsResponse extends S3Response implements ToCopyableBuilder<ListBucketMetricsConfigurationsResponse.Builder, ListBucketMetricsConfigurationsResponse>
{
    protected ListBucketMetricsConfigurationsResponse() {}
    public ListBucketMetricsConfigurationsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final List<MetricsConfiguration> metricsConfigurationList(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String continuationToken(){ return null; }
    public final String nextContinuationToken(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasMetricsConfigurationList(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListBucketMetricsConfigurationsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListBucketMetricsConfigurationsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListBucketMetricsConfigurationsResponse.Builder, ListBucketMetricsConfigurationsResponse>, S3Response.Builder, SdkPojo
    {
        ListBucketMetricsConfigurationsResponse.Builder continuationToken(String p0);
        ListBucketMetricsConfigurationsResponse.Builder isTruncated(Boolean p0);
        ListBucketMetricsConfigurationsResponse.Builder metricsConfigurationList(Collection<MetricsConfiguration> p0);
        ListBucketMetricsConfigurationsResponse.Builder metricsConfigurationList(MetricsConfiguration... p0);
        ListBucketMetricsConfigurationsResponse.Builder metricsConfigurationList(java.util.function.Consumer<MetricsConfiguration.Builder>... p0);
        ListBucketMetricsConfigurationsResponse.Builder nextContinuationToken(String p0);
    }
}
