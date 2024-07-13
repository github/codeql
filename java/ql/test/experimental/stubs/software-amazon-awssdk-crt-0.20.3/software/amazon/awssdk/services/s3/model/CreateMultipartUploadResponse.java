// Generated automatically from software.amazon.awssdk.services.s3.model.CreateMultipartUploadResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CreateMultipartUploadResponse extends S3Response implements ToCopyableBuilder<CreateMultipartUploadResponse.Builder, CreateMultipartUploadResponse>
{
    protected CreateMultipartUploadResponse() {}
    public CreateMultipartUploadResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final Instant abortDate(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final ServerSideEncryption serverSideEncryption(){ return null; }
    public final String abortRuleId(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String key(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String serverSideEncryptionAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String ssekmsEncryptionContext(){ return null; }
    public final String ssekmsKeyId(){ return null; }
    public final String toString(){ return null; }
    public final String uploadId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static CreateMultipartUploadResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends CreateMultipartUploadResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CreateMultipartUploadResponse.Builder, CreateMultipartUploadResponse>, S3Response.Builder, SdkPojo
    {
        CreateMultipartUploadResponse.Builder abortDate(Instant p0);
        CreateMultipartUploadResponse.Builder abortRuleId(String p0);
        CreateMultipartUploadResponse.Builder bucket(String p0);
        CreateMultipartUploadResponse.Builder bucketKeyEnabled(Boolean p0);
        CreateMultipartUploadResponse.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        CreateMultipartUploadResponse.Builder checksumAlgorithm(String p0);
        CreateMultipartUploadResponse.Builder key(String p0);
        CreateMultipartUploadResponse.Builder requestCharged(RequestCharged p0);
        CreateMultipartUploadResponse.Builder requestCharged(String p0);
        CreateMultipartUploadResponse.Builder serverSideEncryption(ServerSideEncryption p0);
        CreateMultipartUploadResponse.Builder serverSideEncryption(String p0);
        CreateMultipartUploadResponse.Builder sseCustomerAlgorithm(String p0);
        CreateMultipartUploadResponse.Builder sseCustomerKeyMD5(String p0);
        CreateMultipartUploadResponse.Builder ssekmsEncryptionContext(String p0);
        CreateMultipartUploadResponse.Builder ssekmsKeyId(String p0);
        CreateMultipartUploadResponse.Builder uploadId(String p0);
    }
}
