// Generated automatically from software.amazon.awssdk.services.s3.model.CreateMultipartUploadRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.ObjectLockLegalHoldStatus;
import software.amazon.awssdk.services.s3.model.ObjectLockMode;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.services.s3.model.Tagging;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CreateMultipartUploadRequest extends S3Request implements ToCopyableBuilder<CreateMultipartUploadRequest.Builder, CreateMultipartUploadRequest>
{
    protected CreateMultipartUploadRequest() {}
    public CreateMultipartUploadRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final Instant expires(){ return null; }
    public final Instant objectLockRetainUntilDate(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Map<String, String> metadata(){ return null; }
    public final ObjectCannedACL acl(){ return null; }
    public final ObjectLockLegalHoldStatus objectLockLegalHoldStatus(){ return null; }
    public final ObjectLockMode objectLockMode(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final ServerSideEncryption serverSideEncryption(){ return null; }
    public final StorageClass storageClass(){ return null; }
    public final String aclAsString(){ return null; }
    public final String bucket(){ return null; }
    public final String cacheControl(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentDisposition(){ return null; }
    public final String contentEncoding(){ return null; }
    public final String contentLanguage(){ return null; }
    public final String contentType(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String grantFullControl(){ return null; }
    public final String grantRead(){ return null; }
    public final String grantReadACP(){ return null; }
    public final String grantWriteACP(){ return null; }
    public final String key(){ return null; }
    public final String objectLockLegalHoldStatusAsString(){ return null; }
    public final String objectLockModeAsString(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String serverSideEncryptionAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKey(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String ssekmsEncryptionContext(){ return null; }
    public final String ssekmsKeyId(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String tagging(){ return null; }
    public final String toString(){ return null; }
    public final String websiteRedirectLocation(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasMetadata(){ return false; }
    public final int hashCode(){ return 0; }
    public static CreateMultipartUploadRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends CreateMultipartUploadRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CreateMultipartUploadRequest.Builder, CreateMultipartUploadRequest>, S3Request.Builder, SdkPojo
    {
        CreateMultipartUploadRequest.Builder acl(ObjectCannedACL p0);
        CreateMultipartUploadRequest.Builder acl(String p0);
        CreateMultipartUploadRequest.Builder bucket(String p0);
        CreateMultipartUploadRequest.Builder bucketKeyEnabled(Boolean p0);
        CreateMultipartUploadRequest.Builder cacheControl(String p0);
        CreateMultipartUploadRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        CreateMultipartUploadRequest.Builder checksumAlgorithm(String p0);
        CreateMultipartUploadRequest.Builder contentDisposition(String p0);
        CreateMultipartUploadRequest.Builder contentEncoding(String p0);
        CreateMultipartUploadRequest.Builder contentLanguage(String p0);
        CreateMultipartUploadRequest.Builder contentType(String p0);
        CreateMultipartUploadRequest.Builder expectedBucketOwner(String p0);
        CreateMultipartUploadRequest.Builder expires(Instant p0);
        CreateMultipartUploadRequest.Builder grantFullControl(String p0);
        CreateMultipartUploadRequest.Builder grantRead(String p0);
        CreateMultipartUploadRequest.Builder grantReadACP(String p0);
        CreateMultipartUploadRequest.Builder grantWriteACP(String p0);
        CreateMultipartUploadRequest.Builder key(String p0);
        CreateMultipartUploadRequest.Builder metadata(Map<String, String> p0);
        CreateMultipartUploadRequest.Builder objectLockLegalHoldStatus(ObjectLockLegalHoldStatus p0);
        CreateMultipartUploadRequest.Builder objectLockLegalHoldStatus(String p0);
        CreateMultipartUploadRequest.Builder objectLockMode(ObjectLockMode p0);
        CreateMultipartUploadRequest.Builder objectLockMode(String p0);
        CreateMultipartUploadRequest.Builder objectLockRetainUntilDate(Instant p0);
        CreateMultipartUploadRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        CreateMultipartUploadRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        CreateMultipartUploadRequest.Builder requestPayer(RequestPayer p0);
        CreateMultipartUploadRequest.Builder requestPayer(String p0);
        CreateMultipartUploadRequest.Builder serverSideEncryption(ServerSideEncryption p0);
        CreateMultipartUploadRequest.Builder serverSideEncryption(String p0);
        CreateMultipartUploadRequest.Builder sseCustomerAlgorithm(String p0);
        CreateMultipartUploadRequest.Builder sseCustomerKey(String p0);
        CreateMultipartUploadRequest.Builder sseCustomerKeyMD5(String p0);
        CreateMultipartUploadRequest.Builder ssekmsEncryptionContext(String p0);
        CreateMultipartUploadRequest.Builder ssekmsKeyId(String p0);
        CreateMultipartUploadRequest.Builder storageClass(StorageClass p0);
        CreateMultipartUploadRequest.Builder storageClass(String p0);
        CreateMultipartUploadRequest.Builder tagging(String p0);
        CreateMultipartUploadRequest.Builder tagging(Tagging p0);
        CreateMultipartUploadRequest.Builder websiteRedirectLocation(String p0);
    }
}
