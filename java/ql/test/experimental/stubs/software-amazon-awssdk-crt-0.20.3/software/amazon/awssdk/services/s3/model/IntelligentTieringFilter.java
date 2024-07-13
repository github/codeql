// Generated automatically from software.amazon.awssdk.services.s3.model.IntelligentTieringFilter for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.IntelligentTieringAndOperator;
import software.amazon.awssdk.services.s3.model.Tag;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class IntelligentTieringFilter implements SdkPojo, Serializable, ToCopyableBuilder<IntelligentTieringFilter.Builder, IntelligentTieringFilter>
{
    protected IntelligentTieringFilter() {}
    public IntelligentTieringFilter.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final IntelligentTieringAndOperator and(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final Tag tag(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static IntelligentTieringFilter.Builder builder(){ return null; }
    public static java.lang.Class<? extends IntelligentTieringFilter.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<IntelligentTieringFilter.Builder, IntelligentTieringFilter>, SdkPojo
    {
        IntelligentTieringFilter.Builder and(IntelligentTieringAndOperator p0);
        IntelligentTieringFilter.Builder prefix(String p0);
        IntelligentTieringFilter.Builder tag(Tag p0);
        default IntelligentTieringFilter.Builder and(java.util.function.Consumer<IntelligentTieringAndOperator.Builder> p0){ return null; }
        default IntelligentTieringFilter.Builder tag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    }
}
