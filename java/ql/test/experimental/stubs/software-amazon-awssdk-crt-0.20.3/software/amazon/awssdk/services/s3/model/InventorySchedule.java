// Generated automatically from software.amazon.awssdk.services.s3.model.InventorySchedule for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.InventoryFrequency;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class InventorySchedule implements SdkPojo, Serializable, ToCopyableBuilder<InventorySchedule.Builder, InventorySchedule>
{
    protected InventorySchedule() {}
    public InventorySchedule.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final InventoryFrequency frequency(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String frequencyAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static InventorySchedule.Builder builder(){ return null; }
    public static java.lang.Class<? extends InventorySchedule.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<InventorySchedule.Builder, InventorySchedule>, SdkPojo
    {
        InventorySchedule.Builder frequency(InventoryFrequency p0);
        InventorySchedule.Builder frequency(String p0);
    }
}
