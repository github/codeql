// Generated automatically from software.amazon.awssdk.services.s3.model.AnalyticsConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AnalyticsFilter;
import software.amazon.awssdk.services.s3.model.StorageClassAnalysis;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class AnalyticsConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<AnalyticsConfiguration.Builder, AnalyticsConfiguration>
{
    protected AnalyticsConfiguration() {}
    public AnalyticsConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AnalyticsFilter filter(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final StorageClassAnalysis storageClassAnalysis(){ return null; }
    public final String id(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static AnalyticsConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends AnalyticsConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<AnalyticsConfiguration.Builder, AnalyticsConfiguration>, SdkPojo
    {
        AnalyticsConfiguration.Builder filter(AnalyticsFilter p0);
        AnalyticsConfiguration.Builder id(String p0);
        AnalyticsConfiguration.Builder storageClassAnalysis(StorageClassAnalysis p0);
        default AnalyticsConfiguration.Builder filter(java.util.function.Consumer<AnalyticsFilter.Builder> p0){ return null; }
        default AnalyticsConfiguration.Builder storageClassAnalysis(java.util.function.Consumer<StorageClassAnalysis.Builder> p0){ return null; }
    }
}
