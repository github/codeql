// Generated automatically from software.amazon.awssdk.services.s3.model.UploadPartRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class UploadPartRequest extends S3Request implements ToCopyableBuilder<UploadPartRequest.Builder, UploadPartRequest>
{
    protected UploadPartRequest() {}
    public UploadPartRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final Integer partNumber(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Long contentLength(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String checksumCRC32(){ return null; }
    public final String checksumCRC32C(){ return null; }
    public final String checksumSHA1(){ return null; }
    public final String checksumSHA256(){ return null; }
    public final String contentMD5(){ return null; }
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
    public static UploadPartRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends UploadPartRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<UploadPartRequest.Builder, UploadPartRequest>, S3Request.Builder, SdkPojo
    {
        UploadPartRequest.Builder bucket(String p0);
        UploadPartRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        UploadPartRequest.Builder checksumAlgorithm(String p0);
        UploadPartRequest.Builder checksumCRC32(String p0);
        UploadPartRequest.Builder checksumCRC32C(String p0);
        UploadPartRequest.Builder checksumSHA1(String p0);
        UploadPartRequest.Builder checksumSHA256(String p0);
        UploadPartRequest.Builder contentLength(Long p0);
        UploadPartRequest.Builder contentMD5(String p0);
        UploadPartRequest.Builder expectedBucketOwner(String p0);
        UploadPartRequest.Builder key(String p0);
        UploadPartRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        UploadPartRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        UploadPartRequest.Builder partNumber(Integer p0);
        UploadPartRequest.Builder requestPayer(RequestPayer p0);
        UploadPartRequest.Builder requestPayer(String p0);
        UploadPartRequest.Builder sseCustomerAlgorithm(String p0);
        UploadPartRequest.Builder sseCustomerKey(String p0);
        UploadPartRequest.Builder sseCustomerKeyMD5(String p0);
        UploadPartRequest.Builder uploadId(String p0);
    }
}
