// Generated automatically from software.amazon.awssdk.services.s3.model.StorageClassAnalysisDataExport for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.AnalyticsExportDestination;
import software.amazon.awssdk.services.s3.model.StorageClassAnalysisSchemaVersion;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class StorageClassAnalysisDataExport implements SdkPojo, Serializable, ToCopyableBuilder<StorageClassAnalysisDataExport.Builder, StorageClassAnalysisDataExport>
{
    protected StorageClassAnalysisDataExport() {}
    public StorageClassAnalysisDataExport.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final AnalyticsExportDestination destination(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final StorageClassAnalysisSchemaVersion outputSchemaVersion(){ return null; }
    public final String outputSchemaVersionAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static StorageClassAnalysisDataExport.Builder builder(){ return null; }
    public static java.lang.Class<? extends StorageClassAnalysisDataExport.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<StorageClassAnalysisDataExport.Builder, StorageClassAnalysisDataExport>, SdkPojo
    {
        StorageClassAnalysisDataExport.Builder destination(AnalyticsExportDestination p0);
        StorageClassAnalysisDataExport.Builder outputSchemaVersion(StorageClassAnalysisSchemaVersion p0);
        StorageClassAnalysisDataExport.Builder outputSchemaVersion(String p0);
        default StorageClassAnalysisDataExport.Builder destination(java.util.function.Consumer<AnalyticsExportDestination.Builder> p0){ return null; }
    }
}
