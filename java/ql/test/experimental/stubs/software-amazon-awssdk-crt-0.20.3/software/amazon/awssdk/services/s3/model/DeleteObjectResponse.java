// Generated automatically from software.amazon.awssdk.services.s3.model.DeleteObjectResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DeleteObjectResponse extends S3Response implements ToCopyableBuilder<DeleteObjectResponse.Builder, DeleteObjectResponse>
{
    protected DeleteObjectResponse() {}
    public DeleteObjectResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean deleteMarker(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static DeleteObjectResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends DeleteObjectResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DeleteObjectResponse.Builder, DeleteObjectResponse>, S3Response.Builder, SdkPojo
    {
        DeleteObjectResponse.Builder deleteMarker(Boolean p0);
        DeleteObjectResponse.Builder requestCharged(RequestCharged p0);
        DeleteObjectResponse.Builder requestCharged(String p0);
        DeleteObjectResponse.Builder versionId(String p0);
    }
}
