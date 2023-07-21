// Generated automatically from reactor.core.observability.SignalListener for testing purposes

package reactor.core.observability;

import reactor.core.publisher.SignalType;
import reactor.util.context.Context;

public interface SignalListener<T>
{
    default Context addToContext(Context p0){ return null; }
    void doAfterComplete();
    void doAfterError(Throwable p0);
    void doFinally(SignalType p0);
    void doFirst();
    void doOnCancel();
    void doOnComplete();
    void doOnError(Throwable p0);
    void doOnFusion(int p0);
    void doOnMalformedOnComplete();
    void doOnMalformedOnError(Throwable p0);
    void doOnMalformedOnNext(T p0);
    void doOnNext(T p0);
    void doOnRequest(long p0);
    void doOnSubscription();
    void handleListenerError(Throwable p0);
}
