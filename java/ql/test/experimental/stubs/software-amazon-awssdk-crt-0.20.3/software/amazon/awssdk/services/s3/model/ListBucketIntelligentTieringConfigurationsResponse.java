// Generated automatically from software.amazon.awssdk.services.s3.model.ListBucketIntelligentTieringConfigurationsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.IntelligentTieringConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListBucketIntelligentTieringConfigurationsResponse extends S3Response implements ToCopyableBuilder<ListBucketIntelligentTieringConfigurationsResponse.Builder, ListBucketIntelligentTieringConfigurationsResponse>
{
    protected ListBucketIntelligentTieringConfigurationsResponse() {}
    public ListBucketIntelligentTieringConfigurationsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final List<IntelligentTieringConfiguration> intelligentTieringConfigurationList(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String continuationToken(){ return null; }
    public final String nextContinuationToken(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasIntelligentTieringConfigurationList(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListBucketIntelligentTieringConfigurationsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListBucketIntelligentTieringConfigurationsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListBucketIntelligentTieringConfigurationsResponse.Builder, ListBucketIntelligentTieringConfigurationsResponse>, S3Response.Builder, SdkPojo
    {
        ListBucketIntelligentTieringConfigurationsResponse.Builder continuationToken(String p0);
        ListBucketIntelligentTieringConfigurationsResponse.Builder intelligentTieringConfigurationList(Collection<IntelligentTieringConfiguration> p0);
        ListBucketIntelligentTieringConfigurationsResponse.Builder intelligentTieringConfigurationList(IntelligentTieringConfiguration... p0);
        ListBucketIntelligentTieringConfigurationsResponse.Builder intelligentTieringConfigurationList(java.util.function.Consumer<IntelligentTieringConfiguration.Builder>... p0);
        ListBucketIntelligentTieringConfigurationsResponse.Builder isTruncated(Boolean p0);
        ListBucketIntelligentTieringConfigurationsResponse.Builder nextContinuationToken(String p0);
    }
}
