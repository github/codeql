// Generated automatically from software.amazon.awssdk.services.s3.model.GetPublicAccessBlockRequest for testing purposes

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

public class GetPublicAccessBlockRequest extends S3Request implements ToCopyableBuilder<GetPublicAccessBlockRequest.Builder, GetPublicAccessBlockRequest>
{
    protected GetPublicAccessBlockRequest() {}
    public GetPublicAccessBlockRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetPublicAccessBlockRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetPublicAccessBlockRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetPublicAccessBlockRequest.Builder, GetPublicAccessBlockRequest>, S3Request.Builder, SdkPojo
    {
        GetPublicAccessBlockRequest.Builder bucket(String p0);
        GetPublicAccessBlockRequest.Builder expectedBucketOwner(String p0);
        GetPublicAccessBlockRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        GetPublicAccessBlockRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
    }
}
