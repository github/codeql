// Generated automatically from software.amazon.awssdk.services.s3.model.Tag for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Tag implements SdkPojo, Serializable, ToCopyableBuilder<Tag.Builder, Tag>
{
    protected Tag() {}
    public Tag.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String key(){ return null; }
    public final String toString(){ return null; }
    public final String value(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Tag.Builder builder(){ return null; }
    public static java.lang.Class<? extends Tag.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Tag.Builder, Tag>, SdkPojo
    {
        Tag.Builder key(String p0);
        Tag.Builder value(String p0);
    }
}
