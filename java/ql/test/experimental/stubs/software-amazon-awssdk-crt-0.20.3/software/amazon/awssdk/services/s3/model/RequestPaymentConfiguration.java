// Generated automatically from software.amazon.awssdk.services.s3.model.RequestPaymentConfiguration for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Payer;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class RequestPaymentConfiguration implements SdkPojo, Serializable, ToCopyableBuilder<RequestPaymentConfiguration.Builder, RequestPaymentConfiguration>
{
    protected RequestPaymentConfiguration() {}
    public RequestPaymentConfiguration.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Payer payer(){ return null; }
    public final String payerAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static RequestPaymentConfiguration.Builder builder(){ return null; }
    public static java.lang.Class<? extends RequestPaymentConfiguration.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<RequestPaymentConfiguration.Builder, RequestPaymentConfiguration>, SdkPojo
    {
        RequestPaymentConfiguration.Builder payer(Payer p0);
        RequestPaymentConfiguration.Builder payer(String p0);
    }
}
