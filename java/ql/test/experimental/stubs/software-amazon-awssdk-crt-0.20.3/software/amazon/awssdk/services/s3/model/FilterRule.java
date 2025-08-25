// Generated automatically from software.amazon.awssdk.services.s3.model.FilterRule for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.FilterRuleName;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class FilterRule implements SdkPojo, Serializable, ToCopyableBuilder<FilterRule.Builder, FilterRule>
{
    protected FilterRule() {}
    public FilterRule.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final FilterRuleName name(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String nameAsString(){ return null; }
    public final String toString(){ return null; }
    public final String value(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static FilterRule.Builder builder(){ return null; }
    public static java.lang.Class<? extends FilterRule.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<FilterRule.Builder, FilterRule>, SdkPojo
    {
        FilterRule.Builder name(FilterRuleName p0);
        FilterRule.Builder name(String p0);
        FilterRule.Builder value(String p0);
    }
}
