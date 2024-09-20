// Generated automatically from software.amazon.awssdk.services.s3.model.Grant for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Grantee;
import software.amazon.awssdk.services.s3.model.Permission;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Grant implements SdkPojo, Serializable, ToCopyableBuilder<Grant.Builder, Grant>
{
    protected Grant() {}
    public Grant.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Grantee grantee(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Permission permission(){ return null; }
    public final String permissionAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Grant.Builder builder(){ return null; }
    public static java.lang.Class<? extends Grant.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Grant.Builder, Grant>, SdkPojo
    {
        Grant.Builder grantee(Grantee p0);
        Grant.Builder permission(Permission p0);
        Grant.Builder permission(String p0);
        default Grant.Builder grantee(java.util.function.Consumer<Grantee.Builder> p0){ return null; }
    }
}
