// Generated automatically from software.amazon.awssdk.services.s3.model.CreateBucketConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketLocationConstraint;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CreateBucketConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<CreateBucketConfiguration.Builder, CreateBucketConfiguration>
{
    protected CreateBucketConfiguration() {}
    public CreateBucketConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final BucketLocationConstraint locationConstraint(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String locationConstraintAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static CreateBucketConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends CreateBucketConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CreateBucketConfiguration.Builder, CreateBucketConfiguration>, SdkPojo
    {
        CreateBucketConfiguration.Builder locationConstraint(BucketLocationConstraint p0);
        CreateBucketConfiguration.Builder locationConstraint(String p0);
    }
}
