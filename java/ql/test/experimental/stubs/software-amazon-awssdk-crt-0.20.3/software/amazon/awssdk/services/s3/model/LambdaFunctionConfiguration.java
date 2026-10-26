// Generated automatically from software.amazon.awssdk.services.s3.model.LambdaFunctionConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Event;
import software.amazon.awssdk.services.s3.model.NotificationConfigurationFilter;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class LambdaFunctionConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<LambdaFunctionConfiguration.Builder, LambdaFunctionConfiguration>
{
    protected LambdaFunctionConfiguration() {}
    public LambdaFunctionConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<Event> events(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<String> eventsAsStrings(){ return null; }
    public final NotificationConfigurationFilter filter(){ return null; }
    public final String id(){ return null; }
    public final String lambdaFunctionArn(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasEvents(){ return false; }
    public final int hashCode(){ return 0; }
    public static LambdaFunctionConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends LambdaFunctionConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<LambdaFunctionConfiguration.Builder, LambdaFunctionConfiguration>, SdkPojo
    {
        LambdaFunctionConfiguration.Builder events(Collection<Event> p0);
        LambdaFunctionConfiguration.Builder events(Event... p0);
        LambdaFunctionConfiguration.Builder eventsWithStrings(Collection<String> p0);
        LambdaFunctionConfiguration.Builder eventsWithStrings(String... p0);
        LambdaFunctionConfiguration.Builder filter(NotificationConfigurationFilter p0);
        LambdaFunctionConfiguration.Builder id(String p0);
        LambdaFunctionConfiguration.Builder lambdaFunctionArn(String p0);
        default LambdaFunctionConfiguration.Builder filter(java.util.function.Consumer<NotificationConfigurationFilter.Builder> p0){ return null; }
    }
}
