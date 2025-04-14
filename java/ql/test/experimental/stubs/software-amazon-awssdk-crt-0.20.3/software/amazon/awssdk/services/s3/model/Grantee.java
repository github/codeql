// Generated automatically from software.amazon.awssdk.services.s3.model.Grantee for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Type;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Grantee implements SdkPojo, Serializable, ToCopyableBuilder<Grantee.Builder, Grantee>
{
    protected Grantee() {}
    public Grantee.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String displayName(){ return null; }
    public final String emailAddress(){ return null; }
    public final String id(){ return null; }
    public final String toString(){ return null; }
    public final String typeAsString(){ return null; }
    public final String uri(){ return null; }
    public final Type type(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Grantee.Builder builder(){ return null; }
    public static java.lang.Class<? extends Grantee.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Grantee.Builder, Grantee>, SdkPojo
    {
        Grantee.Builder displayName(String p0);
        Grantee.Builder emailAddress(String p0);
        Grantee.Builder id(String p0);
        Grantee.Builder type(String p0);
        Grantee.Builder type(Type p0);
        Grantee.Builder uri(String p0);
    }
}
