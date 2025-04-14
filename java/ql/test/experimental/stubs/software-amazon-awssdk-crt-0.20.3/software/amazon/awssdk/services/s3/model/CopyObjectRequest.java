// Generated automatically from software.amazon.awssdk.services.s3.model.CopyObjectRequest for testing purposes

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
import software.amazon.awssdk.services.s3.model.MetadataDirective;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.ObjectLockLegalHoldStatus;
import software.amazon.awssdk.services.s3.model.ObjectLockMode;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.services.s3.model.Tagging;
import software.amazon.awssdk.services.s3.model.TaggingDirective;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CopyObjectRequest extends S3Request implements ToCopyableBuilder<CopyObjectRequest.Builder, CopyObjectRequest>
{
    protected CopyObjectRequest() {}
    public CopyObjectRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final Instant copySourceIfModifiedSince(){ return null; }
    public final Instant copySourceIfUnmodifiedSince(){ return null; }
    public final Instant expires(){ return null; }
    public final Instant objectLockRetainUntilDate(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Map<String, String> metadata(){ return null; }
    public final MetadataDirective metadataDirective(){ return null; }
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
    public final String copySource(){ return null; }
    public final String copySourceIfMatch(){ return null; }
    public final String copySourceIfNoneMatch(){ return null; }
    public final String copySourceSSECustomerAlgorithm(){ return null; }
    public final String copySourceSSECustomerKey(){ return null; }
    public final String copySourceSSECustomerKeyMD5(){ return null; }
    public final String destinationBucket(){ return null; }
    public final String destinationKey(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String expectedSourceBucketOwner(){ return null; }
    public final String grantFullControl(){ return null; }
    public final String grantRead(){ return null; }
    public final String grantReadACP(){ return null; }
    public final String grantWriteACP(){ return null; }
    public final String key(){ return null; }
    public final String metadataDirectiveAsString(){ return null; }
    public final String objectLockLegalHoldStatusAsString(){ return null; }
    public final String objectLockModeAsString(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String serverSideEncryptionAsString(){ return null; }
    public final String sourceBucket(){ return null; }
    public final String sourceKey(){ return null; }
    public final String sourceVersionId(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKey(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String ssekmsEncryptionContext(){ return null; }
    public final String ssekmsKeyId(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String tagging(){ return null; }
    public final String taggingDirectiveAsString(){ return null; }
    public final String toString(){ return null; }
    public final String websiteRedirectLocation(){ return null; }
    public final TaggingDirective taggingDirective(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasMetadata(){ return false; }
    public final int hashCode(){ return 0; }
    public static CopyObjectRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends CopyObjectRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CopyObjectRequest.Builder, CopyObjectRequest>, S3Request.Builder, SdkPojo
    {
        CopyObjectRequest.Builder acl(ObjectCannedACL p0);
        CopyObjectRequest.Builder acl(String p0);
        CopyObjectRequest.Builder bucket(String p0);
        CopyObjectRequest.Builder bucketKeyEnabled(Boolean p0);
        CopyObjectRequest.Builder cacheControl(String p0);
        CopyObjectRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        CopyObjectRequest.Builder checksumAlgorithm(String p0);
        CopyObjectRequest.Builder contentDisposition(String p0);
        CopyObjectRequest.Builder contentEncoding(String p0);
        CopyObjectRequest.Builder contentLanguage(String p0);
        CopyObjectRequest.Builder contentType(String p0);
        CopyObjectRequest.Builder copySource(String p0);
        CopyObjectRequest.Builder copySourceIfMatch(String p0);
        CopyObjectRequest.Builder copySourceIfModifiedSince(Instant p0);
        CopyObjectRequest.Builder copySourceIfNoneMatch(String p0);
        CopyObjectRequest.Builder copySourceIfUnmodifiedSince(Instant p0);
        CopyObjectRequest.Builder copySourceSSECustomerAlgorithm(String p0);
        CopyObjectRequest.Builder copySourceSSECustomerKey(String p0);
        CopyObjectRequest.Builder copySourceSSECustomerKeyMD5(String p0);
        CopyObjectRequest.Builder destinationBucket(String p0);
        CopyObjectRequest.Builder destinationKey(String p0);
        CopyObjectRequest.Builder expectedBucketOwner(String p0);
        CopyObjectRequest.Builder expectedSourceBucketOwner(String p0);
        CopyObjectRequest.Builder expires(Instant p0);
        CopyObjectRequest.Builder grantFullControl(String p0);
        CopyObjectRequest.Builder grantRead(String p0);
        CopyObjectRequest.Builder grantReadACP(String p0);
        CopyObjectRequest.Builder grantWriteACP(String p0);
        CopyObjectRequest.Builder key(String p0);
        CopyObjectRequest.Builder metadata(Map<String, String> p0);
        CopyObjectRequest.Builder metadataDirective(MetadataDirective p0);
        CopyObjectRequest.Builder metadataDirective(String p0);
        CopyObjectRequest.Builder objectLockLegalHoldStatus(ObjectLockLegalHoldStatus p0);
        CopyObjectRequest.Builder objectLockLegalHoldStatus(String p0);
        CopyObjectRequest.Builder objectLockMode(ObjectLockMode p0);
        CopyObjectRequest.Builder objectLockMode(String p0);
        CopyObjectRequest.Builder objectLockRetainUntilDate(Instant p0);
        CopyObjectRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        CopyObjectRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        CopyObjectRequest.Builder requestPayer(RequestPayer p0);
        CopyObjectRequest.Builder requestPayer(String p0);
        CopyObjectRequest.Builder serverSideEncryption(ServerSideEncryption p0);
        CopyObjectRequest.Builder serverSideEncryption(String p0);
        CopyObjectRequest.Builder sourceBucket(String p0);
        CopyObjectRequest.Builder sourceKey(String p0);
        CopyObjectRequest.Builder sourceVersionId(String p0);
        CopyObjectRequest.Builder sseCustomerAlgorithm(String p0);
        CopyObjectRequest.Builder sseCustomerKey(String p0);
        CopyObjectRequest.Builder sseCustomerKeyMD5(String p0);
        CopyObjectRequest.Builder ssekmsEncryptionContext(String p0);
        CopyObjectRequest.Builder ssekmsKeyId(String p0);
        CopyObjectRequest.Builder storageClass(StorageClass p0);
        CopyObjectRequest.Builder storageClass(String p0);
        CopyObjectRequest.Builder tagging(String p0);
        CopyObjectRequest.Builder tagging(Tagging p0);
        CopyObjectRequest.Builder taggingDirective(String p0);
        CopyObjectRequest.Builder taggingDirective(TaggingDirective p0);
        CopyObjectRequest.Builder websiteRedirectLocation(String p0);
    }
}
