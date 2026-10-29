// Generated automatically from reactor.core.publisher.ConnectableFlux for testing purposes

package reactor.core.publisher;

import java.time.Duration;
import java.util.function.Consumer;
import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.core.scheduler.Scheduler;

abstract public class ConnectableFlux<T> extends reactor.core.publisher.Flux<T>
{
    public ConnectableFlux(){}
    public abstract void connect(Consumer<? super Disposable> p0);
    public final ConnectableFlux<T> hide(){ return null; }
    public final Disposable connect(){ return null; }
    public final reactor.core.publisher.Flux<T> autoConnect(){ return null; }
    public final reactor.core.publisher.Flux<T> autoConnect(int p0){ return null; }
    public final reactor.core.publisher.Flux<T> autoConnect(int p0, Consumer<? super Disposable> p1){ return null; }
    public final reactor.core.publisher.Flux<T> refCount(){ return null; }
    public final reactor.core.publisher.Flux<T> refCount(int p0){ return null; }
    public final reactor.core.publisher.Flux<T> refCount(int p0, Duration p1){ return null; }
    public final reactor.core.publisher.Flux<T> refCount(int p0, Duration p1, Scheduler p2){ return null; }
}
