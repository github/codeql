// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectAclResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.RequestCharged;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutObjectAclResponse extends S3Response implements ToCopyableBuilder<PutObjectAclResponse.Builder, PutObjectAclResponse>
{
    protected PutObjectAclResponse() {}
    public PutObjectAclResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestCharged requestCharged(){ return null; }
    public final String requestChargedAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutObjectAclResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectAclResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectAclResponse.Builder, PutObjectAclResponse>, S3Response.Builder, SdkPojo
    {
        PutObjectAclResponse.Builder requestCharged(RequestCharged p0);
        PutObjectAclResponse.Builder requestCharged(String p0);
    }
}
