// Generated automatically from software.amazon.awssdk.services.s3.model.ProgressEvent for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.Progress;
import software.amazon.awssdk.services.s3.model.SelectObjectContentEventStream;
import software.amazon.awssdk.services.s3.model.SelectObjectContentResponseHandler;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ProgressEvent implements SdkPojo, SelectObjectContentEventStream, Serializable, ToCopyableBuilder<ProgressEvent.Builder, ProgressEvent>
{
    protected ProgressEvent() {}
    protected ProgressEvent(ProgressEvent.BuilderImpl p0){}
    public ProgressEvent.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Progress details(){ return null; }
    public final ProgressEvent copy(java.util.function.Consumer<? super ProgressEvent.Builder> p0){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static ProgressEvent.Builder builder(){ return null; }
    public static java.lang.Class<? extends ProgressEvent.Builder> serializableBuilderClass(){ return null; }
    public void accept(SelectObjectContentResponseHandler.Visitor p0){}
    static class BuilderImpl implements ProgressEvent.Builder
    {
        protected BuilderImpl(){}
        protected BuilderImpl(ProgressEvent p0){}
        public List<SdkField<? extends Object>> sdkFields(){ return null; }
        public ProgressEvent build(){ return null; }
        public final Progress.Builder getDetails(){ return null; }
        public final ProgressEvent.Builder details(Progress p0){ return null; }
        public final void setDetails(Progress.BuilderImpl p0){}
    }
    static public interface Builder extends CopyableBuilder<ProgressEvent.Builder, ProgressEvent>, SdkPojo
    {
        ProgressEvent.Builder details(Progress p0);
        default ProgressEvent.Builder details(java.util.function.Consumer<Progress.Builder> p0){ return null; }
    }
}
