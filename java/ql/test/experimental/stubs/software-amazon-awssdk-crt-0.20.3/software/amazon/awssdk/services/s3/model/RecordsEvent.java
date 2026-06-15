// Generated automatically from software.amazon.awssdk.services.s3.model.RecordsEvent for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.SelectObjectContentEventStream;
import software.amazon.awssdk.services.s3.model.SelectObjectContentResponseHandler;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class RecordsEvent implements SdkPojo, SelectObjectContentEventStream, Serializable, ToCopyableBuilder<RecordsEvent.Builder, RecordsEvent>
{
    protected RecordsEvent() {}
    protected RecordsEvent(RecordsEvent.BuilderImpl p0){}
    public RecordsEvent.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RecordsEvent copy(java.util.function.Consumer<? super RecordsEvent.Builder> p0){ return null; }
    public final SdkBytes payload(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static RecordsEvent.Builder builder(){ return null; }
    public static java.lang.Class<? extends RecordsEvent.Builder> serializableBuilderClass(){ return null; }
    public void accept(SelectObjectContentResponseHandler.Visitor p0){}
    static class BuilderImpl implements RecordsEvent.Builder
    {
        protected BuilderImpl(){}
        protected BuilderImpl(RecordsEvent p0){}
        public List<SdkField<? extends Object>> sdkFields(){ return null; }
        public RecordsEvent build(){ return null; }
        public final ByteBuffer getPayload(){ return null; }
        public final RecordsEvent.Builder payload(SdkBytes p0){ return null; }
        public final void setPayload(ByteBuffer p0){}
    }
    static public interface Builder extends CopyableBuilder<RecordsEvent.Builder, RecordsEvent>, SdkPojo
    {
        RecordsEvent.Builder payload(SdkBytes p0);
    }
}
