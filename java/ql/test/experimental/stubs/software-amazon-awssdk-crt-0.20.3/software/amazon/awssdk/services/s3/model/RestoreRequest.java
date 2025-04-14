// Generated automatically from software.amazon.awssdk.services.s3.model.RestoreRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.GlacierJobParameters;
import software.amazon.awssdk.services.s3.model.OutputLocation;
import software.amazon.awssdk.services.s3.model.RestoreRequestType;
import software.amazon.awssdk.services.s3.model.SelectParameters;
import software.amazon.awssdk.services.s3.model.Tier;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class RestoreRequest implements SdkPojo, Serializable, ToCopyableBuilder<RestoreRequest.Builder, RestoreRequest>
{
    protected RestoreRequest() {}
    public RestoreRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final GlacierJobParameters glacierJobParameters(){ return null; }
    public final Integer days(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final OutputLocation outputLocation(){ return null; }
    public final RestoreRequestType type(){ return null; }
    public final SelectParameters selectParameters(){ return null; }
    public final String description(){ return null; }
    public final String tierAsString(){ return null; }
    public final String toString(){ return null; }
    public final String typeAsString(){ return null; }
    public final Tier tier(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static RestoreRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends RestoreRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<RestoreRequest.Builder, RestoreRequest>, SdkPojo
    {
        RestoreRequest.Builder days(Integer p0);
        RestoreRequest.Builder description(String p0);
        RestoreRequest.Builder glacierJobParameters(GlacierJobParameters p0);
        RestoreRequest.Builder outputLocation(OutputLocation p0);
        RestoreRequest.Builder selectParameters(SelectParameters p0);
        RestoreRequest.Builder tier(String p0);
        RestoreRequest.Builder tier(Tier p0);
        RestoreRequest.Builder type(RestoreRequestType p0);
        RestoreRequest.Builder type(String p0);
        default RestoreRequest.Builder glacierJobParameters(java.util.function.Consumer<GlacierJobParameters.Builder> p0){ return null; }
        default RestoreRequest.Builder outputLocation(java.util.function.Consumer<OutputLocation.Builder> p0){ return null; }
        default RestoreRequest.Builder selectParameters(java.util.function.Consumer<SelectParameters.Builder> p0){ return null; }
    }
}
