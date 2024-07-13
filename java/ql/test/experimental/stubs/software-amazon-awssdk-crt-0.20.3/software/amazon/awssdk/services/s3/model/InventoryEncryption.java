// Generated automatically from software.amazon.awssdk.services.s3.model.InventoryEncryption for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.SSEKMS;
import software.amazon.awssdk.services.s3.model.SSES3;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class InventoryEncryption implements SdkPojo, Serializable, ToCopyableBuilder<InventoryEncryption.Builder, InventoryEncryption>
{
    protected InventoryEncryption() {}
    public InventoryEncryption.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final SSEKMS ssekms(){ return null; }
    public final SSES3 sses3(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static InventoryEncryption.Builder builder(){ return null; }
    public static java.lang.Class<? extends InventoryEncryption.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<InventoryEncryption.Builder, InventoryEncryption>, SdkPojo
    {
        InventoryEncryption.Builder ssekms(SSEKMS p0);
        InventoryEncryption.Builder sses3(SSES3 p0);
        default InventoryEncryption.Builder ssekms(java.util.function.Consumer<SSEKMS.Builder> p0){ return null; }
        default InventoryEncryption.Builder sses3(java.util.function.Consumer<SSES3.Builder> p0){ return null; }
    }
}
