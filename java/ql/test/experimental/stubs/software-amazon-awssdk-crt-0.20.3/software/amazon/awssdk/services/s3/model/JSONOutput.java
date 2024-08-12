// Generated automatically from software.amazon.awssdk.services.s3.model.JSONOutput for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class JSONOutput implements SdkPojo, Serializable, ToCopyableBuilder<JSONOutput.Builder, JSONOutput>
{
    protected JSONOutput() {}
    public JSONOutput.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String recordDelimiter(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static JSONOutput.Builder builder(){ return null; }
    public static java.lang.Class<? extends JSONOutput.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<JSONOutput.Builder, JSONOutput>, SdkPojo
    {
        JSONOutput.Builder recordDelimiter(String p0);
    }
}
