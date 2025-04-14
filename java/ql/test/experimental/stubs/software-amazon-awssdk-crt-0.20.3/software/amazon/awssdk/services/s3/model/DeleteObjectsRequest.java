// Generated automatically from software.amazon.awssdk.services.s3.model.DeleteObjectsRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.Delete;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DeleteObjectsRequest extends S3Request implements ToCopyableBuilder<DeleteObjectsRequest.Builder, DeleteObjectsRequest>
{
    protected DeleteObjectsRequest() {}
    public DeleteObjectsRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean bypassGovernanceRetention(){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final Delete delete(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String mfa(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static DeleteObjectsRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends DeleteObjectsRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DeleteObjectsRequest.Builder, DeleteObjectsRequest>, S3Request.Builder, SdkPojo
    {
        DeleteObjectsRequest.Builder bucket(String p0);
        DeleteObjectsRequest.Builder bypassGovernanceRetention(Boolean p0);
        DeleteObjectsRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        DeleteObjectsRequest.Builder checksumAlgorithm(String p0);
        DeleteObjectsRequest.Builder delete(Delete p0);
        DeleteObjectsRequest.Builder expectedBucketOwner(String p0);
        DeleteObjectsRequest.Builder mfa(String p0);
        DeleteObjectsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        DeleteObjectsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        DeleteObjectsRequest.Builder requestPayer(RequestPayer p0);
        DeleteObjectsRequest.Builder requestPayer(String p0);
        default DeleteObjectsRequest.Builder delete(java.util.function.Consumer<Delete.Builder> p0){ return null; }
    }
}
