// Generated automatically from software.amazon.awssdk.services.s3.model.ListMultipartUploadsRequest for testing purposes

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

public class ListMultipartUploadsRequest extends S3Request implements ToCopyableBuilder<ListMultipartUploadsRequest.Builder, ListMultipartUploadsRequest>
{
    protected ListMultipartUploadsRequest() {}
    public ListMultipartUploadsRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final EncodingType encodingType(){ return null; }
    public final Integer maxUploads(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String bucket(){ return null; }
    public final String delimiter(){ return null; }
    public final String encodingTypeAsString(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String keyMarker(){ return null; }
    public final String prefix(){ return null; }
    public final String toString(){ return null; }
    public final String uploadIdMarker(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ListMultipartUploadsRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListMultipartUploadsRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListMultipartUploadsRequest.Builder, ListMultipartUploadsRequest>, S3Request.Builder, SdkPojo
    {
        ListMultipartUploadsRequest.Builder bucket(String p0);
        ListMultipartUploadsRequest.Builder delimiter(String p0);
        ListMultipartUploadsRequest.Builder encodingType(EncodingType p0);
        ListMultipartUploadsRequest.Builder encodingType(String p0);
        ListMultipartUploadsRequest.Builder expectedBucketOwner(String p0);
        ListMultipartUploadsRequest.Builder keyMarker(String p0);
        ListMultipartUploadsRequest.Builder maxUploads(Integer p0);
        ListMultipartUploadsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        ListMultipartUploadsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        ListMultipartUploadsRequest.Builder prefix(String p0);
        ListMultipartUploadsRequest.Builder uploadIdMarker(String p0);
    }
}
