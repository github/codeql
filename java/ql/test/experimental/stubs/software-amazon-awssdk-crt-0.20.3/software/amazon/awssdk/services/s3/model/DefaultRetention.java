// Generated automatically from software.amazon.awssdk.services.s3.model.DefaultRetention for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectLockRetentionMode;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DefaultRetention implements SdkPojo, Serializable, ToCopyableBuilder<DefaultRetention.Builder, DefaultRetention>
{
    protected DefaultRetention() {}
    public DefaultRetention.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Integer days(){ return null; }
    public final Integer years(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockRetentionMode mode(){ return null; }
    public final String modeAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static DefaultRetention.Builder builder(){ return null; }
    public static java.lang.Class<? extends DefaultRetention.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DefaultRetention.Builder, DefaultRetention>, SdkPojo
    {
        DefaultRetention.Builder days(Integer p0);
        DefaultRetention.Builder mode(ObjectLockRetentionMode p0);
        DefaultRetention.Builder mode(String p0);
        DefaultRetention.Builder years(Integer p0);
    }
}
