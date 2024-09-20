// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketCorsRequest for testing purposes

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

public class GetBucketCorsRequest extends S3Request implements ToCopyableBuilder<GetBucketCorsRequest.Builder, GetBucketCorsRequest>
{
    protected GetBucketCorsRequest() {}
    public GetBucketCorsRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketCorsRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketCorsRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketCorsRequest.Builder, GetBucketCorsRequest>, S3Request.Builder, SdkPojo
    {
        GetBucketCorsRequest.Builder bucket(String p0);
        GetBucketCorsRequest.Builder expectedBucketOwner(String p0);
        GetBucketCorsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        GetBucketCorsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
    }
}
