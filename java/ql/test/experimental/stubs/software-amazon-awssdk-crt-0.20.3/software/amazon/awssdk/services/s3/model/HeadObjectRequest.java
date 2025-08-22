// Generated automatically from software.amazon.awssdk.services.s3.model.HeadObjectRequest for testing purposes

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

public class HeadObjectRequest extends S3Request implements ToCopyableBuilder<HeadObjectRequest.Builder, HeadObjectRequest>
{
    protected HeadObjectRequest() {}
    public HeadObjectRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumMode checksumMode(){ return null; }
    public final Instant ifModifiedSince(){ return null; }
    public final Instant ifUnmodifiedSince(){ return null; }
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
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKey(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static HeadObjectRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends HeadObjectRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<HeadObjectRequest.Builder, HeadObjectRequest>, S3Request.Builder, SdkPojo
    {
        HeadObjectRequest.Builder bucket(String p0);
        HeadObjectRequest.Builder checksumMode(ChecksumMode p0);
        HeadObjectRequest.Builder checksumMode(String p0);
        HeadObjectRequest.Builder expectedBucketOwner(String p0);
        HeadObjectRequest.Builder ifMatch(String p0);
        HeadObjectRequest.Builder ifModifiedSince(Instant p0);
        HeadObjectRequest.Builder ifNoneMatch(String p0);
        HeadObjectRequest.Builder ifUnmodifiedSince(Instant p0);
        HeadObjectRequest.Builder key(String p0);
        HeadObjectRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        HeadObjectRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        HeadObjectRequest.Builder partNumber(Integer p0);
        HeadObjectRequest.Builder range(String p0);
        HeadObjectRequest.Builder requestPayer(RequestPayer p0);
        HeadObjectRequest.Builder requestPayer(String p0);
        HeadObjectRequest.Builder sseCustomerAlgorithm(String p0);
        HeadObjectRequest.Builder sseCustomerKey(String p0);
        HeadObjectRequest.Builder sseCustomerKeyMD5(String p0);
        HeadObjectRequest.Builder versionId(String p0);
    }
}
