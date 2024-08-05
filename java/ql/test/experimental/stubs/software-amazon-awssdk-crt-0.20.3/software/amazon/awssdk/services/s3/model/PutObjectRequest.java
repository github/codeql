// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectRequest for testing purposes

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

public class PutObjectRequest extends S3Request implements ToCopyableBuilder<PutObjectRequest.Builder, PutObjectRequest>
{
    protected PutObjectRequest() {}
    public PutObjectRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final Instant expires(){ return null; }
    public final Instant objectLockRetainUntilDate(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Long contentLength(){ return null; }
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
    public final String checksumCRC32(){ return null; }
    public final String checksumCRC32C(){ return null; }
    public final String checksumSHA1(){ return null; }
    public final String checksumSHA256(){ return null; }
    public final String contentDisposition(){ return null; }
    public final String contentEncoding(){ return null; }
    public final String contentLanguage(){ return null; }
    public final String contentMD5(){ return null; }
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
    public static PutObjectRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectRequest.Builder, PutObjectRequest>, S3Request.Builder, SdkPojo
    {
        PutObjectRequest.Builder acl(ObjectCannedACL p0);
        PutObjectRequest.Builder acl(String p0);
        PutObjectRequest.Builder bucket(String p0);
        PutObjectRequest.Builder bucketKeyEnabled(Boolean p0);
        PutObjectRequest.Builder cacheControl(String p0);
        PutObjectRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutObjectRequest.Builder checksumAlgorithm(String p0);
        PutObjectRequest.Builder checksumCRC32(String p0);
        PutObjectRequest.Builder checksumCRC32C(String p0);
        PutObjectRequest.Builder checksumSHA1(String p0);
        PutObjectRequest.Builder checksumSHA256(String p0);
        PutObjectRequest.Builder contentDisposition(String p0);
        PutObjectRequest.Builder contentEncoding(String p0);
        PutObjectRequest.Builder contentLanguage(String p0);
        PutObjectRequest.Builder contentLength(Long p0);
        PutObjectRequest.Builder contentMD5(String p0);
        PutObjectRequest.Builder contentType(String p0);
        PutObjectRequest.Builder expectedBucketOwner(String p0);
        PutObjectRequest.Builder expires(Instant p0);
        PutObjectRequest.Builder grantFullControl(String p0);
        PutObjectRequest.Builder grantRead(String p0);
        PutObjectRequest.Builder grantReadACP(String p0);
        PutObjectRequest.Builder grantWriteACP(String p0);
        PutObjectRequest.Builder key(String p0);
        PutObjectRequest.Builder metadata(Map<String, String> p0);
        PutObjectRequest.Builder objectLockLegalHoldStatus(ObjectLockLegalHoldStatus p0);
        PutObjectRequest.Builder objectLockLegalHoldStatus(String p0);
        PutObjectRequest.Builder objectLockMode(ObjectLockMode p0);
        PutObjectRequest.Builder objectLockMode(String p0);
        PutObjectRequest.Builder objectLockRetainUntilDate(Instant p0);
        PutObjectRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutObjectRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutObjectRequest.Builder requestPayer(RequestPayer p0);
        PutObjectRequest.Builder requestPayer(String p0);
        PutObjectRequest.Builder serverSideEncryption(ServerSideEncryption p0);
        PutObjectRequest.Builder serverSideEncryption(String p0);
        PutObjectRequest.Builder sseCustomerAlgorithm(String p0);
        PutObjectRequest.Builder sseCustomerKey(String p0);
        PutObjectRequest.Builder sseCustomerKeyMD5(String p0);
        PutObjectRequest.Builder ssekmsEncryptionContext(String p0);
        PutObjectRequest.Builder ssekmsKeyId(String p0);
        PutObjectRequest.Builder storageClass(StorageClass p0);
        PutObjectRequest.Builder storageClass(String p0);
        PutObjectRequest.Builder tagging(String p0);
        PutObjectRequest.Builder tagging(Tagging p0);
        PutObjectRequest.Builder websiteRedirectLocation(String p0);
    }
}
