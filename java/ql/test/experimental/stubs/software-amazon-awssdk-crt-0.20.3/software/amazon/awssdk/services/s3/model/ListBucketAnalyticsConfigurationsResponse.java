// Generated automatically from software.amazon.awssdk.services.s3.model.ListBucketAnalyticsConfigurationsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AnalyticsConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListBucketAnalyticsConfigurationsResponse extends S3Response implements ToCopyableBuilder<ListBucketAnalyticsConfigurationsResponse.Builder, ListBucketAnalyticsConfigurationsResponse>
{
    protected ListBucketAnalyticsConfigurationsResponse() {}
    public ListBucketAnalyticsConfigurationsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final List<AnalyticsConfiguration> analyticsConfigurationList(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String continuationToken(){ return null; }
    public final String nextContinuationToken(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasAnalyticsConfigurationList(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListBucketAnalyticsConfigurationsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListBucketAnalyticsConfigurationsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListBucketAnalyticsConfigurationsResponse.Builder, ListBucketAnalyticsConfigurationsResponse>, S3Response.Builder, SdkPojo
    {
        ListBucketAnalyticsConfigurationsResponse.Builder analyticsConfigurationList(AnalyticsConfiguration... p0);
        ListBucketAnalyticsConfigurationsResponse.Builder analyticsConfigurationList(Collection<AnalyticsConfiguration> p0);
        ListBucketAnalyticsConfigurationsResponse.Builder analyticsConfigurationList(java.util.function.Consumer<AnalyticsConfiguration.Builder>... p0);
        ListBucketAnalyticsConfigurationsResponse.Builder continuationToken(String p0);
        ListBucketAnalyticsConfigurationsResponse.Builder isTruncated(Boolean p0);
        ListBucketAnalyticsConfigurationsResponse.Builder nextContinuationToken(String p0);
    }
}
