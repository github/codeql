// Generated automatically from software.amazon.awssdk.services.s3.model.IntelligentTieringAndOperator for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Tag;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class IntelligentTieringAndOperator implements SdkPojo, Serializable, ToCopyableBuilder<IntelligentTieringAndOperator.Builder, IntelligentTieringAndOperator>
{
    protected IntelligentTieringAndOperator() {}
    public IntelligentTieringAndOperator.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<Tag> tags(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasTags(){ return false; }
    public final int hashCode(){ return 0; }
    public static IntelligentTieringAndOperator.Builder builder(){ return null; }
    public static java.lang.Class<? extends IntelligentTieringAndOperator.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<IntelligentTieringAndOperator.Builder, IntelligentTieringAndOperator>, SdkPojo
    {
        IntelligentTieringAndOperator.Builder prefix(String p0);
        IntelligentTieringAndOperator.Builder tags(Collection<Tag> p0);
        IntelligentTieringAndOperator.Builder tags(Tag... p0);
        IntelligentTieringAndOperator.Builder tags(java.util.function.Consumer<Tag.Builder>... p0);
    }
}
