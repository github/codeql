// Generated automatically from software.amazon.awssdk.core.async.SdkPublisher for testing purposes

package software.amazon.awssdk.core.async;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import org.reactivestreams.Publisher;

public interface SdkPublisher<T> extends org.reactivestreams.Publisher<T>
{
    default <U extends T> software.amazon.awssdk.core.async.SdkPublisher<U> filter(java.lang.Class<U> p0){ return null; }
    default <U> software.amazon.awssdk.core.async.SdkPublisher<U> flatMapIterable(Function<T, Iterable<U>> p0){ return null; }
    default <U> software.amazon.awssdk.core.async.SdkPublisher<U> map(Function<T, U> p0){ return null; }
    default CompletableFuture<Void> subscribe(java.util.function.Consumer<T> p0){ return null; }
    default SdkPublisher<T> doAfterOnCancel(Runnable p0){ return null; }
    default SdkPublisher<T> doAfterOnComplete(Runnable p0){ return null; }
    default SdkPublisher<T> doAfterOnError(Consumer<Throwable> p0){ return null; }
    default SdkPublisher<T> filter(java.util.function.Predicate<T> p0){ return null; }
    default SdkPublisher<T> limit(int p0){ return null; }
    default SdkPublisher<java.util.List<T>> buffer(int p0){ return null; }
    static <T> SdkPublisher<T> adapt(org.reactivestreams.Publisher<T> p0){ return null; }
}
