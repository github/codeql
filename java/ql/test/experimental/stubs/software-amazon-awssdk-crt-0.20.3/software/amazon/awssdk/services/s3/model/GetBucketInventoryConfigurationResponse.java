// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketInventoryConfigurationResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.InventoryConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketInventoryConfigurationResponse extends S3Response implements ToCopyableBuilder<GetBucketInventoryConfigurationResponse.Builder, GetBucketInventoryConfigurationResponse>
{
    protected GetBucketInventoryConfigurationResponse() {}
    public GetBucketInventoryConfigurationResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final InventoryConfiguration inventoryConfiguration(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketInventoryConfigurationResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketInventoryConfigurationResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketInventoryConfigurationResponse.Builder, GetBucketInventoryConfigurationResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketInventoryConfigurationResponse.Builder inventoryConfiguration(InventoryConfiguration p0);
        default GetBucketInventoryConfigurationResponse.Builder inventoryConfiguration(java.util.function.Consumer<InventoryConfiguration.Builder> p0){ return null; }
    }
}
