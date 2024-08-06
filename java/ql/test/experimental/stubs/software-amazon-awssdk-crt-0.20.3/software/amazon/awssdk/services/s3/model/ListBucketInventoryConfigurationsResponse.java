// Generated automatically from software.amazon.awssdk.services.s3.model.ListBucketInventoryConfigurationsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.InventoryConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListBucketInventoryConfigurationsResponse extends S3Response implements ToCopyableBuilder<ListBucketInventoryConfigurationsResponse.Builder, ListBucketInventoryConfigurationsResponse>
{
    protected ListBucketInventoryConfigurationsResponse() {}
    public ListBucketInventoryConfigurationsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final List<InventoryConfiguration> inventoryConfigurationList(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String continuationToken(){ return null; }
    public final String nextContinuationToken(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasInventoryConfigurationList(){ return false; }
    public final int hashCode(){ return 0; }
    public static ListBucketInventoryConfigurationsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListBucketInventoryConfigurationsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListBucketInventoryConfigurationsResponse.Builder, ListBucketInventoryConfigurationsResponse>, S3Response.Builder, SdkPojo
    {
        ListBucketInventoryConfigurationsResponse.Builder continuationToken(String p0);
        ListBucketInventoryConfigurationsResponse.Builder inventoryConfigurationList(Collection<InventoryConfiguration> p0);
        ListBucketInventoryConfigurationsResponse.Builder inventoryConfigurationList(InventoryConfiguration... p0);
        ListBucketInventoryConfigurationsResponse.Builder inventoryConfigurationList(java.util.function.Consumer<InventoryConfiguration.Builder>... p0);
        ListBucketInventoryConfigurationsResponse.Builder isTruncated(Boolean p0);
        ListBucketInventoryConfigurationsResponse.Builder nextContinuationToken(String p0);
    }
}
