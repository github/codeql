// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutObjectResponse extends S3Response implements ToCopyableBuilder<PutObjectResponse.Builder, PutObjectResponse>
{
    protected PutObjectResponse() {}
    public PutObjectResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final ServerSideEncryption serverSideEncryption(){ return null; }
    public final String checksumCRC32(){ return null; }
    public final String checksumCRC32C(){ return null; }
    public final String checksumSHA1(){ return null; }
    public final String checksumSHA256(){ return null; }
    public final String eTag(){ return null; }
    public final String expiration(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String serverSideEncryptionAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String ssekmsEncryptionContext(){ return null; }
    public final String ssekmsKeyId(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutObjectResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectResponse.Builder, PutObjectResponse>, S3Response.Builder, SdkPojo
    {
        PutObjectResponse.Builder bucketKeyEnabled(Boolean p0);
        PutObjectResponse.Builder checksumCRC32(String p0);
        PutObjectResponse.Builder checksumCRC32C(String p0);
        PutObjectResponse.Builder checksumSHA1(String p0);
        PutObjectResponse.Builder checksumSHA256(String p0);
        PutObjectResponse.Builder eTag(String p0);
        PutObjectResponse.Builder expiration(String p0);
        PutObjectResponse.Builder requestCharged(RequestCharged p0);
        PutObjectResponse.Builder requestCharged(String p0);
        PutObjectResponse.Builder serverSideEncryption(ServerSideEncryption p0);
        PutObjectResponse.Builder serverSideEncryption(String p0);
        PutObjectResponse.Builder sseCustomerAlgorithm(String p0);
        PutObjectResponse.Builder sseCustomerKeyMD5(String p0);
        PutObjectResponse.Builder ssekmsEncryptionContext(String p0);
        PutObjectResponse.Builder ssekmsKeyId(String p0);
        PutObjectResponse.Builder versionId(String p0);
    }
}
