// Generated automatically from software.amazon.awssdk.services.s3.model.HeadObjectResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ArchiveStatus;
import software.amazon.awssdk.services.s3.model.ObjectLockLegalHoldStatus;
import software.amazon.awssdk.services.s3.model.ObjectLockMode;
import software.amazon.awssdk.services.s3.model.ReplicationStatus;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class HeadObjectResponse extends S3Response implements ToCopyableBuilder<HeadObjectResponse.Builder, HeadObjectResponse>
{
    protected HeadObjectResponse() {}
    public HeadObjectResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ArchiveStatus archiveStatus(){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final Boolean deleteMarker(){ return null; }
    public final Instant expires(){ return null; }
    public final Instant lastModified(){ return null; }
    public final Instant objectLockRetainUntilDate(){ return null; }
    public final Integer missingMeta(){ return null; }
    public final Integer partsCount(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Long contentLength(){ return null; }
    public final Map<String, String> metadata(){ return null; }
    public final ObjectLockLegalHoldStatus objectLockLegalHoldStatus(){ return null; }
    public final ObjectLockMode objectLockMode(){ return null; }
    public final ReplicationStatus replicationStatus(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final ServerSideEncryption serverSideEncryption(){ return null; }
    public final StorageClass storageClass(){ return null; }
    public final String acceptRanges(){ return null; }
    public final String archiveStatusAsString(){ return null; }
    public final String cacheControl(){ return null; }
    public final String checksumCRC32(){ return null; }
    public final String checksumCRC32C(){ return null; }
    public final String checksumSHA1(){ return null; }
    public final String checksumSHA256(){ return null; }
    public final String contentDisposition(){ return null; }
    public final String contentEncoding(){ return null; }
    public final String contentLanguage(){ return null; }
    public final String contentType(){ return null; }
    public final String eTag(){ return null; }
    public final String expiration(){ return null; }
    public final String objectLockLegalHoldStatusAsString(){ return null; }
    public final String objectLockModeAsString(){ return null; }
    public final String replicationStatusAsString(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String restore(){ return null; }
    public final String serverSideEncryptionAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String ssekmsKeyId(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final String websiteRedirectLocation(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasMetadata(){ return false; }
    public final int hashCode(){ return 0; }
    public static HeadObjectResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends HeadObjectResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<HeadObjectResponse.Builder, HeadObjectResponse>, S3Response.Builder, SdkPojo
    {
        HeadObjectResponse.Builder acceptRanges(String p0);
        HeadObjectResponse.Builder archiveStatus(ArchiveStatus p0);
        HeadObjectResponse.Builder archiveStatus(String p0);
        HeadObjectResponse.Builder bucketKeyEnabled(Boolean p0);
        HeadObjectResponse.Builder cacheControl(String p0);
        HeadObjectResponse.Builder checksumCRC32(String p0);
        HeadObjectResponse.Builder checksumCRC32C(String p0);
        HeadObjectResponse.Builder checksumSHA1(String p0);
        HeadObjectResponse.Builder checksumSHA256(String p0);
        HeadObjectResponse.Builder contentDisposition(String p0);
        HeadObjectResponse.Builder contentEncoding(String p0);
        HeadObjectResponse.Builder contentLanguage(String p0);
        HeadObjectResponse.Builder contentLength(Long p0);
        HeadObjectResponse.Builder contentType(String p0);
        HeadObjectResponse.Builder deleteMarker(Boolean p0);
        HeadObjectResponse.Builder eTag(String p0);
        HeadObjectResponse.Builder expiration(String p0);
        HeadObjectResponse.Builder expires(Instant p0);
        HeadObjectResponse.Builder lastModified(Instant p0);
        HeadObjectResponse.Builder metadata(Map<String, String> p0);
        HeadObjectResponse.Builder missingMeta(Integer p0);
        HeadObjectResponse.Builder objectLockLegalHoldStatus(ObjectLockLegalHoldStatus p0);
        HeadObjectResponse.Builder objectLockLegalHoldStatus(String p0);
        HeadObjectResponse.Builder objectLockMode(ObjectLockMode p0);
        HeadObjectResponse.Builder objectLockMode(String p0);
        HeadObjectResponse.Builder objectLockRetainUntilDate(Instant p0);
        HeadObjectResponse.Builder partsCount(Integer p0);
        HeadObjectResponse.Builder replicationStatus(ReplicationStatus p0);
        HeadObjectResponse.Builder replicationStatus(String p0);
        HeadObjectResponse.Builder requestCharged(RequestCharged p0);
        HeadObjectResponse.Builder requestCharged(String p0);
        HeadObjectResponse.Builder restore(String p0);
        HeadObjectResponse.Builder serverSideEncryption(ServerSideEncryption p0);
        HeadObjectResponse.Builder serverSideEncryption(String p0);
        HeadObjectResponse.Builder sseCustomerAlgorithm(String p0);
        HeadObjectResponse.Builder sseCustomerKeyMD5(String p0);
        HeadObjectResponse.Builder ssekmsKeyId(String p0);
        HeadObjectResponse.Builder storageClass(StorageClass p0);
        HeadObjectResponse.Builder storageClass(String p0);
        HeadObjectResponse.Builder versionId(String p0);
        HeadObjectResponse.Builder websiteRedirectLocation(String p0);
    }
}
