// Generated automatically from software.amazon.awssdk.services.s3.model.DeletedObject for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DeletedObject implements SdkPojo, Serializable, ToCopyableBuilder<DeletedObject.Builder, DeletedObject>
{
    protected DeletedObject() {}
    public DeletedObject.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean deleteMarker(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String deleteMarkerVersionId(){ return null; }
    public final String key(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static DeletedObject.Builder builder(){ return null; }
    public static java.lang.Class<? extends DeletedObject.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DeletedObject.Builder, DeletedObject>, SdkPojo
    {
        DeletedObject.Builder deleteMarker(Boolean p0);
        DeletedObject.Builder deleteMarkerVersionId(String p0);
        DeletedObject.Builder key(String p0);
        DeletedObject.Builder versionId(String p0);
    }
}
