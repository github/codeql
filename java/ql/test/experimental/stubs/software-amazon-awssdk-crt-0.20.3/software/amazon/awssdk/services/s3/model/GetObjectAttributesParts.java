// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectAttributesParts for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ObjectPart;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectAttributesParts implements SdkPojo, Serializable, ToCopyableBuilder<GetObjectAttributesParts.Builder, GetObjectAttributesParts>
{
    protected GetObjectAttributesParts() {}
    public GetObjectAttributesParts.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean isTruncated(){ return null; }
    public final Integer maxParts(){ return null; }
    public final Integer nextPartNumberMarker(){ return null; }
    public final Integer partNumberMarker(){ return null; }
    public final Integer totalPartsCount(){ return null; }
    public final List<ObjectPart> parts(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasParts(){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectAttributesParts.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectAttributesParts.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectAttributesParts.Builder, GetObjectAttributesParts>, SdkPojo
    {
        GetObjectAttributesParts.Builder isTruncated(Boolean p0);
        GetObjectAttributesParts.Builder maxParts(Integer p0);
        GetObjectAttributesParts.Builder nextPartNumberMarker(Integer p0);
        GetObjectAttributesParts.Builder partNumberMarker(Integer p0);
        GetObjectAttributesParts.Builder parts(Collection<ObjectPart> p0);
        GetObjectAttributesParts.Builder parts(ObjectPart... p0);
        GetObjectAttributesParts.Builder parts(java.util.function.Consumer<ObjectPart.Builder>... p0);
        GetObjectAttributesParts.Builder totalPartsCount(Integer p0);
    }
}
