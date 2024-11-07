// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketIntelligentTieringConfigurationResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.IntelligentTieringConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketIntelligentTieringConfigurationResponse extends S3Response implements ToCopyableBuilder<GetBucketIntelligentTieringConfigurationResponse.Builder, GetBucketIntelligentTieringConfigurationResponse>
{
    protected GetBucketIntelligentTieringConfigurationResponse() {}
    public GetBucketIntelligentTieringConfigurationResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final IntelligentTieringConfiguration intelligentTieringConfiguration(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketIntelligentTieringConfigurationResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketIntelligentTieringConfigurationResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketIntelligentTieringConfigurationResponse.Builder, GetBucketIntelligentTieringConfigurationResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketIntelligentTieringConfigurationResponse.Builder intelligentTieringConfiguration(IntelligentTieringConfiguration p0);
        default GetBucketIntelligentTieringConfigurationResponse.Builder intelligentTieringConfiguration(java.util.function.Consumer<IntelligentTieringConfiguration.Builder> p0){ return null; }
    }
}
