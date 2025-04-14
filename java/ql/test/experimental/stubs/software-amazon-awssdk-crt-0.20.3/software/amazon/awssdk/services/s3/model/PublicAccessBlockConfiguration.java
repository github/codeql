// Generated automatically from software.amazon.awssdk.services.s3.model.PublicAccessBlockConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PublicAccessBlockConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<PublicAccessBlockConfiguration.Builder, PublicAccessBlockConfiguration>
{
    protected PublicAccessBlockConfiguration() {}
    public PublicAccessBlockConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean blockPublicAcls(){ return null; }
    public final Boolean blockPublicPolicy(){ return null; }
    public final Boolean ignorePublicAcls(){ return null; }
    public final Boolean restrictPublicBuckets(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PublicAccessBlockConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends PublicAccessBlockConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PublicAccessBlockConfiguration.Builder, PublicAccessBlockConfiguration>, SdkPojo
    {
        PublicAccessBlockConfiguration.Builder blockPublicAcls(Boolean p0);
        PublicAccessBlockConfiguration.Builder blockPublicPolicy(Boolean p0);
        PublicAccessBlockConfiguration.Builder ignorePublicAcls(Boolean p0);
        PublicAccessBlockConfiguration.Builder restrictPublicBuckets(Boolean p0);
    }
}
