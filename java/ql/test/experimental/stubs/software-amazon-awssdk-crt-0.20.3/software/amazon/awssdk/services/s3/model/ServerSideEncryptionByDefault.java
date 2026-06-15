// Generated automatically from software.amazon.awssdk.services.s3.model.ServerSideEncryptionByDefault for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ServerSideEncryptionByDefault implements SdkPojo, Serializable, ToCopyableBuilder<ServerSideEncryptionByDefault.Builder, ServerSideEncryptionByDefault>
{
    protected ServerSideEncryptionByDefault() {}
    public ServerSideEncryptionByDefault.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ServerSideEncryption sseAlgorithm(){ return null; }
    public final String kmsMasterKeyID(){ return null; }
    public final String sseAlgorithmAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ServerSideEncryptionByDefault.Builder builder(){ return null; }
    public static java.lang.Class<? extends ServerSideEncryptionByDefault.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ServerSideEncryptionByDefault.Builder, ServerSideEncryptionByDefault>, SdkPojo
    {
        ServerSideEncryptionByDefault.Builder kmsMasterKeyID(String p0);
        ServerSideEncryptionByDefault.Builder sseAlgorithm(ServerSideEncryption p0);
        ServerSideEncryptionByDefault.Builder sseAlgorithm(String p0);
    }
}
