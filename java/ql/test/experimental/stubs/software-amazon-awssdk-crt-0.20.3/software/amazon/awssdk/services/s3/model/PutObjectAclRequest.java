// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectAclRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AccessControlPolicy;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutObjectAclRequest extends S3Request implements ToCopyableBuilder<PutObjectAclRequest.Builder, PutObjectAclRequest>
{
    protected PutObjectAclRequest() {}
    public PutObjectAclRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AccessControlPolicy accessControlPolicy(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectCannedACL acl(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
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
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutObjectAclRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectAclRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectAclRequest.Builder, PutObjectAclRequest>, S3Request.Builder, SdkPojo
    {
        PutObjectAclRequest.Builder accessControlPolicy(AccessControlPolicy p0);
        PutObjectAclRequest.Builder acl(ObjectCannedACL p0);
        PutObjectAclRequest.Builder acl(String p0);
        PutObjectAclRequest.Builder bucket(String p0);
        PutObjectAclRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutObjectAclRequest.Builder checksumAlgorithm(String p0);
        PutObjectAclRequest.Builder contentMD5(String p0);
        PutObjectAclRequest.Builder expectedBucketOwner(String p0);
        PutObjectAclRequest.Builder grantFullControl(String p0);
        PutObjectAclRequest.Builder grantRead(String p0);
        PutObjectAclRequest.Builder grantReadACP(String p0);
        PutObjectAclRequest.Builder grantWrite(String p0);
        PutObjectAclRequest.Builder grantWriteACP(String p0);
        PutObjectAclRequest.Builder key(String p0);
        PutObjectAclRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutObjectAclRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutObjectAclRequest.Builder requestPayer(RequestPayer p0);
        PutObjectAclRequest.Builder requestPayer(String p0);
        PutObjectAclRequest.Builder versionId(String p0);
        default PutObjectAclRequest.Builder accessControlPolicy(java.util.function.Consumer<AccessControlPolicy.Builder> p0){ return null; }
    }
}
