// Generated automatically from software.amazon.awssdk.services.s3.model.OutputSerialization for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CSVOutput;
import software.amazon.awssdk.services.s3.model.JSONOutput;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class OutputSerialization implements SdkPojo, Serializable, ToCopyableBuilder<OutputSerialization.Builder, OutputSerialization>
{
    protected OutputSerialization() {}
    public OutputSerialization.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final CSVOutput csv(){ return null; }
    public final JSONOutput json(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static OutputSerialization.Builder builder(){ return null; }
    public static java.lang.Class<? extends OutputSerialization.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<OutputSerialization.Builder, OutputSerialization>, SdkPojo
    {
        OutputSerialization.Builder csv(CSVOutput p0);
        OutputSerialization.Builder json(JSONOutput p0);
        default OutputSerialization.Builder csv(java.util.function.Consumer<CSVOutput.Builder> p0){ return null; }
        default OutputSerialization.Builder json(java.util.function.Consumer<JSONOutput.Builder> p0){ return null; }
    }
}
