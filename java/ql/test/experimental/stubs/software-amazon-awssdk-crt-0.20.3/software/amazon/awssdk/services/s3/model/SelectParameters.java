// Generated automatically from software.amazon.awssdk.services.s3.model.SelectParameters for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ExpressionType;
import software.amazon.awssdk.services.s3.model.InputSerialization;
import software.amazon.awssdk.services.s3.model.OutputSerialization;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class SelectParameters implements SdkPojo, Serializable, ToCopyableBuilder<SelectParameters.Builder, SelectParameters>
{
    protected SelectParameters() {}
    public SelectParameters.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ExpressionType expressionType(){ return null; }
    public final InputSerialization inputSerialization(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final OutputSerialization outputSerialization(){ return null; }
    public final String expression(){ return null; }
    public final String expressionTypeAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static SelectParameters.Builder builder(){ return null; }
    public static java.lang.Class<? extends SelectParameters.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<SelectParameters.Builder, SelectParameters>, SdkPojo
    {
        SelectParameters.Builder expression(String p0);
        SelectParameters.Builder expressionType(ExpressionType p0);
        SelectParameters.Builder expressionType(String p0);
        SelectParameters.Builder inputSerialization(InputSerialization p0);
        SelectParameters.Builder outputSerialization(OutputSerialization p0);
        default SelectParameters.Builder inputSerialization(java.util.function.Consumer<InputSerialization.Builder> p0){ return null; }
        default SelectParameters.Builder outputSerialization(java.util.function.Consumer<OutputSerialization.Builder> p0){ return null; }
    }
}
