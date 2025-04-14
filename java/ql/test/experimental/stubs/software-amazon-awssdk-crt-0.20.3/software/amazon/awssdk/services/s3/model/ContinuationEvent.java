// Generated automatically from software.amazon.awssdk.services.s3.model.ContinuationEvent for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.SelectObjectContentEventStream;
import software.amazon.awssdk.services.s3.model.SelectObjectContentResponseHandler;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ContinuationEvent implements SdkPojo, SelectObjectContentEventStream, Serializable, ToCopyableBuilder<ContinuationEvent.Builder, ContinuationEvent>
{
    protected ContinuationEvent() {}
    protected ContinuationEvent(ContinuationEvent.BuilderImpl p0){}
    public ContinuationEvent.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ContinuationEvent copy(java.util.function.Consumer<? super ContinuationEvent.Builder> p0){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ContinuationEvent.Builder builder(){ return null; }
    public static java.lang.Class<? extends ContinuationEvent.Builder> serializableBuilderClass(){ return null; }
    public void accept(SelectObjectContentResponseHandler.Visitor p0){}
    static class BuilderImpl implements ContinuationEvent.Builder
    {
        protected BuilderImpl(){}
        protected BuilderImpl(ContinuationEvent p0){}
        public ContinuationEvent build(){ return null; }
        public List<SdkField<? extends Object>> sdkFields(){ return null; }
    }
    static public interface Builder extends CopyableBuilder<ContinuationEvent.Builder, ContinuationEvent>, SdkPojo
    {
    }
}
