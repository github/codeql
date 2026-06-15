// Generated automatically from software.amazon.awssdk.services.s3.model.Tiering for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.IntelligentTieringAccessTier;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Tiering implements SdkPojo, Serializable, ToCopyableBuilder<Tiering.Builder, Tiering>
{
    protected Tiering() {}
    public Tiering.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Integer days(){ return null; }
    public final IntelligentTieringAccessTier accessTier(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String accessTierAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Tiering.Builder builder(){ return null; }
    public static java.lang.Class<? extends Tiering.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Tiering.Builder, Tiering>, SdkPojo
    {
        Tiering.Builder accessTier(IntelligentTieringAccessTier p0);
        Tiering.Builder accessTier(String p0);
        Tiering.Builder days(Integer p0);
    }
}
