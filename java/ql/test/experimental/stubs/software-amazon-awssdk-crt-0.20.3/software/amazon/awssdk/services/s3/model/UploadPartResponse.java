// Generated automatically from software.amazon.awssdk.services.s3.model.UploadPartResponse for testing purposes

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

public class UploadPartResponse extends S3Response implements ToCopyableBuilder<UploadPartResponse.Builder, UploadPartResponse>
{
    protected UploadPartResponse() {}
    public UploadPartResponse.Builder toBuilder(){ return null; }
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
    public final String requestChargedAsString(){ return null; }
    public final String serverSideEncryptionAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String ssekmsKeyId(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static UploadPartResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends UploadPartResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<UploadPartResponse.Builder, UploadPartResponse>, S3Response.Builder, SdkPojo
    {
        UploadPartResponse.Builder bucketKeyEnabled(Boolean p0);
        UploadPartResponse.Builder checksumCRC32(String p0);
        UploadPartResponse.Builder checksumCRC32C(String p0);
        UploadPartResponse.Builder checksumSHA1(String p0);
        UploadPartResponse.Builder checksumSHA256(String p0);
        UploadPartResponse.Builder eTag(String p0);
        UploadPartResponse.Builder requestCharged(RequestCharged p0);
        UploadPartResponse.Builder requestCharged(String p0);
        UploadPartResponse.Builder serverSideEncryption(ServerSideEncryption p0);
        UploadPartResponse.Builder serverSideEncryption(String p0);
        UploadPartResponse.Builder sseCustomerAlgorithm(String p0);
        UploadPartResponse.Builder sseCustomerKeyMD5(String p0);
        UploadPartResponse.Builder ssekmsKeyId(String p0);
    }
}
