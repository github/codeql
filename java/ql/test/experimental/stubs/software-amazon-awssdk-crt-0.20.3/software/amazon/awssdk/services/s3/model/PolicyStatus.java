// Generated automatically from software.amazon.awssdk.services.s3.model.PolicyStatus for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PolicyStatus implements SdkPojo, Serializable, ToCopyableBuilder<PolicyStatus.Builder, PolicyStatus>
{
    protected PolicyStatus() {}
    public PolicyStatus.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isPublic(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PolicyStatus.Builder builder(){ return null; }
    public static java.lang.Class<? extends PolicyStatus.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PolicyStatus.Builder, PolicyStatus>, SdkPojo
    {
        PolicyStatus.Builder isPublic(Boolean p0);
    }
}
