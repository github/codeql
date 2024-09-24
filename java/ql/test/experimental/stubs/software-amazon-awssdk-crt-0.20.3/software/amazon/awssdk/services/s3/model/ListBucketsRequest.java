// Generated automatically from software.amazon.awssdk.services.s3.model.ListBucketsRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ListBucketsRequest extends S3Request implements ToCopyableBuilder<ListBucketsRequest.Builder, ListBucketsRequest>
{
    protected ListBucketsRequest() {}
    public ListBucketsRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ListBucketsRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends ListBucketsRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ListBucketsRequest.Builder, ListBucketsRequest>, S3Request.Builder, SdkPojo
    {
        ListBucketsRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        ListBucketsRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
    }
}
