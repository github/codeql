// Generated automatically from software.amazon.awssdk.services.s3.model.ReplicationConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ReplicationRule;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ReplicationConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<ReplicationConfiguration.Builder, ReplicationConfiguration>
{
    protected ReplicationConfiguration() {}
    public ReplicationConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<ReplicationRule> rules(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String role(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasRules(){ return false; }
    public final int hashCode(){ return 0; }
    public static ReplicationConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends ReplicationConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ReplicationConfiguration.Builder, ReplicationConfiguration>, SdkPojo
    {
        ReplicationConfiguration.Builder role(String p0);
        ReplicationConfiguration.Builder rules(Collection<ReplicationRule> p0);
        ReplicationConfiguration.Builder rules(ReplicationRule... p0);
        ReplicationConfiguration.Builder rules(java.util.function.Consumer<ReplicationRule.Builder>... p0);
    }
}
