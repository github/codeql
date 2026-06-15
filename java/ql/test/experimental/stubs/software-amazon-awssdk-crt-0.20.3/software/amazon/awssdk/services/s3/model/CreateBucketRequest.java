// Generated automatically from software.amazon.awssdk.services.s3.model.CreateBucketRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketCannedACL;
import software.amazon.awssdk.services.s3.model.CreateBucketConfiguration;
import software.amazon.awssdk.services.s3.model.ObjectOwnership;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CreateBucketRequest extends S3Request implements ToCopyableBuilder<CreateBucketRequest.Builder, CreateBucketRequest>
{
    protected CreateBucketRequest() {}
    public CreateBucketRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean objectLockEnabledForBucket(){ return null; }
    public final BucketCannedACL acl(){ return null; }
    public final CreateBucketConfiguration createBucketConfiguration(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectOwnership objectOwnership(){ return null; }
    public final String aclAsString(){ return null; }
    public final String bucket(){ return null; }
    public final String grantFullControl(){ return null; }
    public final String grantRead(){ return null; }
    public final String grantReadACP(){ return null; }
    public final String grantWrite(){ return null; }
    public final String grantWriteACP(){ return null; }
    public final String objectOwnershipAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static CreateBucketRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends CreateBucketRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CreateBucketRequest.Builder, CreateBucketRequest>, S3Request.Builder, SdkPojo
    {
        CreateBucketRequest.Builder acl(BucketCannedACL p0);
        CreateBucketRequest.Builder acl(String p0);
        CreateBucketRequest.Builder bucket(String p0);
        CreateBucketRequest.Builder createBucketConfiguration(CreateBucketConfiguration p0);
        CreateBucketRequest.Builder grantFullControl(String p0);
        CreateBucketRequest.Builder grantRead(String p0);
        CreateBucketRequest.Builder grantReadACP(String p0);
        CreateBucketRequest.Builder grantWrite(String p0);
        CreateBucketRequest.Builder grantWriteACP(String p0);
        CreateBucketRequest.Builder objectLockEnabledForBucket(Boolean p0);
        CreateBucketRequest.Builder objectOwnership(ObjectOwnership p0);
        CreateBucketRequest.Builder objectOwnership(String p0);
        CreateBucketRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        CreateBucketRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        default CreateBucketRequest.Builder createBucketConfiguration(java.util.function.Consumer<CreateBucketConfiguration.Builder> p0){ return null; }
    }
}
