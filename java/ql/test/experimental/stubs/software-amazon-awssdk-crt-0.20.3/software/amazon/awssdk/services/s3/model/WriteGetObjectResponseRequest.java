// Generated automatically from software.amazon.awssdk.services.s3.model.WriteGetObjectResponseRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectLockLegalHoldStatus;
import software.amazon.awssdk.services.s3.model.ObjectLockMode;
import software.amazon.awssdk.services.s3.model.ReplicationStatus;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.services.s3.model.StorageClass;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class WriteGetObjectResponseRequest extends S3Request implements ToCopyableBuilder<WriteGetObjectResponseRequest.Builder, WriteGetObjectResponseRequest>
{
    protected WriteGetObjectResponseRequest() {}
    public WriteGetObjectResponseRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final Boolean deleteMarker(){ return null; }
    public final Instant expires(){ return null; }
    public final Instant lastModified(){ return null; }
    public final Instant objectLockRetainUntilDate(){ return null; }
    public final Integer missingMeta(){ return null; }
    public final Integer partsCount(){ return null; }
    public final Integer statusCode(){ return null; }
    public final Integer tagCount(){ return null; }
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
    public final String cacheControl(){ return null; }
    public final String checksumCRC32(){ return null; }
    public final String checksumCRC32C(){ return null; }
    public final String checksumSHA1(){ return null; }
    public final String checksumSHA256(){ return null; }
    public final String contentDisposition(){ return null; }
    public final String contentEncoding(){ return null; }
    public final String contentLanguage(){ return null; }
    public final String contentRange(){ return null; }
    public final String contentType(){ return null; }
    public final String eTag(){ return null; }
    public final String errorCode(){ return null; }
    public final String errorMessage(){ return null; }
    public final String expiration(){ return null; }
    public final String objectLockLegalHoldStatusAsString(){ return null; }
    public final String objectLockModeAsString(){ return null; }
    public final String replicationStatusAsString(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String requestRoute(){ return null; }
    public final String requestToken(){ return null; }
    public final String restore(){ return null; }
    public final String serverSideEncryptionAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String ssekmsKeyId(){ return null; }
    public final String storageClassAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasMetadata(){ return false; }
    public final int hashCode(){ return 0; }
    public static WriteGetObjectResponseRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends WriteGetObjectResponseRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<WriteGetObjectResponseRequest.Builder, WriteGetObjectResponseRequest>, S3Request.Builder, SdkPojo
    {
        WriteGetObjectResponseRequest.Builder acceptRanges(String p0);
        WriteGetObjectResponseRequest.Builder bucketKeyEnabled(Boolean p0);
        WriteGetObjectResponseRequest.Builder cacheControl(String p0);
        WriteGetObjectResponseRequest.Builder checksumCRC32(String p0);
        WriteGetObjectResponseRequest.Builder checksumCRC32C(String p0);
        WriteGetObjectResponseRequest.Builder checksumSHA1(String p0);
        WriteGetObjectResponseRequest.Builder checksumSHA256(String p0);
        WriteGetObjectResponseRequest.Builder contentDisposition(String p0);
        WriteGetObjectResponseRequest.Builder contentEncoding(String p0);
        WriteGetObjectResponseRequest.Builder contentLanguage(String p0);
        WriteGetObjectResponseRequest.Builder contentLength(Long p0);
        WriteGetObjectResponseRequest.Builder contentRange(String p0);
        WriteGetObjectResponseRequest.Builder contentType(String p0);
        WriteGetObjectResponseRequest.Builder deleteMarker(Boolean p0);
        WriteGetObjectResponseRequest.Builder eTag(String p0);
        WriteGetObjectResponseRequest.Builder errorCode(String p0);
        WriteGetObjectResponseRequest.Builder errorMessage(String p0);
        WriteGetObjectResponseRequest.Builder expiration(String p0);
        WriteGetObjectResponseRequest.Builder expires(Instant p0);
        WriteGetObjectResponseRequest.Builder lastModified(Instant p0);
        WriteGetObjectResponseRequest.Builder metadata(Map<String, String> p0);
        WriteGetObjectResponseRequest.Builder missingMeta(Integer p0);
        WriteGetObjectResponseRequest.Builder objectLockLegalHoldStatus(ObjectLockLegalHoldStatus p0);
        WriteGetObjectResponseRequest.Builder objectLockLegalHoldStatus(String p0);
        WriteGetObjectResponseRequest.Builder objectLockMode(ObjectLockMode p0);
        WriteGetObjectResponseRequest.Builder objectLockMode(String p0);
        WriteGetObjectResponseRequest.Builder objectLockRetainUntilDate(Instant p0);
        WriteGetObjectResponseRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        WriteGetObjectResponseRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        WriteGetObjectResponseRequest.Builder partsCount(Integer p0);
        WriteGetObjectResponseRequest.Builder replicationStatus(ReplicationStatus p0);
        WriteGetObjectResponseRequest.Builder replicationStatus(String p0);
        WriteGetObjectResponseRequest.Builder requestCharged(RequestCharged p0);
        WriteGetObjectResponseRequest.Builder requestCharged(String p0);
        WriteGetObjectResponseRequest.Builder requestRoute(String p0);
        WriteGetObjectResponseRequest.Builder requestToken(String p0);
        WriteGetObjectResponseRequest.Builder restore(String p0);
        WriteGetObjectResponseRequest.Builder serverSideEncryption(ServerSideEncryption p0);
        WriteGetObjectResponseRequest.Builder serverSideEncryption(String p0);
        WriteGetObjectResponseRequest.Builder sseCustomerAlgorithm(String p0);
        WriteGetObjectResponseRequest.Builder sseCustomerKeyMD5(String p0);
        WriteGetObjectResponseRequest.Builder ssekmsKeyId(String p0);
        WriteGetObjectResponseRequest.Builder statusCode(Integer p0);
        WriteGetObjectResponseRequest.Builder storageClass(StorageClass p0);
        WriteGetObjectResponseRequest.Builder storageClass(String p0);
        WriteGetObjectResponseRequest.Builder tagCount(Integer p0);
        WriteGetObjectResponseRequest.Builder versionId(String p0);
    }
}
