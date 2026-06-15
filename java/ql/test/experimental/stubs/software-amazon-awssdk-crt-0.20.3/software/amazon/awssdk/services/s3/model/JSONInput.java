// Generated automatically from software.amazon.awssdk.services.s3.model.JSONInput for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.JSONType;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class JSONInput implements SdkPojo, Serializable, ToCopyableBuilder<JSONInput.Builder, JSONInput>
{
    protected JSONInput() {}
    public JSONInput.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final JSONType type(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final String typeAsString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static JSONInput.Builder builder(){ return null; }
    public static java.lang.Class<? extends JSONInput.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<JSONInput.Builder, JSONInput>, SdkPojo
    {
        JSONInput.Builder type(JSONType p0);
        JSONInput.Builder type(String p0);
    }
}
