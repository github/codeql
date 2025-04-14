// Generated automatically from software.amazon.awssdk.services.s3.model.IntelligentTieringConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.IntelligentTieringFilter;
import software.amazon.awssdk.services.s3.model.IntelligentTieringStatus;
import software.amazon.awssdk.services.s3.model.Tiering;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class IntelligentTieringConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<IntelligentTieringConfiguration.Builder, IntelligentTieringConfiguration>
{
    protected IntelligentTieringConfiguration() {}
    public IntelligentTieringConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final IntelligentTieringFilter filter(){ return null; }
    public final IntelligentTieringStatus status(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<Tiering> tierings(){ return null; }
    public final String id(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasTierings(){ return false; }
    public final int hashCode(){ return 0; }
    public static IntelligentTieringConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends IntelligentTieringConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<IntelligentTieringConfiguration.Builder, IntelligentTieringConfiguration>, SdkPojo
    {
        IntelligentTieringConfiguration.Builder filter(IntelligentTieringFilter p0);
        IntelligentTieringConfiguration.Builder id(String p0);
        IntelligentTieringConfiguration.Builder status(IntelligentTieringStatus p0);
        IntelligentTieringConfiguration.Builder status(String p0);
        IntelligentTieringConfiguration.Builder tierings(Collection<Tiering> p0);
        IntelligentTieringConfiguration.Builder tierings(Tiering... p0);
        IntelligentTieringConfiguration.Builder tierings(java.util.function.Consumer<Tiering.Builder>... p0);
        default IntelligentTieringConfiguration.Builder filter(java.util.function.Consumer<IntelligentTieringFilter.Builder> p0){ return null; }
    }
}
