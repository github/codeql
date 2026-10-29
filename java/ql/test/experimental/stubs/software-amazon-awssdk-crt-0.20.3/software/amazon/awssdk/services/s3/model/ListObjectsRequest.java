// Generated automatically from software.amazon.awssdk.services.s3.model.ListObjectsRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.EncodingType;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListObjectsRequest extends S3Request implements ToCopyableBuilder<ListObjectsRequest.Builder, ListObjectsRequest>
{
    protected ListObjectsRequest() {}
    public ListObjectsRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final EncodingType encodingType(){ return null; }
    public final Integer maxKeys(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String delimiter(){ return null; }
    public final String encodingTypeAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String marker(){ return null; }
    public final String prefix(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ListObjectsRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListObjectsRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListObjectsRequest.Builder, ListObjectsRequest>, S3Request.Builder, SdkPojo
    {
        ListObjectsRequest.Builder bucket(String p0);
        ListObjectsRequest.Builder delimiter(String p0);
        ListObjectsRequest.Builder encodingType(EncodingType p0);
        ListObjectsRequest.Builder encodingType(String p0);
        ListObjectsRequest.Builder expectedBucketOwner(String p0);
        ListObjectsRequest.Builder marker(String p0);
        ListObjectsRequest.Builder maxKeys(Integer p0);
        ListObjectsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        ListObjectsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        ListObjectsRequest.Builder prefix(String p0);
        ListObjectsRequest.Builder requestPayer(RequestPayer p0);
        ListObjectsRequest.Builder requestPayer(String p0);
    }
}
