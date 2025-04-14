// Generated automatically from software.amazon.awssdk.services.s3.model.AbortIncompleteMultipartUpload for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class AbortIncompleteMultipartUpload implements SdkPojo, Serializable, ToCopyableBuilder<AbortIncompleteMultipartUpload.Builder, AbortIncompleteMultipartUpload>
{
    protected AbortIncompleteMultipartUpload() {}
    public AbortIncompleteMultipartUpload.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Integer daysAfterInitiation(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static AbortIncompleteMultipartUpload.Builder builder(){ return null; }
    public static java.lang.Class<? extends AbortIncompleteMultipartUpload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<AbortIncompleteMultipartUpload.Builder, AbortIncompleteMultipartUpload>, SdkPojo
    {
        AbortIncompleteMultipartUpload.Builder daysAfterInitiation(Integer p0);
    }
}
