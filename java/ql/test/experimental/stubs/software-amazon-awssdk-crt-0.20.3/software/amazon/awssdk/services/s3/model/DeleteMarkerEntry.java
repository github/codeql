// Generated automatically from software.amazon.awssdk.services.s3.model.DeleteMarkerEntry for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Owner;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DeleteMarkerEntry implements SdkPojo, Serializable, ToCopyableBuilder<DeleteMarkerEntry.Builder, DeleteMarkerEntry>
{
    protected DeleteMarkerEntry() {}
    public DeleteMarkerEntry.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isLatest(){ return null; }
    public final Instant lastModified(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Owner owner(){ return null; }
    public final String key(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static DeleteMarkerEntry.Builder builder(){ return null; }
    public static java.lang.Class<? extends DeleteMarkerEntry.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DeleteMarkerEntry.Builder, DeleteMarkerEntry>, SdkPojo
    {
        DeleteMarkerEntry.Builder isLatest(Boolean p0);
        DeleteMarkerEntry.Builder key(String p0);
        DeleteMarkerEntry.Builder lastModified(Instant p0);
        DeleteMarkerEntry.Builder owner(Owner p0);
        DeleteMarkerEntry.Builder versionId(String p0);
        default DeleteMarkerEntry.Builder owner(java.util.function.Consumer<Owner.Builder> p0){ return null; }
    }
}
