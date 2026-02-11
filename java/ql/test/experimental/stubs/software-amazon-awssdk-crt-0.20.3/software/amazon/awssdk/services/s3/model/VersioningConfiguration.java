// Generated automatically from software.amazon.awssdk.services.s3.model.VersioningConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.BucketVersioningStatus;
import software.amazon.awssdk.services.s3.model.MFADelete;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class VersioningConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<VersioningConfiguration.Builder, VersioningConfiguration>
{
    protected VersioningConfiguration() {}
    public VersioningConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final BucketVersioningStatus status(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final MFADelete mfaDelete(){ return null; }
    public final String mfaDeleteAsString(){ return null; }
    public final String statusAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static VersioningConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends VersioningConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<VersioningConfiguration.Builder, VersioningConfiguration>, SdkPojo
    {
        VersioningConfiguration.Builder mfaDelete(MFADelete p0);
        VersioningConfiguration.Builder mfaDelete(String p0);
        VersioningConfiguration.Builder status(BucketVersioningStatus p0);
        VersioningConfiguration.Builder status(String p0);
    }
}
