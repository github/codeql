// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectLegalHoldResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectLockLegalHold;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectLegalHoldResponse extends S3Response implements ToCopyableBuilder<GetObjectLegalHoldResponse.Builder, GetObjectLegalHoldResponse>
{
    protected GetObjectLegalHoldResponse() {}
    public GetObjectLegalHoldResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockLegalHold legalHold(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectLegalHoldResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectLegalHoldResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectLegalHoldResponse.Builder, GetObjectLegalHoldResponse>, S3Response.Builder, SdkPojo
    {
        GetObjectLegalHoldResponse.Builder legalHold(ObjectLockLegalHold p0);
        default GetObjectLegalHoldResponse.Builder legalHold(java.util.function.Consumer<ObjectLockLegalHold.Builder> p0){ return null; }
    }
}
