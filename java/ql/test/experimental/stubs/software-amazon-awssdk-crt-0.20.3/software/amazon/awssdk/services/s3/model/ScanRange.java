// Generated automatically from software.amazon.awssdk.services.s3.model.ScanRange for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ScanRange implements SdkPojo, Serializable, ToCopyableBuilder<ScanRange.Builder, ScanRange>
{
    protected ScanRange() {}
    public ScanRange.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Long end(){ return null; }
    public final Long start(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ScanRange.Builder builder(){ return null; }
    public static java.lang.Class<? extends ScanRange.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<ScanRange.Builder, ScanRange>, SdkPojo
    {
        ScanRange.Builder end(Long p0);
        ScanRange.Builder start(Long p0);
    }
}
