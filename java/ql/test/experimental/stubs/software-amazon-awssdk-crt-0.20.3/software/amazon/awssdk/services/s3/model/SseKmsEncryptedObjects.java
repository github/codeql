// Generated automatically from software.amazon.awssdk.services.s3.model.SseKmsEncryptedObjects for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.SseKmsEncryptedObjectsStatus;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class SseKmsEncryptedObjects implements SdkPojo, Serializable, ToCopyableBuilder<SseKmsEncryptedObjects.Builder, SseKmsEncryptedObjects>
{
    protected SseKmsEncryptedObjects() {}
    public SseKmsEncryptedObjects.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final SseKmsEncryptedObjectsStatus status(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static SseKmsEncryptedObjects.Builder builder(){ return null; }
    public static java.lang.Class<? extends SseKmsEncryptedObjects.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<SseKmsEncryptedObjects.Builder, SseKmsEncryptedObjects>, SdkPojo
    {
        SseKmsEncryptedObjects.Builder status(SseKmsEncryptedObjectsStatus p0);
        SseKmsEncryptedObjects.Builder status(String p0);
    }
}
