// Generated automatically from reactor.util.retry.RetryBackoffSpec for testing purposes

package reactor.util.retry;

import java.time.Duration;
import java.util.function.BiFunction;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Scheduler;
import reactor.util.context.ContextView;
import reactor.util.retry.Retry;

public class RetryBackoffSpec extends Retry
{
    protected RetryBackoffSpec() {}
    protected void validateArguments(){}
    public Flux<Long> generateCompanion(Flux<Retry.RetrySignal> p0){ return null; }
    public RetryBackoffSpec doAfterRetry(Consumer<Retry.RetrySignal> p0){ return null; }
    public RetryBackoffSpec doAfterRetryAsync(Function<Retry.RetrySignal, Mono<Void>> p0){ return null; }
    public RetryBackoffSpec doBeforeRetry(Consumer<Retry.RetrySignal> p0){ return null; }
    public RetryBackoffSpec doBeforeRetryAsync(Function<Retry.RetrySignal, Mono<Void>> p0){ return null; }
    public RetryBackoffSpec filter(Predicate<? super Throwable> p0){ return null; }
    public RetryBackoffSpec jitter(double p0){ return null; }
    public RetryBackoffSpec maxAttempts(long p0){ return null; }
    public RetryBackoffSpec maxBackoff(Duration p0){ return null; }
    public RetryBackoffSpec minBackoff(Duration p0){ return null; }
    public RetryBackoffSpec modifyErrorFilter(Function<Predicate<Throwable>, Predicate<? super Throwable>> p0){ return null; }
    public RetryBackoffSpec onRetryExhaustedThrow(BiFunction<RetryBackoffSpec, Retry.RetrySignal, Throwable> p0){ return null; }
    public RetryBackoffSpec scheduler(Scheduler p0){ return null; }
    public RetryBackoffSpec transientErrors(boolean p0){ return null; }
    public RetryBackoffSpec withRetryContext(ContextView p0){ return null; }
    public final Duration maxBackoff = null;
    public final Duration minBackoff = null;
    public final Predicate<Throwable> errorFilter = null;
    public final Supplier<Scheduler> backoffSchedulerSupplier = null;
    public final boolean isTransientErrors = false;
    public final double jitterFactor = 0;
    public final long maxAttempts = 0;
}
