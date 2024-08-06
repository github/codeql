// Generated automatically from software.amazon.awssdk.services.s3.model.UploadPartCopyResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CopyPartResult;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class UploadPartCopyResponse extends S3Response implements ToCopyableBuilder<UploadPartCopyResponse.Builder, UploadPartCopyResponse>
{
    protected UploadPartCopyResponse() {}
    public UploadPartCopyResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final CopyPartResult copyPartResult(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final ServerSideEncryption serverSideEncryption(){ return null; }
    public final String copySourceVersionId(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String serverSideEncryptionAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String ssekmsKeyId(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static UploadPartCopyResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends UploadPartCopyResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<UploadPartCopyResponse.Builder, UploadPartCopyResponse>, S3Response.Builder, SdkPojo
    {
        UploadPartCopyResponse.Builder bucketKeyEnabled(Boolean p0);
        UploadPartCopyResponse.Builder copyPartResult(CopyPartResult p0);
        UploadPartCopyResponse.Builder copySourceVersionId(String p0);
        UploadPartCopyResponse.Builder requestCharged(RequestCharged p0);
        UploadPartCopyResponse.Builder requestCharged(String p0);
        UploadPartCopyResponse.Builder serverSideEncryption(ServerSideEncryption p0);
        UploadPartCopyResponse.Builder serverSideEncryption(String p0);
        UploadPartCopyResponse.Builder sseCustomerAlgorithm(String p0);
        UploadPartCopyResponse.Builder sseCustomerKeyMD5(String p0);
        UploadPartCopyResponse.Builder ssekmsKeyId(String p0);
        default UploadPartCopyResponse.Builder copyPartResult(java.util.function.Consumer<CopyPartResult.Builder> p0){ return null; }
    }
}
