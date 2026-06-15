// Generated automatically from software.amazon.awssdk.services.s3.model.ServerSideEncryptionConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ServerSideEncryptionRule;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ServerSideEncryptionConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<ServerSideEncryptionConfiguration.Builder, ServerSideEncryptionConfiguration>
{
    protected ServerSideEncryptionConfiguration() {}
    public ServerSideEncryptionConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<ServerSideEncryptionRule> rules(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasRules(){ return false; }
    public final int hashCode(){ return 0; }
    public static ServerSideEncryptionConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends ServerSideEncryptionConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ServerSideEncryptionConfiguration.Builder, ServerSideEncryptionConfiguration>, SdkPojo
    {
        ServerSideEncryptionConfiguration.Builder rules(Collection<ServerSideEncryptionRule> p0);
        ServerSideEncryptionConfiguration.Builder rules(ServerSideEncryptionRule... p0);
        ServerSideEncryptionConfiguration.Builder rules(java.util.function.Consumer<ServerSideEncryptionRule.Builder>... p0);
    }
}
