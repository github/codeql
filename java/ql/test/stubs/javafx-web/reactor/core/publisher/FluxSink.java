// Generated automatically from reactor.core.publisher.FluxSink for testing purposes

package reactor.core.publisher;

import java.util.function.LongConsumer;
import reactor.core.Disposable;
import reactor.util.context.Context;
import reactor.util.context.ContextView;

public interface FluxSink<T>
{
    Context currentContext();
    FluxSink<T> next(T p0);
    FluxSink<T> onCancel(Disposable p0);
    FluxSink<T> onDispose(Disposable p0);
    FluxSink<T> onRequest(LongConsumer p0);
    boolean isCancelled();
    default ContextView contextView(){ return null; }
    long requestedFromDownstream();
    static public enum OverflowStrategy
    {
        BUFFER, DROP, ERROR, IGNORE, LATEST;
        private OverflowStrategy() {}
    }
    void complete();
    void error(Throwable p0);
}
