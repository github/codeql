// Generated automatically from software.amazon.awssdk.services.s3.model.LifecycleRule for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AbortIncompleteMultipartUpload;
import software.amazon.awssdk.services.s3.model.ExpirationStatus;
import software.amazon.awssdk.services.s3.model.LifecycleExpiration;
import software.amazon.awssdk.services.s3.model.LifecycleRuleFilter;
import software.amazon.awssdk.services.s3.model.NoncurrentVersionExpiration;
import software.amazon.awssdk.services.s3.model.NoncurrentVersionTransition;
import software.amazon.awssdk.services.s3.model.Transition;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class LifecycleRule implements SdkPojo, Serializable, ToCopyableBuilder<LifecycleRule.Builder, LifecycleRule>
{
    protected LifecycleRule() {}
    public LifecycleRule.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AbortIncompleteMultipartUpload abortIncompleteMultipartUpload(){ return null; }
    public final ExpirationStatus status(){ return null; }
    public final LifecycleExpiration expiration(){ return null; }
    public final LifecycleRuleFilter filter(){ return null; }
    public final List<NoncurrentVersionTransition> noncurrentVersionTransitions(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<Transition> transitions(){ return null; }
    public final NoncurrentVersionExpiration noncurrentVersionExpiration(){ return null; }
    public final String id(){ return null; }
    public final String prefix(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasNoncurrentVersionTransitions(){ return false; }
    public final boolean hasTransitions(){ return false; }
    public final int hashCode(){ return 0; }
    public static LifecycleRule.Builder builder(){ return null; }
    public static java.lang.Class<? extends LifecycleRule.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<LifecycleRule.Builder, LifecycleRule>, SdkPojo
    {
        LifecycleRule.Builder abortIncompleteMultipartUpload(AbortIncompleteMultipartUpload p0);
        LifecycleRule.Builder expiration(LifecycleExpiration p0);
        LifecycleRule.Builder filter(LifecycleRuleFilter p0);
        LifecycleRule.Builder id(String p0);
        LifecycleRule.Builder noncurrentVersionExpiration(NoncurrentVersionExpiration p0);
        LifecycleRule.Builder noncurrentVersionTransitions(Collection<NoncurrentVersionTransition> p0);
        LifecycleRule.Builder noncurrentVersionTransitions(NoncurrentVersionTransition... p0);
        LifecycleRule.Builder noncurrentVersionTransitions(java.util.function.Consumer<NoncurrentVersionTransition.Builder>... p0);
        LifecycleRule.Builder prefix(String p0);
        LifecycleRule.Builder status(ExpirationStatus p0);
        LifecycleRule.Builder status(String p0);
        LifecycleRule.Builder transitions(Collection<Transition> p0);
        LifecycleRule.Builder transitions(Transition... p0);
        LifecycleRule.Builder transitions(java.util.function.Consumer<Transition.Builder>... p0);
        default LifecycleRule.Builder abortIncompleteMultipartUpload(java.util.function.Consumer<AbortIncompleteMultipartUpload.Builder> p0){ return null; }
        default LifecycleRule.Builder expiration(java.util.function.Consumer<LifecycleExpiration.Builder> p0){ return null; }
        default LifecycleRule.Builder filter(java.util.function.Consumer<LifecycleRuleFilter.Builder> p0){ return null; }
        default LifecycleRule.Builder noncurrentVersionExpiration(java.util.function.Consumer<NoncurrentVersionExpiration.Builder> p0){ return null; }
    }
}
