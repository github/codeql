// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketCorsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CORSRule;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketCorsResponse extends S3Response implements ToCopyableBuilder<GetBucketCorsResponse.Builder, GetBucketCorsResponse>
{
    protected GetBucketCorsResponse() {}
    public GetBucketCorsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<CORSRule> corsRules(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasCorsRules(){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketCorsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketCorsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketCorsResponse.Builder, GetBucketCorsResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketCorsResponse.Builder corsRules(CORSRule... p0);
        GetBucketCorsResponse.Builder corsRules(Collection<CORSRule> p0);
        GetBucketCorsResponse.Builder corsRules(java.util.function.Consumer<CORSRule.Builder>... p0);
    }
}
