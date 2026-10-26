// Generated automatically from reactor.util.retry.RetrySpec for testing purposes

package reactor.util.retry;

import java.util.function.BiFunction;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.context.ContextView;
import reactor.util.retry.Retry;

public class RetrySpec extends Retry
{
    protected RetrySpec() {}
    public Flux<Long> generateCompanion(Flux<Retry.RetrySignal> p0){ return null; }
    public RetrySpec doAfterRetry(Consumer<Retry.RetrySignal> p0){ return null; }
    public RetrySpec doAfterRetryAsync(Function<Retry.RetrySignal, Mono<Void>> p0){ return null; }
    public RetrySpec doBeforeRetry(Consumer<Retry.RetrySignal> p0){ return null; }
    public RetrySpec doBeforeRetryAsync(Function<Retry.RetrySignal, Mono<Void>> p0){ return null; }
    public RetrySpec filter(Predicate<? super Throwable> p0){ return null; }
    public RetrySpec maxAttempts(long p0){ return null; }
    public RetrySpec modifyErrorFilter(Function<Predicate<Throwable>, Predicate<? super Throwable>> p0){ return null; }
    public RetrySpec onRetryExhaustedThrow(BiFunction<RetrySpec, Retry.RetrySignal, Throwable> p0){ return null; }
    public RetrySpec transientErrors(boolean p0){ return null; }
    public RetrySpec withRetryContext(ContextView p0){ return null; }
    public final Predicate<Throwable> errorFilter = null;
    public final boolean isTransientErrors = false;
    public final long maxAttempts = 0;
}
