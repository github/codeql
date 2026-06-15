// Generated automatically from software.amazon.awssdk.services.s3.model.Tagging for testing purposes

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

public class Tagging implements SdkPojo, Serializable, ToCopyableBuilder<Tagging.Builder, Tagging>
{
    protected Tagging() {}
    public Tagging.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<Tag> tagSet(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasTagSet(){ return false; }
    public final int hashCode(){ return 0; }
    public static Tagging.Builder builder(){ return null; }
    public static java.lang.Class<? extends Tagging.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Tagging.Builder, Tagging>, SdkPojo
    {
        Tagging.Builder tagSet(Collection<Tag> p0);
        Tagging.Builder tagSet(Tag... p0);
        Tagging.Builder tagSet(java.util.function.Consumer<Tag.Builder>... p0);
    }
}
