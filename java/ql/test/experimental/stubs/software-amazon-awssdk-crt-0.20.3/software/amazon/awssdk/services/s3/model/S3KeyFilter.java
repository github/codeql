// Generated automatically from software.amazon.awssdk.services.s3.model.S3KeyFilter for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.FilterRule;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class S3KeyFilter implements SdkPojo, Serializable, ToCopyableBuilder<S3KeyFilter.Builder, S3KeyFilter>
{
    protected S3KeyFilter() {}
    public S3KeyFilter.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<FilterRule> filterRules(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasFilterRules(){ return false; }
    public final int hashCode(){ return 0; }
    public static S3KeyFilter.Builder builder(){ return null; }
    public static java.lang.Class<? extends S3KeyFilter.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<S3KeyFilter.Builder, S3KeyFilter>, SdkPojo
    {
        S3KeyFilter.Builder filterRules(Collection<FilterRule> p0);
        S3KeyFilter.Builder filterRules(FilterRule... p0);
        S3KeyFilter.Builder filterRules(java.util.function.Consumer<FilterRule.Builder>... p0);
    }
}
