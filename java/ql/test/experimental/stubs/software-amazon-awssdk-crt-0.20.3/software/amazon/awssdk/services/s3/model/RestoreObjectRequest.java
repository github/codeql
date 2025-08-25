// Generated automatically from software.amazon.awssdk.services.s3.model.RestoreObjectRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.RestoreRequest;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class RestoreObjectRequest extends S3Request implements ToCopyableBuilder<RestoreObjectRequest.Builder, RestoreObjectRequest>
{
    protected RestoreObjectRequest() {}
    public RestoreObjectRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final RestoreRequest restoreRequest(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static RestoreObjectRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends RestoreObjectRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<RestoreObjectRequest.Builder, RestoreObjectRequest>, S3Request.Builder, SdkPojo
    {
        RestoreObjectRequest.Builder bucket(String p0);
        RestoreObjectRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        RestoreObjectRequest.Builder checksumAlgorithm(String p0);
        RestoreObjectRequest.Builder expectedBucketOwner(String p0);
        RestoreObjectRequest.Builder key(String p0);
        RestoreObjectRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        RestoreObjectRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        RestoreObjectRequest.Builder requestPayer(RequestPayer p0);
        RestoreObjectRequest.Builder requestPayer(String p0);
        RestoreObjectRequest.Builder restoreRequest(RestoreRequest p0);
        RestoreObjectRequest.Builder versionId(String p0);
        default RestoreObjectRequest.Builder restoreRequest(java.util.function.Consumer<RestoreRequest.Builder> p0){ return null; }
    }
}
