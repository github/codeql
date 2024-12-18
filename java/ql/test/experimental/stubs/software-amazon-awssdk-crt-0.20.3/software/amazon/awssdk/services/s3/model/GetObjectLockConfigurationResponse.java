// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectLockConfigurationResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectLockConfiguration;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectLockConfigurationResponse extends S3Response implements ToCopyableBuilder<GetObjectLockConfigurationResponse.Builder, GetObjectLockConfigurationResponse>
{
    protected GetObjectLockConfigurationResponse() {}
    public GetObjectLockConfigurationResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockConfiguration objectLockConfiguration(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectLockConfigurationResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectLockConfigurationResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectLockConfigurationResponse.Builder, GetObjectLockConfigurationResponse>, S3Response.Builder, SdkPojo
    {
        GetObjectLockConfigurationResponse.Builder objectLockConfiguration(ObjectLockConfiguration p0);
        default GetObjectLockConfigurationResponse.Builder objectLockConfiguration(java.util.function.Consumer<ObjectLockConfiguration.Builder> p0){ return null; }
    }
}
