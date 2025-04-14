// Generated automatically from software.amazon.awssdk.services.s3.model.Checksum for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Checksum implements SdkPojo, Serializable, ToCopyableBuilder<Checksum.Builder, Checksum>
{
    protected Checksum() {}
    public Checksum.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String checksumCRC32(){ return null; }
    public final String checksumCRC32C(){ return null; }
    public final String checksumSHA1(){ return null; }
    public final String checksumSHA256(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static Checksum.Builder builder(){ return null; }
    public static java.lang.Class<? extends Checksum.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<Checksum.Builder, Checksum>, SdkPojo
    {
        Checksum.Builder checksumCRC32(String p0);
        Checksum.Builder checksumCRC32C(String p0);
        Checksum.Builder checksumSHA1(String p0);
        Checksum.Builder checksumSHA256(String p0);
    }
}
