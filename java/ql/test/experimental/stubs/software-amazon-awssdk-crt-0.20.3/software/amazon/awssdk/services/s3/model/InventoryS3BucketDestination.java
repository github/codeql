// Generated automatically from software.amazon.awssdk.services.s3.model.InventoryS3BucketDestination for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.InventoryEncryption;
import software.amazon.awssdk.services.s3.model.InventoryFormat;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class InventoryS3BucketDestination implements SdkPojo, Serializable, ToCopyableBuilder<InventoryS3BucketDestination.Builder, InventoryS3BucketDestination>
{
    protected InventoryS3BucketDestination() {}
    public InventoryS3BucketDestination.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final InventoryEncryption encryption(){ return null; }
    public final InventoryFormat format(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String accountId(){ return null; }
    public final String bucket(){ return null; }
    public final String formatAsString(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static InventoryS3BucketDestination.Builder builder(){ return null; }
    public static java.lang.Class<? extends InventoryS3BucketDestination.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<InventoryS3BucketDestination.Builder, InventoryS3BucketDestination>, SdkPojo
    {
        InventoryS3BucketDestination.Builder accountId(String p0);
        InventoryS3BucketDestination.Builder bucket(String p0);
        InventoryS3BucketDestination.Builder encryption(InventoryEncryption p0);
        InventoryS3BucketDestination.Builder format(InventoryFormat p0);
        InventoryS3BucketDestination.Builder format(String p0);
        InventoryS3BucketDestination.Builder prefix(String p0);
        default InventoryS3BucketDestination.Builder encryption(java.util.function.Consumer<InventoryEncryption.Builder> p0){ return null; }
    }
}
