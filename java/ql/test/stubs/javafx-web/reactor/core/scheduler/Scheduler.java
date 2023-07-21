// Generated automatically from reactor.core.scheduler.Scheduler for testing purposes

package reactor.core.scheduler;

import java.util.concurrent.TimeUnit;
import reactor.core.Disposable;
import reactor.core.publisher.Mono;

public interface Scheduler extends Disposable
{
    Disposable schedule(Runnable p0);
    Scheduler.Worker createWorker();
    default Disposable schedule(Runnable p0, long p1, TimeUnit p2){ return null; }
    default Disposable schedulePeriodically(Runnable p0, long p1, long p2, TimeUnit p3){ return null; }
    default Mono<Void> disposeGracefully(){ return null; }
    default long now(TimeUnit p0){ return 0; }
    default void dispose(){}
    default void init(){}
    default void start(){}
    static public interface Worker extends Disposable
    {
        Disposable schedule(Runnable p0);
        default Disposable schedule(Runnable p0, long p1, TimeUnit p2){ return null; }
        default Disposable schedulePeriodically(Runnable p0, long p1, long p2, TimeUnit p3){ return null; }
    }
}
