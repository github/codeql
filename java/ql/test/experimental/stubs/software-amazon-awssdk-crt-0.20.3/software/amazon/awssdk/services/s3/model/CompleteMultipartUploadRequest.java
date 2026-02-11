// Generated automatically from software.amazon.awssdk.services.s3.model.CompleteMultipartUploadRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CompletedMultipartUpload;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CompleteMultipartUploadRequest extends S3Request implements ToCopyableBuilder<CompleteMultipartUploadRequest.Builder, CompleteMultipartUploadRequest>
{
    protected CompleteMultipartUploadRequest() {}
    public CompleteMultipartUploadRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final CompletedMultipartUpload multipartUpload(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumCRC32(){ return null; }
    public final String checksumCRC32C(){ return null; }
    public final String checksumSHA1(){ return null; }
    public final String checksumSHA256(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKey(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String toString(){ return null; }
    public final String uploadId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static CompleteMultipartUploadRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends CompleteMultipartUploadRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CompleteMultipartUploadRequest.Builder, CompleteMultipartUploadRequest>, S3Request.Builder, SdkPojo
    {
        CompleteMultipartUploadRequest.Builder bucket(String p0);
        CompleteMultipartUploadRequest.Builder checksumCRC32(String p0);
        CompleteMultipartUploadRequest.Builder checksumCRC32C(String p0);
        CompleteMultipartUploadRequest.Builder checksumSHA1(String p0);
        CompleteMultipartUploadRequest.Builder checksumSHA256(String p0);
        CompleteMultipartUploadRequest.Builder expectedBucketOwner(String p0);
        CompleteMultipartUploadRequest.Builder key(String p0);
        CompleteMultipartUploadRequest.Builder multipartUpload(CompletedMultipartUpload p0);
        CompleteMultipartUploadRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        CompleteMultipartUploadRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        CompleteMultipartUploadRequest.Builder requestPayer(RequestPayer p0);
        CompleteMultipartUploadRequest.Builder requestPayer(String p0);
        CompleteMultipartUploadRequest.Builder sseCustomerAlgorithm(String p0);
        CompleteMultipartUploadRequest.Builder sseCustomerKey(String p0);
        CompleteMultipartUploadRequest.Builder sseCustomerKeyMD5(String p0);
        CompleteMultipartUploadRequest.Builder uploadId(String p0);
        default CompleteMultipartUploadRequest.Builder multipartUpload(java.util.function.Consumer<CompletedMultipartUpload.Builder> p0){ return null; }
    }
}
