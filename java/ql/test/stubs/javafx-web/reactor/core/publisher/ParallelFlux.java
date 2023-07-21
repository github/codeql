// Generated automatically from reactor.core.publisher.ParallelFlux for testing purposes

package reactor.core.publisher;

import java.util.Comparator;
import java.util.List;
import java.util.Queue;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.LongConsumer;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.logging.Level;
import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;
import reactor.core.CorePublisher;
import reactor.core.CoreSubscriber;
import reactor.core.Disposable;
import reactor.core.publisher.Flux;
import reactor.core.publisher.GroupedFlux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Signal;
import reactor.core.publisher.SignalType;
import reactor.core.scheduler.Scheduler;
import reactor.util.context.Context;

abstract public class ParallelFlux<T> implements reactor.core.CorePublisher<T>
{
    protected final boolean validate(Subscriber<? extends Object>[] p0){ return false; }
    protected static <T> reactor.core.publisher.ParallelFlux<T> onAssembly(reactor.core.publisher.ParallelFlux<T> p0){ return null; }
    public ParallelFlux(){}
    public String toString(){ return null; }
    public abstract int parallelism();
    public abstract void subscribe(reactor.core.CoreSubscriber<? super T>[] p0);
    public final <C> ParallelFlux<C> collect(Supplier<? extends C> p0, BiConsumer<? super C, ? super T> p1){ return null; }
    public final <R> reactor.core.publisher.ParallelFlux<R> concatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.ParallelFlux<R> concatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, int p1){ return null; }
    public final <R> reactor.core.publisher.ParallelFlux<R> concatMapDelayError(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.ParallelFlux<R> flatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.ParallelFlux<R> flatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, boolean p1){ return null; }
    public final <R> reactor.core.publisher.ParallelFlux<R> flatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, boolean p1, int p2){ return null; }
    public final <R> reactor.core.publisher.ParallelFlux<R> flatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, boolean p1, int p2, int p3){ return null; }
    public final <R> reactor.core.publisher.ParallelFlux<R> reduce(java.util.function.Supplier<R> p0, BiFunction<R, ? super T, R> p1){ return null; }
    public final <U> U as(Function<? super ParallelFlux<T>, U> p0){ return null; }
    public final <U> reactor.core.publisher.ParallelFlux<U> map(java.util.function.Function<? super T, ? extends U> p0){ return null; }
    public final <U> reactor.core.publisher.ParallelFlux<U> transform(Function<? super ParallelFlux<T>, reactor.core.publisher.ParallelFlux<U>> p0){ return null; }
    public final <U> reactor.core.publisher.ParallelFlux<U> transformGroups(Function<? super GroupedFlux<Integer, T>, ? extends org.reactivestreams.Publisher<? extends U>> p0){ return null; }
    public final Disposable subscribe(){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2, Consumer<? super Subscription> p3){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2, Context p3){ return null; }
    public final Flux<GroupedFlux<Integer, T>> groups(){ return null; }
    public final Mono<Void> then(){ return null; }
    public final ParallelFlux<T> checkpoint(){ return null; }
    public final ParallelFlux<T> checkpoint(String p0){ return null; }
    public final ParallelFlux<T> checkpoint(String p0, boolean p1){ return null; }
    public final ParallelFlux<T> doAfterTerminate(Runnable p0){ return null; }
    public final ParallelFlux<T> doOnCancel(Runnable p0){ return null; }
    public final ParallelFlux<T> doOnComplete(Runnable p0){ return null; }
    public final ParallelFlux<T> doOnEach(java.util.function.Consumer<? super reactor.core.publisher.Signal<T>> p0){ return null; }
    public final ParallelFlux<T> doOnError(Consumer<? super Throwable> p0){ return null; }
    public final ParallelFlux<T> doOnNext(java.util.function.Consumer<? super T> p0){ return null; }
    public final ParallelFlux<T> doOnRequest(LongConsumer p0){ return null; }
    public final ParallelFlux<T> doOnSubscribe(Consumer<? super Subscription> p0){ return null; }
    public final ParallelFlux<T> doOnTerminate(Runnable p0){ return null; }
    public final ParallelFlux<T> filter(java.util.function.Predicate<? super T> p0){ return null; }
    public final ParallelFlux<T> hide(){ return null; }
    public final ParallelFlux<T> log(){ return null; }
    public final ParallelFlux<T> log(String p0){ return null; }
    public final ParallelFlux<T> log(String p0, Level p1, SignalType... p2){ return null; }
    public final ParallelFlux<T> log(String p0, Level p1, boolean p2, SignalType... p3){ return null; }
    public final ParallelFlux<T> name(String p0){ return null; }
    public final ParallelFlux<T> runOn(Scheduler p0){ return null; }
    public final ParallelFlux<T> runOn(Scheduler p0, int p1){ return null; }
    public final ParallelFlux<T> tag(String p0, String p1){ return null; }
    public final reactor.core.publisher.Flux<T> ordered(java.util.Comparator<? super T> p0){ return null; }
    public final reactor.core.publisher.Flux<T> ordered(java.util.Comparator<? super T> p0, int p1){ return null; }
    public final reactor.core.publisher.Flux<T> sequential(){ return null; }
    public final reactor.core.publisher.Flux<T> sequential(int p0){ return null; }
    public final reactor.core.publisher.Flux<T> sorted(java.util.Comparator<? super T> p0){ return null; }
    public final reactor.core.publisher.Flux<T> sorted(java.util.Comparator<? super T> p0, int p1){ return null; }
    public final reactor.core.publisher.Mono<T> reduce(java.util.function.BiFunction<T, T, T> p0){ return null; }
    public final reactor.core.publisher.Mono<java.util.List<T>> collectSortedList(java.util.Comparator<? super T> p0){ return null; }
    public final reactor.core.publisher.Mono<java.util.List<T>> collectSortedList(java.util.Comparator<? super T> p0, int p1){ return null; }
    public final void subscribe(org.reactivestreams.Subscriber<? super T> p0){}
    public final void subscribe(reactor.core.CoreSubscriber<? super T> p0){}
    public int getPrefetch(){ return 0; }
    public static <T> reactor.core.publisher.ParallelFlux<T> from(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.ParallelFlux<T> from(org.reactivestreams.Publisher<? extends T> p0, int p1){ return null; }
    public static <T> reactor.core.publisher.ParallelFlux<T> from(org.reactivestreams.Publisher<? extends T> p0, int p1, int p2, java.util.function.Supplier<java.util.Queue<T>> p3){ return null; }
    public static <T> reactor.core.publisher.ParallelFlux<T> from(org.reactivestreams.Publisher<T>... p0){ return null; }
}
