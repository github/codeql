// Generated automatically from software.amazon.awssdk.awscore.eventstream.EventStreamResponseHandler for testing purposes

package software.amazon.awssdk.awscore.eventstream;

import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Supplier;
import org.reactivestreams.Subscriber;
import software.amazon.awssdk.core.async.SdkPublisher;

public interface EventStreamResponseHandler<ResponseT, EventT>
{
    static public interface Builder<ResponseT, EventT, SubBuilderT>
    {
        SubBuilderT onComplete(Runnable p0);
        SubBuilderT onError(Consumer<Throwable> p0);
        SubBuilderT onEventStream(Consumer<software.amazon.awssdk.core.async.SdkPublisher<EventT>> p0);
        SubBuilderT onResponse(Consumer<ResponseT> p0);
        SubBuilderT publisherTransformer(Function<software.amazon.awssdk.core.async.SdkPublisher<EventT>, software.amazon.awssdk.core.async.SdkPublisher<EventT>> p0);
        SubBuilderT subscriber(Consumer<EventT> p0);
        SubBuilderT subscriber(Supplier<Subscriber<EventT>> p0);
    }
    void complete();
    void exceptionOccurred(Throwable p0);
    void onEventStream(software.amazon.awssdk.core.async.SdkPublisher<EventT> p0);
    void responseReceived(ResponseT p0);
}
