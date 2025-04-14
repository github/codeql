// Generated automatically from software.amazon.awssdk.services.s3.model.GetPublicAccessBlockResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.PublicAccessBlockConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetPublicAccessBlockResponse extends S3Response implements ToCopyableBuilder<GetPublicAccessBlockResponse.Builder, GetPublicAccessBlockResponse>
{
    protected GetPublicAccessBlockResponse() {}
    public GetPublicAccessBlockResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final PublicAccessBlockConfiguration publicAccessBlockConfiguration(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetPublicAccessBlockResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetPublicAccessBlockResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetPublicAccessBlockResponse.Builder, GetPublicAccessBlockResponse>, S3Response.Builder, SdkPojo
    {
        GetPublicAccessBlockResponse.Builder publicAccessBlockConfiguration(PublicAccessBlockConfiguration p0);
        default GetPublicAccessBlockResponse.Builder publicAccessBlockConfiguration(java.util.function.Consumer<PublicAccessBlockConfiguration.Builder> p0){ return null; }
    }
}
