// Generated automatically from software.amazon.awssdk.services.s3.model.RedirectAllRequestsTo for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Protocol;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class RedirectAllRequestsTo implements SdkPojo, Serializable, ToCopyableBuilder<RedirectAllRequestsTo.Builder, RedirectAllRequestsTo>
{
    protected RedirectAllRequestsTo() {}
    public RedirectAllRequestsTo.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Protocol protocol(){ return null; }
    public final String hostName(){ return null; }
    public final String protocolAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static RedirectAllRequestsTo.Builder builder(){ return null; }
    public static java.lang.Class<? extends RedirectAllRequestsTo.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<RedirectAllRequestsTo.Builder, RedirectAllRequestsTo>, SdkPojo
    {
        RedirectAllRequestsTo.Builder hostName(String p0);
        RedirectAllRequestsTo.Builder protocol(Protocol p0);
        RedirectAllRequestsTo.Builder protocol(String p0);
    }
}
