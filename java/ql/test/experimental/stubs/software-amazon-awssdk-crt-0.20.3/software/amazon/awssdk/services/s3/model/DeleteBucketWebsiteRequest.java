// Generated automatically from software.amazon.awssdk.services.s3.model.DeleteBucketWebsiteRequest for testing purposes

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

public class DeleteBucketWebsiteRequest extends S3Request implements ToCopyableBuilder<DeleteBucketWebsiteRequest.Builder, DeleteBucketWebsiteRequest>
{
    protected DeleteBucketWebsiteRequest() {}
    public DeleteBucketWebsiteRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static DeleteBucketWebsiteRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends DeleteBucketWebsiteRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DeleteBucketWebsiteRequest.Builder, DeleteBucketWebsiteRequest>, S3Request.Builder, SdkPojo
    {
        DeleteBucketWebsiteRequest.Builder bucket(String p0);
        DeleteBucketWebsiteRequest.Builder expectedBucketOwner(String p0);
        DeleteBucketWebsiteRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        DeleteBucketWebsiteRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
    }
}
