// Generated automatically from software.amazon.awssdk.services.s3.model.InventoryConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.InventoryDestination;
import software.amazon.awssdk.services.s3.model.InventoryFilter;
import software.amazon.awssdk.services.s3.model.InventoryIncludedObjectVersions;
import software.amazon.awssdk.services.s3.model.InventoryOptionalField;
import software.amazon.awssdk.services.s3.model.InventorySchedule;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class InventoryConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<InventoryConfiguration.Builder, InventoryConfiguration>
{
    protected InventoryConfiguration() {}
    public InventoryConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isEnabled(){ return null; }
    public final InventoryDestination destination(){ return null; }
    public final InventoryFilter filter(){ return null; }
    public final InventoryIncludedObjectVersions includedObjectVersions(){ return null; }
    public final InventorySchedule schedule(){ return null; }
    public final List<InventoryOptionalField> optionalFields(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<String> optionalFieldsAsStrings(){ return null; }
    public final String id(){ return null; }
    public final String includedObjectVersionsAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasOptionalFields(){ return false; }
    public final int hashCode(){ return 0; }
    public static InventoryConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends InventoryConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<InventoryConfiguration.Builder, InventoryConfiguration>, SdkPojo
    {
        InventoryConfiguration.Builder destination(InventoryDestination p0);
        InventoryConfiguration.Builder filter(InventoryFilter p0);
        InventoryConfiguration.Builder id(String p0);
        InventoryConfiguration.Builder includedObjectVersions(InventoryIncludedObjectVersions p0);
        InventoryConfiguration.Builder includedObjectVersions(String p0);
        InventoryConfiguration.Builder isEnabled(Boolean p0);
        InventoryConfiguration.Builder optionalFields(Collection<InventoryOptionalField> p0);
        InventoryConfiguration.Builder optionalFields(InventoryOptionalField... p0);
        InventoryConfiguration.Builder optionalFieldsWithStrings(Collection<String> p0);
        InventoryConfiguration.Builder optionalFieldsWithStrings(String... p0);
        InventoryConfiguration.Builder schedule(InventorySchedule p0);
        default InventoryConfiguration.Builder destination(java.util.function.Consumer<InventoryDestination.Builder> p0){ return null; }
        default InventoryConfiguration.Builder filter(java.util.function.Consumer<InventoryFilter.Builder> p0){ return null; }
        default InventoryConfiguration.Builder schedule(java.util.function.Consumer<InventorySchedule.Builder> p0){ return null; }
    }
}
