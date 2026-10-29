// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketNotificationConfigurationRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.NotificationConfiguration;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketNotificationConfigurationRequest extends S3Request implements ToCopyableBuilder<PutBucketNotificationConfigurationRequest.Builder, PutBucketNotificationConfigurationRequest>
{
    protected PutBucketNotificationConfigurationRequest() {}
    public PutBucketNotificationConfigurationRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean skipDestinationValidation(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final NotificationConfiguration notificationConfiguration(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketNotificationConfigurationRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketNotificationConfigurationRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketNotificationConfigurationRequest.Builder, PutBucketNotificationConfigurationRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketNotificationConfigurationRequest.Builder bucket(String p0);
        PutBucketNotificationConfigurationRequest.Builder expectedBucketOwner(String p0);
        PutBucketNotificationConfigurationRequest.Builder notificationConfiguration(NotificationConfiguration p0);
        PutBucketNotificationConfigurationRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketNotificationConfigurationRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutBucketNotificationConfigurationRequest.Builder skipDestinationValidation(Boolean p0);
        default PutBucketNotificationConfigurationRequest.Builder notificationConfiguration(java.util.function.Consumer<NotificationConfiguration.Builder> p0){ return null; }
    }
}
