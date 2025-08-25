// Generated automatically from software.amazon.awssdk.services.s3.model.ListObjectVersionsRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.EncodingType;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListObjectVersionsRequest extends S3Request implements ToCopyableBuilder<ListObjectVersionsRequest.Builder, ListObjectVersionsRequest>
{
    protected ListObjectVersionsRequest() {}
    public ListObjectVersionsRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final EncodingType encodingType(){ return null; }
    public final Integer maxKeys(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String delimiter(){ return null; }
    public final String encodingTypeAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String keyMarker(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final String versionIdMarker(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ListObjectVersionsRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListObjectVersionsRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListObjectVersionsRequest.Builder, ListObjectVersionsRequest>, S3Request.Builder, SdkPojo
    {
        ListObjectVersionsRequest.Builder bucket(String p0);
        ListObjectVersionsRequest.Builder delimiter(String p0);
        ListObjectVersionsRequest.Builder encodingType(EncodingType p0);
        ListObjectVersionsRequest.Builder encodingType(String p0);
        ListObjectVersionsRequest.Builder expectedBucketOwner(String p0);
        ListObjectVersionsRequest.Builder keyMarker(String p0);
        ListObjectVersionsRequest.Builder maxKeys(Integer p0);
        ListObjectVersionsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        ListObjectVersionsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        ListObjectVersionsRequest.Builder prefix(String p0);
        ListObjectVersionsRequest.Builder versionIdMarker(String p0);
    }
}
