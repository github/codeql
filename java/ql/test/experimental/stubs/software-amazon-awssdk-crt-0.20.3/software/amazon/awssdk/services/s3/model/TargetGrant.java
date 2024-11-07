// Generated automatically from software.amazon.awssdk.services.s3.model.TargetGrant for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketLogsPermission;
import software.amazon.awssdk.services.s3.model.Grantee;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class TargetGrant implements SdkPojo, Serializable, ToCopyableBuilder<TargetGrant.Builder, TargetGrant>
{
    protected TargetGrant() {}
    public TargetGrant.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final BucketLogsPermission permission(){ return null; }
    public final Grantee grantee(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String permissionAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static TargetGrant.Builder builder(){ return null; }
    public static java.lang.Class<? extends TargetGrant.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<TargetGrant.Builder, TargetGrant>, SdkPojo
    {
        TargetGrant.Builder grantee(Grantee p0);
        TargetGrant.Builder permission(BucketLogsPermission p0);
        TargetGrant.Builder permission(String p0);
        default TargetGrant.Builder grantee(java.util.function.Consumer<Grantee.Builder> p0){ return null; }
    }
}
