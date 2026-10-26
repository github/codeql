// Generated automatically from reactor.util.retry.Retry for testing purposes

package reactor.util.retry;

import java.time.Duration;
import java.util.function.Function;
import org.reactivestreams.Publisher;
import reactor.core.publisher.Flux;
import reactor.util.context.ContextView;
import reactor.util.retry.RetryBackoffSpec;
import reactor.util.retry.RetrySpec;

abstract public class Retry
{
    protected Retry(ContextView p0){}
    public ContextView retryContext(){ return null; }
    public Retry(){}
    public abstract Publisher<? extends Object> generateCompanion(Flux<Retry.RetrySignal> p0);
    public final ContextView retryContext = null;
    public static Retry from(Function<Flux<Retry.RetrySignal>, ? extends Publisher<? extends Object>> p0){ return null; }
    public static Retry withThrowable(Function<Flux<Throwable>, ? extends Publisher<? extends Object>> p0){ return null; }
    public static RetryBackoffSpec backoff(long p0, Duration p1){ return null; }
    public static RetryBackoffSpec fixedDelay(long p0, Duration p1){ return null; }
    public static RetrySpec indefinitely(){ return null; }
    public static RetrySpec max(long p0){ return null; }
    public static RetrySpec maxInARow(long p0){ return null; }
    static public interface RetrySignal
    {
        Throwable failure();
        default ContextView retryContextView(){ return null; }
        default Retry.RetrySignal copy(){ return null; }
        long totalRetries();
        long totalRetriesInARow();
    }
}
