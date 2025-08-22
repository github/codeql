// Generated automatically from software.amazon.awssdk.services.s3.model.ListBucketIntelligentTieringConfigurationsRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListBucketIntelligentTieringConfigurationsRequest extends S3Request implements ToCopyableBuilder<ListBucketIntelligentTieringConfigurationsRequest.Builder, ListBucketIntelligentTieringConfigurationsRequest>
{
    protected ListBucketIntelligentTieringConfigurationsRequest() {}
    public ListBucketIntelligentTieringConfigurationsRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String continuationToken(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ListBucketIntelligentTieringConfigurationsRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListBucketIntelligentTieringConfigurationsRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListBucketIntelligentTieringConfigurationsRequest.Builder, ListBucketIntelligentTieringConfigurationsRequest>, S3Request.Builder, SdkPojo
    {
        ListBucketIntelligentTieringConfigurationsRequest.Builder bucket(String p0);
        ListBucketIntelligentTieringConfigurationsRequest.Builder continuationToken(String p0);
        ListBucketIntelligentTieringConfigurationsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        ListBucketIntelligentTieringConfigurationsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
    }
}
