// Generated automatically from software.amazon.awssdk.services.s3.model.Condition for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Condition implements SdkPojo, Serializable, ToCopyableBuilder<Condition.Builder, Condition>
{
    protected Condition() {}
    public Condition.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String httpErrorCodeReturnedEquals(){ return null; }
    public final String keyPrefixEquals(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Condition.Builder builder(){ return null; }
    public static java.lang.Class<? extends Condition.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Condition.Builder, Condition>, SdkPojo
    {
        Condition.Builder httpErrorCodeReturnedEquals(String p0);
        Condition.Builder keyPrefixEquals(String p0);
    }
}
