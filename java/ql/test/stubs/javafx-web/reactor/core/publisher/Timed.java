// Generated automatically from reactor.core.publisher.Timed for testing purposes

package reactor.core.publisher;

import java.time.Duration;
import java.time.Instant;
import java.util.function.Supplier;

public interface Timed<T> extends java.util.function.Supplier<T>
{
    Duration elapsed();
    Duration elapsedSinceSubscription();
    Instant timestamp();
    T get();
}
