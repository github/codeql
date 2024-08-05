// Generated automatically from software.amazon.awssdk.services.s3.model.TopicConfiguration for testing purposes

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

public class TopicConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<TopicConfiguration.Builder, TopicConfiguration>
{
    protected TopicConfiguration() {}
    public TopicConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<Event> events(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<String> eventsAsStrings(){ return null; }
    public final NotificationConfigurationFilter filter(){ return null; }
    public final String id(){ return null; }
    public final String toString(){ return null; }
    public final String topicArn(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasEvents(){ return false; }
    public final int hashCode(){ return 0; }
    public static TopicConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends TopicConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<TopicConfiguration.Builder, TopicConfiguration>, SdkPojo
    {
        TopicConfiguration.Builder events(Collection<Event> p0);
        TopicConfiguration.Builder events(Event... p0);
        TopicConfiguration.Builder eventsWithStrings(Collection<String> p0);
        TopicConfiguration.Builder eventsWithStrings(String... p0);
        TopicConfiguration.Builder filter(NotificationConfigurationFilter p0);
        TopicConfiguration.Builder id(String p0);
        TopicConfiguration.Builder topicArn(String p0);
        default TopicConfiguration.Builder filter(java.util.function.Consumer<NotificationConfigurationFilter.Builder> p0){ return null; }
    }
}
