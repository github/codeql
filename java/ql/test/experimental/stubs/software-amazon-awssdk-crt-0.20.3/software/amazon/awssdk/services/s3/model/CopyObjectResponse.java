// Generated automatically from software.amazon.awssdk.services.s3.model.CopyObjectResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CopyObjectResult;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CopyObjectResponse extends S3Response implements ToCopyableBuilder<CopyObjectResponse.Builder, CopyObjectResponse>
{
    protected CopyObjectResponse() {}
    public CopyObjectResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bucketKeyEnabled(){ return null; }
    public final CopyObjectResult copyObjectResult(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final ServerSideEncryption serverSideEncryption(){ return null; }
    public final String copySourceVersionId(){ return null; }
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
    public static CopyObjectResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends CopyObjectResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CopyObjectResponse.Builder, CopyObjectResponse>, S3Response.Builder, SdkPojo
    {
        CopyObjectResponse.Builder bucketKeyEnabled(Boolean p0);
        CopyObjectResponse.Builder copyObjectResult(CopyObjectResult p0);
        CopyObjectResponse.Builder copySourceVersionId(String p0);
        CopyObjectResponse.Builder expiration(String p0);
        CopyObjectResponse.Builder requestCharged(RequestCharged p0);
        CopyObjectResponse.Builder requestCharged(String p0);
        CopyObjectResponse.Builder serverSideEncryption(ServerSideEncryption p0);
        CopyObjectResponse.Builder serverSideEncryption(String p0);
        CopyObjectResponse.Builder sseCustomerAlgorithm(String p0);
        CopyObjectResponse.Builder sseCustomerKeyMD5(String p0);
        CopyObjectResponse.Builder ssekmsEncryptionContext(String p0);
        CopyObjectResponse.Builder ssekmsKeyId(String p0);
        CopyObjectResponse.Builder versionId(String p0);
        default CopyObjectResponse.Builder copyObjectResult(java.util.function.Consumer<CopyObjectResult.Builder> p0){ return null; }
    }
}
