// Generated automatically from software.amazon.awssdk.services.s3.model.BucketLifecycleConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.LifecycleRule;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class BucketLifecycleConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<BucketLifecycleConfiguration.Builder, BucketLifecycleConfiguration>
{
    protected BucketLifecycleConfiguration() {}
    public BucketLifecycleConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<LifecycleRule> rules(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasRules(){ return false; }
    public final int hashCode(){ return 0; }
    public static BucketLifecycleConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends BucketLifecycleConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<BucketLifecycleConfiguration.Builder, BucketLifecycleConfiguration>, SdkPojo
    {
        BucketLifecycleConfiguration.Builder rules(Collection<LifecycleRule> p0);
        BucketLifecycleConfiguration.Builder rules(LifecycleRule... p0);
        BucketLifecycleConfiguration.Builder rules(java.util.function.Consumer<LifecycleRule.Builder>... p0);
    }
}
