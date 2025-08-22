// Generated automatically from software.amazon.awssdk.services.s3.model.AnalyticsFilter for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AnalyticsAndOperator;
import software.amazon.awssdk.services.s3.model.Tag;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class AnalyticsFilter implements SdkPojo, Serializable, ToCopyableBuilder<AnalyticsFilter.Builder, AnalyticsFilter>
{
    protected AnalyticsFilter() {}
    public AnalyticsFilter.Builder toBuilder(){ return null; }
    public AnalyticsFilter.Type type(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AnalyticsAndOperator and(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final Tag tag(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static AnalyticsFilter fromAnd(AnalyticsAndOperator p0){ return null; }
    public static AnalyticsFilter fromAnd(java.util.function.Consumer<AnalyticsAndOperator.Builder> p0){ return null; }
    public static AnalyticsFilter fromPrefix(String p0){ return null; }
    public static AnalyticsFilter fromTag(Tag p0){ return null; }
    public static AnalyticsFilter fromTag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    public static AnalyticsFilter.Builder builder(){ return null; }
    public static java.lang.Class<? extends AnalyticsFilter.Builder> serializableBuilderClass(){ return null; }
    static public enum Type
    {
        AND, PREFIX, TAG, UNKNOWN_TO_SDK_VERSION;
        private Type() {}
    }
    static public interface Builder extends CopyableBuilder<AnalyticsFilter.Builder, AnalyticsFilter>, SdkPojo
    {
        AnalyticsFilter.Builder and(AnalyticsAndOperator p0);
        AnalyticsFilter.Builder prefix(String p0);
        AnalyticsFilter.Builder tag(Tag p0);
        default AnalyticsFilter.Builder and(java.util.function.Consumer<AnalyticsAndOperator.Builder> p0){ return null; }
        default AnalyticsFilter.Builder tag(java.util.function.Consumer<Tag.Builder> p0){ return null; }
    }
}
