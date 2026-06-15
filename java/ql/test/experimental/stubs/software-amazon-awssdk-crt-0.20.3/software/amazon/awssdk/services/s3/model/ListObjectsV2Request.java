// Generated automatically from software.amazon.awssdk.services.s3.model.ListObjectsV2Request for testing purposes

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

public class ListObjectsV2Request extends S3Request implements ToCopyableBuilder<ListObjectsV2Request.Builder, ListObjectsV2Request>
{
    protected ListObjectsV2Request() {}
    public ListObjectsV2Request.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean fetchOwner(){ return null; }
    public final EncodingType encodingType(){ return null; }
    public final Integer maxKeys(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String continuationToken(){ return null; }
    public final String delimiter(){ return null; }
    public final String encodingTypeAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String prefix(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String startAfter(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ListObjectsV2Request.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListObjectsV2Request.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListObjectsV2Request.Builder, ListObjectsV2Request>, S3Request.Builder, SdkPojo
    {
        ListObjectsV2Request.Builder bucket(String p0);
        ListObjectsV2Request.Builder continuationToken(String p0);
        ListObjectsV2Request.Builder delimiter(String p0);
        ListObjectsV2Request.Builder encodingType(EncodingType p0);
        ListObjectsV2Request.Builder encodingType(String p0);
        ListObjectsV2Request.Builder expectedBucketOwner(String p0);
        ListObjectsV2Request.Builder fetchOwner(Boolean p0);
        ListObjectsV2Request.Builder maxKeys(Integer p0);
        ListObjectsV2Request.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        ListObjectsV2Request.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        ListObjectsV2Request.Builder prefix(String p0);
        ListObjectsV2Request.Builder requestPayer(RequestPayer p0);
        ListObjectsV2Request.Builder requestPayer(String p0);
        ListObjectsV2Request.Builder startAfter(String p0);
    }
}
