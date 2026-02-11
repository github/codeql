// Generated automatically from software.amazon.awssdk.services.s3.model.DeleteObjectsResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.DeletedObject;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Error;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DeleteObjectsResponse extends S3Response implements ToCopyableBuilder<DeleteObjectsResponse.Builder, DeleteObjectsResponse>
{
    protected DeleteObjectsResponse() {}
    public DeleteObjectsResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<DeletedObject> deleted(){ return null; }
    public final List<S3Error> errors(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasDeleted(){ return false; }
    public final boolean hasErrors(){ return false; }
    public final int hashCode(){ return 0; }
    public static DeleteObjectsResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends DeleteObjectsResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DeleteObjectsResponse.Builder, DeleteObjectsResponse>, S3Response.Builder, SdkPojo
    {
        DeleteObjectsResponse.Builder deleted(Collection<DeletedObject> p0);
        DeleteObjectsResponse.Builder deleted(DeletedObject... p0);
        DeleteObjectsResponse.Builder deleted(java.util.function.Consumer<DeletedObject.Builder>... p0);
        DeleteObjectsResponse.Builder errors(Collection<S3Error> p0);
        DeleteObjectsResponse.Builder errors(S3Error... p0);
        DeleteObjectsResponse.Builder errors(java.util.function.Consumer<S3Error.Builder>... p0);
        DeleteObjectsResponse.Builder requestCharged(RequestCharged p0);
        DeleteObjectsResponse.Builder requestCharged(String p0);
    }
}
