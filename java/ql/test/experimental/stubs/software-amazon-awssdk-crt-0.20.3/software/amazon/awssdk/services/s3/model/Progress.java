// Generated automatically from software.amazon.awssdk.services.s3.model.Progress for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Progress implements SdkPojo, Serializable, ToCopyableBuilder<Progress.Builder, Progress>
{
    protected Progress() {}
    public Progress.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Long bytesProcessed(){ return null; }
    public final Long bytesReturned(){ return null; }
    public final Long bytesScanned(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Progress.Builder builder(){ return null; }
    public static java.lang.Class<? extends Progress.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Progress.Builder, Progress>, SdkPojo
    {
        Progress.Builder bytesProcessed(Long p0);
        Progress.Builder bytesReturned(Long p0);
        Progress.Builder bytesScanned(Long p0);
    }

    public class BuilderImpl {
    }
}
