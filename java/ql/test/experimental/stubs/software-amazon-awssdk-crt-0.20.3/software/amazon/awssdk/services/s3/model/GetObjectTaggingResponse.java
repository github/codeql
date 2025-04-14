// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectTaggingResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.services.s3.model.Tag;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectTaggingResponse extends S3Response implements ToCopyableBuilder<GetObjectTaggingResponse.Builder, GetObjectTaggingResponse>
{
    protected GetObjectTaggingResponse() {}
    public GetObjectTaggingResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final List<Tag> tagSet(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasTagSet(){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectTaggingResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectTaggingResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectTaggingResponse.Builder, GetObjectTaggingResponse>, S3Response.Builder, SdkPojo
    {
        GetObjectTaggingResponse.Builder tagSet(Collection<Tag> p0);
        GetObjectTaggingResponse.Builder tagSet(Tag... p0);
        GetObjectTaggingResponse.Builder tagSet(java.util.function.Consumer<Tag.Builder>... p0);
        GetObjectTaggingResponse.Builder versionId(String p0);
    }
}
