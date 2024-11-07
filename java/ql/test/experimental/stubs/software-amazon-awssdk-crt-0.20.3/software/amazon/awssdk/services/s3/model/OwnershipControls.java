// Generated automatically from software.amazon.awssdk.services.s3.model.OwnershipControls for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.OwnershipControlsRule;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class OwnershipControls implements SdkPojo, Serializable, ToCopyableBuilder<OwnershipControls.Builder, OwnershipControls>
{
    protected OwnershipControls() {}
    public OwnershipControls.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<OwnershipControlsRule> rules(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasRules(){ return false; }
    public final int hashCode(){ return 0; }
    public static OwnershipControls.Builder builder(){ return null; }
    public static java.lang.Class<? extends OwnershipControls.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<OwnershipControls.Builder, OwnershipControls>, SdkPojo
    {
        OwnershipControls.Builder rules(Collection<OwnershipControlsRule> p0);
        OwnershipControls.Builder rules(OwnershipControlsRule... p0);
        OwnershipControls.Builder rules(java.util.function.Consumer<OwnershipControlsRule.Builder>... p0);
    }
}
