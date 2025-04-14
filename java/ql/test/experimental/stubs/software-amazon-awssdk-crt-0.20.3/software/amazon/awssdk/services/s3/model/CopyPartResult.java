// Generated automatically from software.amazon.awssdk.services.s3.model.CopyPartResult for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CopyPartResult implements SdkPojo, Serializable, ToCopyableBuilder<CopyPartResult.Builder, CopyPartResult>
{
    protected CopyPartResult() {}
    public CopyPartResult.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Instant lastModified(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String checksumCRC32(){ return null; }
    public final String checksumCRC32C(){ return null; }
    public final String checksumSHA1(){ return null; }
    public final String checksumSHA256(){ return null; }
    public final String eTag(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static CopyPartResult.Builder builder(){ return null; }
    public static java.lang.Class<? extends CopyPartResult.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CopyPartResult.Builder, CopyPartResult>, SdkPojo
    {
        CopyPartResult.Builder checksumCRC32(String p0);
        CopyPartResult.Builder checksumCRC32C(String p0);
        CopyPartResult.Builder checksumSHA1(String p0);
        CopyPartResult.Builder checksumSHA256(String p0);
        CopyPartResult.Builder eTag(String p0);
        CopyPartResult.Builder lastModified(Instant p0);
    }
}
