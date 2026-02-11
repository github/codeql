// Generated automatically from software.amazon.awssdk.services.s3.model.Encryption for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Encryption implements SdkPojo, Serializable, ToCopyableBuilder<Encryption.Builder, Encryption>
{
    protected Encryption() {}
    public Encryption.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ServerSideEncryption encryptionType(){ return null; }
    public final String encryptionTypeAsString(){ return null; }
    public final String kmsContext(){ return null; }
    public final String kmsKeyId(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Encryption.Builder builder(){ return null; }
    public static java.lang.Class<? extends Encryption.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Encryption.Builder, Encryption>, SdkPojo
    {
        Encryption.Builder encryptionType(ServerSideEncryption p0);
        Encryption.Builder encryptionType(String p0);
        Encryption.Builder kmsContext(String p0);
        Encryption.Builder kmsKeyId(String p0);
    }
}
