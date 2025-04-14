// Generated automatically from software.amazon.awssdk.services.s3.model.CompletedMultipartUpload for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.CompletedPart;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CompletedMultipartUpload implements SdkPojo, Serializable, ToCopyableBuilder<CompletedMultipartUpload.Builder, CompletedMultipartUpload>
{
    protected CompletedMultipartUpload() {}
    public CompletedMultipartUpload.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<CompletedPart> parts(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasParts(){ return false; }
    public final int hashCode(){ return 0; }
    public static CompletedMultipartUpload.Builder builder(){ return null; }
    public static java.lang.Class<? extends CompletedMultipartUpload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CompletedMultipartUpload.Builder, CompletedMultipartUpload>, SdkPojo
    {
        CompletedMultipartUpload.Builder parts(Collection<CompletedPart> p0);
        CompletedMultipartUpload.Builder parts(CompletedPart... p0);
        CompletedMultipartUpload.Builder parts(java.util.function.Consumer<CompletedPart.Builder>... p0);
    }
}
