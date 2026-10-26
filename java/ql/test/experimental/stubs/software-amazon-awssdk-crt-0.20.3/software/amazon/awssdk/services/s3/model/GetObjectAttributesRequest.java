// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectAttributesRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectAttributes;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectAttributesRequest extends S3Request implements ToCopyableBuilder<GetObjectAttributesRequest.Builder, GetObjectAttributesRequest>
{
    protected GetObjectAttributesRequest() {}
    public GetObjectAttributesRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Integer maxParts(){ return null; }
    public final Integer partNumberMarker(){ return null; }
    public final List<ObjectAttributes> objectAttributes(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<String> objectAttributesAsStrings(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKey(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasObjectAttributes(){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectAttributesRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectAttributesRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectAttributesRequest.Builder, GetObjectAttributesRequest>, S3Request.Builder, SdkPojo
    {
        GetObjectAttributesRequest.Builder bucket(String p0);
        GetObjectAttributesRequest.Builder expectedBucketOwner(String p0);
        GetObjectAttributesRequest.Builder key(String p0);
        GetObjectAttributesRequest.Builder maxParts(Integer p0);
        GetObjectAttributesRequest.Builder objectAttributes(Collection<ObjectAttributes> p0);
        GetObjectAttributesRequest.Builder objectAttributes(ObjectAttributes... p0);
        GetObjectAttributesRequest.Builder objectAttributesWithStrings(Collection<String> p0);
        GetObjectAttributesRequest.Builder objectAttributesWithStrings(String... p0);
        GetObjectAttributesRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        GetObjectAttributesRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        GetObjectAttributesRequest.Builder partNumberMarker(Integer p0);
        GetObjectAttributesRequest.Builder requestPayer(RequestPayer p0);
        GetObjectAttributesRequest.Builder requestPayer(String p0);
        GetObjectAttributesRequest.Builder sseCustomerAlgorithm(String p0);
        GetObjectAttributesRequest.Builder sseCustomerKey(String p0);
        GetObjectAttributesRequest.Builder sseCustomerKeyMD5(String p0);
        GetObjectAttributesRequest.Builder versionId(String p0);
    }
}
