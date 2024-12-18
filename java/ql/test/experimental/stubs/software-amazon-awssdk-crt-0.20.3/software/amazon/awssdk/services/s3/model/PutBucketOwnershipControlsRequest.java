// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketOwnershipControlsRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.OwnershipControls;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketOwnershipControlsRequest extends S3Request implements ToCopyableBuilder<PutBucketOwnershipControlsRequest.Builder, PutBucketOwnershipControlsRequest>
{
    protected PutBucketOwnershipControlsRequest() {}
    public PutBucketOwnershipControlsRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final OwnershipControls ownershipControls(){ return null; }
    public final String bucket(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketOwnershipControlsRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketOwnershipControlsRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketOwnershipControlsRequest.Builder, PutBucketOwnershipControlsRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketOwnershipControlsRequest.Builder bucket(String p0);
        PutBucketOwnershipControlsRequest.Builder contentMD5(String p0);
        PutBucketOwnershipControlsRequest.Builder expectedBucketOwner(String p0);
        PutBucketOwnershipControlsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketOwnershipControlsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutBucketOwnershipControlsRequest.Builder ownershipControls(OwnershipControls p0);
        default PutBucketOwnershipControlsRequest.Builder ownershipControls(java.util.function.Consumer<OwnershipControls.Builder> p0){ return null; }
    }
}
