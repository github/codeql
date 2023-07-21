// Generated automatically from reactor.core.publisher.MonoSink for testing purposes

package reactor.core.publisher;

import java.util.function.LongConsumer;
import reactor.core.Disposable;
import reactor.util.context.Context;
import reactor.util.context.ContextView;

public interface MonoSink<T>
{
    Context currentContext();
    MonoSink<T> onCancel(Disposable p0);
    MonoSink<T> onDispose(Disposable p0);
    MonoSink<T> onRequest(LongConsumer p0);
    default ContextView contextView(){ return null; }
    void error(Throwable p0);
    void success();
    void success(T p0);
}
