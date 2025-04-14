// Generated automatically from software.amazon.awssdk.services.s3.model.SelectObjectContentResponseHandler for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.function.Consumer;
import software.amazon.awssdk.awscore.eventstream.EventStreamResponseHandler;
import software.amazon.awssdk.services.s3.model.ContinuationEvent;
import software.amazon.awssdk.services.s3.model.EndEvent;
import software.amazon.awssdk.services.s3.model.ProgressEvent;
import software.amazon.awssdk.services.s3.model.RecordsEvent;
import software.amazon.awssdk.services.s3.model.SelectObjectContentEventStream;
import software.amazon.awssdk.services.s3.model.SelectObjectContentResponse;
import software.amazon.awssdk.services.s3.model.StatsEvent;

public interface SelectObjectContentResponseHandler extends EventStreamResponseHandler<SelectObjectContentResponse, SelectObjectContentEventStream>
{
    static SelectObjectContentResponseHandler.Builder builder(){ return null; }
    static public interface Builder extends EventStreamResponseHandler.Builder<SelectObjectContentResponse, SelectObjectContentEventStream, SelectObjectContentResponseHandler.Builder>
    {
        SelectObjectContentResponseHandler build();
        SelectObjectContentResponseHandler.Builder subscriber(SelectObjectContentResponseHandler.Visitor p0);
    }
    static public interface Visitor
    {
        default void visitCont(ContinuationEvent p0){}
        default void visitDefault(SelectObjectContentEventStream p0){}
        default void visitEnd(EndEvent p0){}
        default void visitProgress(ProgressEvent p0){}
        default void visitRecords(RecordsEvent p0){}
        default void visitStats(StatsEvent p0){}
        static SelectObjectContentResponseHandler.Visitor.Builder builder(){ return null; }
        static public interface Builder
        {
            SelectObjectContentResponseHandler.Visitor build();
            SelectObjectContentResponseHandler.Visitor.Builder onCont(Consumer<ContinuationEvent> p0);
            SelectObjectContentResponseHandler.Visitor.Builder onDefault(Consumer<SelectObjectContentEventStream> p0);
            SelectObjectContentResponseHandler.Visitor.Builder onEnd(Consumer<EndEvent> p0);
            SelectObjectContentResponseHandler.Visitor.Builder onProgress(Consumer<ProgressEvent> p0);
            SelectObjectContentResponseHandler.Visitor.Builder onRecords(Consumer<RecordsEvent> p0);
            SelectObjectContentResponseHandler.Visitor.Builder onStats(Consumer<StatsEvent> p0);
        }
    }
}
