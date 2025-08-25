// Generated automatically from software.amazon.awssdk.services.s3.model.InputSerialization for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CSVInput;
import software.amazon.awssdk.services.s3.model.CompressionType;
import software.amazon.awssdk.services.s3.model.JSONInput;
import software.amazon.awssdk.services.s3.model.ParquetInput;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class InputSerialization implements SdkPojo, Serializable, ToCopyableBuilder<InputSerialization.Builder, InputSerialization>
{
    protected InputSerialization() {}
    public InputSerialization.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final CSVInput csv(){ return null; }
    public final CompressionType compressionType(){ return null; }
    public final JSONInput json(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ParquetInput parquet(){ return null; }
    public final String compressionTypeAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static InputSerialization.Builder builder(){ return null; }
    public static java.lang.Class<? extends InputSerialization.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<InputSerialization.Builder, InputSerialization>, SdkPojo
    {
        InputSerialization.Builder compressionType(CompressionType p0);
        InputSerialization.Builder compressionType(String p0);
        InputSerialization.Builder csv(CSVInput p0);
        InputSerialization.Builder json(JSONInput p0);
        InputSerialization.Builder parquet(ParquetInput p0);
        default InputSerialization.Builder csv(java.util.function.Consumer<CSVInput.Builder> p0){ return null; }
        default InputSerialization.Builder json(java.util.function.Consumer<JSONInput.Builder> p0){ return null; }
        default InputSerialization.Builder parquet(java.util.function.Consumer<ParquetInput.Builder> p0){ return null; }
    }
}
