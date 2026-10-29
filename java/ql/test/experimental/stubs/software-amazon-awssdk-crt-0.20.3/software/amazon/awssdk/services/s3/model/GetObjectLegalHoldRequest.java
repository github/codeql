// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectLegalHoldRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectLegalHoldRequest extends S3Request implements ToCopyableBuilder<GetObjectLegalHoldRequest.Builder, GetObjectLegalHoldRequest>
{
    protected GetObjectLegalHoldRequest() {}
    public GetObjectLegalHoldRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectLegalHoldRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectLegalHoldRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectLegalHoldRequest.Builder, GetObjectLegalHoldRequest>, S3Request.Builder, SdkPojo
    {
        GetObjectLegalHoldRequest.Builder bucket(String p0);
        GetObjectLegalHoldRequest.Builder expectedBucketOwner(String p0);
        GetObjectLegalHoldRequest.Builder key(String p0);
        GetObjectLegalHoldRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        GetObjectLegalHoldRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        GetObjectLegalHoldRequest.Builder requestPayer(RequestPayer p0);
        GetObjectLegalHoldRequest.Builder requestPayer(String p0);
        GetObjectLegalHoldRequest.Builder versionId(String p0);
    }
}
