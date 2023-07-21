// Generated automatically from reactor.core.publisher.Signal for testing purposes

package reactor.core.publisher;

import java.util.function.Consumer;
import java.util.function.Supplier;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;
import reactor.core.publisher.SignalType;
import reactor.util.context.Context;
import reactor.util.context.ContextView;

public interface Signal<T> extends java.util.function.Consumer<org.reactivestreams.Subscriber<? super T>>, java.util.function.Supplier<T>
{
    ContextView getContextView();
    SignalType getType();
    Subscription getSubscription();
    T get();
    Throwable getThrowable();
    default boolean hasError(){ return false; }
    default boolean hasValue(){ return false; }
    default boolean isOnComplete(){ return false; }
    default boolean isOnError(){ return false; }
    default boolean isOnNext(){ return false; }
    default boolean isOnSubscribe(){ return false; }
    default void accept(org.reactivestreams.Subscriber<? super T> p0){}
    static <T> reactor.core.publisher.Signal<T> complete(){ return null; }
    static <T> reactor.core.publisher.Signal<T> complete(Context p0){ return null; }
    static <T> reactor.core.publisher.Signal<T> error(Throwable p0){ return null; }
    static <T> reactor.core.publisher.Signal<T> error(Throwable p0, Context p1){ return null; }
    static <T> reactor.core.publisher.Signal<T> next(T p0){ return null; }
    static <T> reactor.core.publisher.Signal<T> next(T p0, Context p1){ return null; }
    static <T> reactor.core.publisher.Signal<T> subscribe(Subscription p0){ return null; }
    static <T> reactor.core.publisher.Signal<T> subscribe(Subscription p0, Context p1){ return null; }
    static boolean isComplete(Object p0){ return false; }
    static boolean isError(Object p0){ return false; }
}
