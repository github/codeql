// Generated automatically from software.amazon.awssdk.services.s3.model.CORSRule for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CORSRule implements SdkPojo, Serializable, ToCopyableBuilder<CORSRule.Builder, CORSRule>
{
    protected CORSRule() {}
    public CORSRule.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Integer maxAgeSeconds(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<String> allowedHeaders(){ return null; }
    public final List<String> allowedMethods(){ return null; }
    public final List<String> allowedOrigins(){ return null; }
    public final List<String> exposeHeaders(){ return null; }
    public final String id(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasAllowedHeaders(){ return false; }
    public final boolean hasAllowedMethods(){ return false; }
    public final boolean hasAllowedOrigins(){ return false; }
    public final boolean hasExposeHeaders(){ return false; }
    public final int hashCode(){ return 0; }
    public static CORSRule.Builder builder(){ return null; }
    public static java.lang.Class<? extends CORSRule.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CORSRule.Builder, CORSRule>, SdkPojo
    {
        CORSRule.Builder allowedHeaders(Collection<String> p0);
        CORSRule.Builder allowedHeaders(String... p0);
        CORSRule.Builder allowedMethods(Collection<String> p0);
        CORSRule.Builder allowedMethods(String... p0);
        CORSRule.Builder allowedOrigins(Collection<String> p0);
        CORSRule.Builder allowedOrigins(String... p0);
        CORSRule.Builder exposeHeaders(Collection<String> p0);
        CORSRule.Builder exposeHeaders(String... p0);
        CORSRule.Builder id(String p0);
        CORSRule.Builder maxAgeSeconds(Integer p0);
    }
}
