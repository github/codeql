// Generated automatically from software.amazon.awssdk.services.s3.model.StatsEvent for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.SelectObjectContentEventStream;
import software.amazon.awssdk.services.s3.model.SelectObjectContentResponseHandler;
import software.amazon.awssdk.services.s3.model.Stats;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class StatsEvent implements SdkPojo, SelectObjectContentEventStream, Serializable, ToCopyableBuilder<StatsEvent.Builder, StatsEvent>
{
    protected StatsEvent() {}
    protected StatsEvent(StatsEvent.BuilderImpl p0){}
    public StatsEvent.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final Stats details(){ return null; }
    public final StatsEvent copy(java.util.function.Consumer<? super StatsEvent.Builder> p0){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static StatsEvent.Builder builder(){ return null; }
    public static java.lang.Class<? extends StatsEvent.Builder> serializableBuilderClass(){ return null; }
    public void accept(SelectObjectContentResponseHandler.Visitor p0){}
    static class BuilderImpl implements StatsEvent.Builder
    {
        protected BuilderImpl(){}
        protected BuilderImpl(StatsEvent p0){}
        public List<SdkField<? extends Object>> sdkFields(){ return null; }
        public StatsEvent build(){ return null; }
        public final Stats.Builder getDetails(){ return null; }
        public final StatsEvent.Builder details(Stats p0){ return null; }
        public final void setDetails(Stats.BuilderImpl p0){}
    }
    static public interface Builder extends CopyableBuilder<StatsEvent.Builder, StatsEvent>, SdkPojo
    {
        StatsEvent.Builder details(Stats p0);
        default StatsEvent.Builder details(java.util.function.Consumer<Stats.Builder> p0){ return null; }
    }
}
