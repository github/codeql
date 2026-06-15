// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketRequestPaymentResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Payer;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketRequestPaymentResponse extends S3Response implements ToCopyableBuilder<GetBucketRequestPaymentResponse.Builder, GetBucketRequestPaymentResponse>
{
    protected GetBucketRequestPaymentResponse() {}
    public GetBucketRequestPaymentResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Payer payer(){ return null; }
    public final String payerAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketRequestPaymentResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketRequestPaymentResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketRequestPaymentResponse.Builder, GetBucketRequestPaymentResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketRequestPaymentResponse.Builder payer(Payer p0);
        GetBucketRequestPaymentResponse.Builder payer(String p0);
    }
}
