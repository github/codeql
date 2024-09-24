// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumMode;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectRequest extends S3Request implements ToCopyableBuilder<GetObjectRequest.Builder, GetObjectRequest>
{
    protected GetObjectRequest() {}
    public GetObjectRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumMode checksumMode(){ return null; }
    public final Instant ifModifiedSince(){ return null; }
    public final Instant ifUnmodifiedSince(){ return null; }
    public final Instant responseExpires(){ return null; }
    public final Integer partNumber(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumModeAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String ifMatch(){ return null; }
    public final String ifNoneMatch(){ return null; }
    public final String key(){ return null; }
    public final String range(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String responseCacheControl(){ return null; }
    public final String responseContentDisposition(){ return null; }
    public final String responseContentEncoding(){ return null; }
    public final String responseContentLanguage(){ return null; }
    public final String responseContentType(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKey(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectRequest.Builder, GetObjectRequest>, S3Request.Builder, SdkPojo
    {
        GetObjectRequest.Builder bucket(String p0);
        GetObjectRequest.Builder checksumMode(ChecksumMode p0);
        GetObjectRequest.Builder checksumMode(String p0);
        GetObjectRequest.Builder expectedBucketOwner(String p0);
        GetObjectRequest.Builder ifMatch(String p0);
        GetObjectRequest.Builder ifModifiedSince(Instant p0);
        GetObjectRequest.Builder ifNoneMatch(String p0);
        GetObjectRequest.Builder ifUnmodifiedSince(Instant p0);
        GetObjectRequest.Builder key(String p0);
        GetObjectRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        GetObjectRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        GetObjectRequest.Builder partNumber(Integer p0);
        GetObjectRequest.Builder range(String p0);
        GetObjectRequest.Builder requestPayer(RequestPayer p0);
        GetObjectRequest.Builder requestPayer(String p0);
        GetObjectRequest.Builder responseCacheControl(String p0);
        GetObjectRequest.Builder responseContentDisposition(String p0);
        GetObjectRequest.Builder responseContentEncoding(String p0);
        GetObjectRequest.Builder responseContentLanguage(String p0);
        GetObjectRequest.Builder responseContentType(String p0);
        GetObjectRequest.Builder responseExpires(Instant p0);
        GetObjectRequest.Builder sseCustomerAlgorithm(String p0);
        GetObjectRequest.Builder sseCustomerKey(String p0);
        GetObjectRequest.Builder sseCustomerKeyMD5(String p0);
        GetObjectRequest.Builder versionId(String p0);
    }
}
