// Generated automatically from software.amazon.awssdk.services.s3.model.OutputLocation for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.S3Location;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class OutputLocation implements SdkPojo, Serializable, ToCopyableBuilder<OutputLocation.Builder, OutputLocation>
{
    protected OutputLocation() {}
    public OutputLocation.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final S3Location s3(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static OutputLocation.Builder builder(){ return null; }
    public static java.lang.Class<? extends OutputLocation.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<OutputLocation.Builder, OutputLocation>, SdkPojo
    {
        OutputLocation.Builder s3(S3Location p0);
        default OutputLocation.Builder s3(java.util.function.Consumer<S3Location.Builder> p0){ return null; }
    }
}
