// Generated automatically from software.amazon.awssdk.services.s3.model.PutBucketAclRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AccessControlPolicy;
import software.amazon.awssdk.services.s3.model.BucketCannedACL;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutBucketAclRequest extends S3Request implements ToCopyableBuilder<PutBucketAclRequest.Builder, PutBucketAclRequest>
{
    protected PutBucketAclRequest() {}
    public PutBucketAclRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AccessControlPolicy accessControlPolicy(){ return null; }
    public final BucketCannedACL acl(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String aclAsString(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String grantFullControl(){ return null; }
    public final String grantRead(){ return null; }
    public final String grantReadACP(){ return null; }
    public final String grantWrite(){ return null; }
    public final String grantWriteACP(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutBucketAclRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutBucketAclRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutBucketAclRequest.Builder, PutBucketAclRequest>, S3Request.Builder, SdkPojo
    {
        PutBucketAclRequest.Builder accessControlPolicy(AccessControlPolicy p0);
        PutBucketAclRequest.Builder acl(BucketCannedACL p0);
        PutBucketAclRequest.Builder acl(String p0);
        PutBucketAclRequest.Builder bucket(String p0);
        PutBucketAclRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutBucketAclRequest.Builder checksumAlgorithm(String p0);
        PutBucketAclRequest.Builder contentMD5(String p0);
        PutBucketAclRequest.Builder expectedBucketOwner(String p0);
        PutBucketAclRequest.Builder grantFullControl(String p0);
        PutBucketAclRequest.Builder grantRead(String p0);
        PutBucketAclRequest.Builder grantReadACP(String p0);
        PutBucketAclRequest.Builder grantWrite(String p0);
        PutBucketAclRequest.Builder grantWriteACP(String p0);
        PutBucketAclRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutBucketAclRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        default PutBucketAclRequest.Builder accessControlPolicy(java.util.function.Consumer<AccessControlPolicy.Builder> p0){ return null; }
    }
}
