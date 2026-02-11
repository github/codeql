// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketNotificationConfigurationResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.EventBridgeConfiguration;
import software.amazon.awssdk.services.s3.model.LambdaFunctionConfiguration;
import software.amazon.awssdk.services.s3.model.QueueConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.TopicConfiguration;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketNotificationConfigurationResponse extends S3Response implements ToCopyableBuilder<GetBucketNotificationConfigurationResponse.Builder, GetBucketNotificationConfigurationResponse>
{
    protected GetBucketNotificationConfigurationResponse() {}
    public GetBucketNotificationConfigurationResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final EventBridgeConfiguration eventBridgeConfiguration(){ return null; }
    public final List<LambdaFunctionConfiguration> lambdaFunctionConfigurations(){ return null; }
    public final List<QueueConfiguration> queueConfigurations(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<TopicConfiguration> topicConfigurations(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasLambdaFunctionConfigurations(){ return false; }
    public final boolean hasQueueConfigurations(){ return false; }
    public final boolean hasTopicConfigurations(){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketNotificationConfigurationResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketNotificationConfigurationResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketNotificationConfigurationResponse.Builder, GetBucketNotificationConfigurationResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketNotificationConfigurationResponse.Builder eventBridgeConfiguration(EventBridgeConfiguration p0);
        GetBucketNotificationConfigurationResponse.Builder lambdaFunctionConfigurations(Collection<LambdaFunctionConfiguration> p0);
        GetBucketNotificationConfigurationResponse.Builder lambdaFunctionConfigurations(LambdaFunctionConfiguration... p0);
        GetBucketNotificationConfigurationResponse.Builder lambdaFunctionConfigurations(java.util.function.Consumer<LambdaFunctionConfiguration.Builder>... p0);
        GetBucketNotificationConfigurationResponse.Builder queueConfigurations(Collection<QueueConfiguration> p0);
        GetBucketNotificationConfigurationResponse.Builder queueConfigurations(QueueConfiguration... p0);
        GetBucketNotificationConfigurationResponse.Builder queueConfigurations(java.util.function.Consumer<QueueConfiguration.Builder>... p0);
        GetBucketNotificationConfigurationResponse.Builder topicConfigurations(Collection<TopicConfiguration> p0);
        GetBucketNotificationConfigurationResponse.Builder topicConfigurations(TopicConfiguration... p0);
        GetBucketNotificationConfigurationResponse.Builder topicConfigurations(java.util.function.Consumer<TopicConfiguration.Builder>... p0);
        default GetBucketNotificationConfigurationResponse.Builder eventBridgeConfiguration(java.util.function.Consumer<EventBridgeConfiguration.Builder> p0){ return null; }
    }
}
