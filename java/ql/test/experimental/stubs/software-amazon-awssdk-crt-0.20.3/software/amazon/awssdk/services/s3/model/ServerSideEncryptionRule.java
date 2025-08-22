// Generated automatically from software.amazon.awssdk.services.s3.model.ServerSideEncryptionRule for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ServerSideEncryptionByDefault;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ServerSideEncryptionRule implements SdkPojo, Serializable, ToCopyableBuilder<ServerSideEncryptionRule.Builder, ServerSideEncryptionRule>
{
    protected ServerSideEncryptionRule() {}
    public ServerSideEncryptionRule.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ServerSideEncryptionByDefault applyServerSideEncryptionByDefault(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ServerSideEncryptionRule.Builder builder(){ return null; }
    public static java.lang.Class<? extends ServerSideEncryptionRule.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ServerSideEncryptionRule.Builder, ServerSideEncryptionRule>, SdkPojo
    {
        ServerSideEncryptionRule.Builder applyServerSideEncryptionByDefault(ServerSideEncryptionByDefault p0);
        ServerSideEncryptionRule.Builder bucketKeyEnabled(Boolean p0);
        default ServerSideEncryptionRule.Builder applyServerSideEncryptionByDefault(java.util.function.Consumer<ServerSideEncryptionByDefault.Builder> p0){ return null; }
    }
}
