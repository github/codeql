// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketLifecycleConfigurationResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.LifecycleRule;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketLifecycleConfigurationResponse extends S3Response implements ToCopyableBuilder<GetBucketLifecycleConfigurationResponse.Builder, GetBucketLifecycleConfigurationResponse>
{
    protected GetBucketLifecycleConfigurationResponse() {}
    public GetBucketLifecycleConfigurationResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<LifecycleRule> rules(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasRules(){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketLifecycleConfigurationResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketLifecycleConfigurationResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketLifecycleConfigurationResponse.Builder, GetBucketLifecycleConfigurationResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketLifecycleConfigurationResponse.Builder rules(Collection<LifecycleRule> p0);
        GetBucketLifecycleConfigurationResponse.Builder rules(LifecycleRule... p0);
        GetBucketLifecycleConfigurationResponse.Builder rules(java.util.function.Consumer<LifecycleRule.Builder>... p0);
    }
}
