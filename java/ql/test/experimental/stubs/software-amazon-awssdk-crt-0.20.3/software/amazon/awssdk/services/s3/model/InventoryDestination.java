// Generated automatically from software.amazon.awssdk.services.s3.model.InventoryDestination for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.InventoryS3BucketDestination;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class InventoryDestination implements SdkPojo, Serializable, ToCopyableBuilder<InventoryDestination.Builder, InventoryDestination>
{
    protected InventoryDestination() {}
    public InventoryDestination.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final InventoryS3BucketDestination s3BucketDestination(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static InventoryDestination.Builder builder(){ return null; }
    public static java.lang.Class<? extends InventoryDestination.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<InventoryDestination.Builder, InventoryDestination>, SdkPojo
    {
        InventoryDestination.Builder s3BucketDestination(InventoryS3BucketDestination p0);
        default InventoryDestination.Builder s3BucketDestination(java.util.function.Consumer<InventoryS3BucketDestination.Builder> p0){ return null; }
    }
}
