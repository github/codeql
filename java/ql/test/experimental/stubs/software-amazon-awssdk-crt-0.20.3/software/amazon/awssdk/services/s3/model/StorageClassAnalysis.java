// Generated automatically from software.amazon.awssdk.services.s3.model.StorageClassAnalysis for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.StorageClassAnalysisDataExport;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class StorageClassAnalysis implements SdkPojo, Serializable, ToCopyableBuilder<StorageClassAnalysis.Builder, StorageClassAnalysis>
{
    protected StorageClassAnalysis() {}
    public StorageClassAnalysis.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final StorageClassAnalysisDataExport dataExport(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static StorageClassAnalysis.Builder builder(){ return null; }
    public static java.lang.Class<? extends StorageClassAnalysis.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<StorageClassAnalysis.Builder, StorageClassAnalysis>, SdkPojo
    {
        StorageClassAnalysis.Builder dataExport(StorageClassAnalysisDataExport p0);
        default StorageClassAnalysis.Builder dataExport(java.util.function.Consumer<StorageClassAnalysisDataExport.Builder> p0){ return null; }
    }
}
