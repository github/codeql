// Generated automatically from software.amazon.awssdk.services.s3.model.Delete for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectIdentifier;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Delete implements SdkPojo, Serializable, ToCopyableBuilder<Delete.Builder, Delete>
{
    protected Delete() {}
    public Delete.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean quiet(){ return null; }
    public final List<ObjectIdentifier> objects(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasObjects(){ return false; }
    public final int hashCode(){ return 0; }
    public static Delete.Builder builder(){ return null; }
    public static java.lang.Class<? extends Delete.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Delete.Builder, Delete>, SdkPojo
    {
        Delete.Builder objects(Collection<ObjectIdentifier> p0);
        Delete.Builder objects(ObjectIdentifier... p0);
        Delete.Builder objects(java.util.function.Consumer<ObjectIdentifier.Builder>... p0);
        Delete.Builder quiet(Boolean p0);
    }
}
