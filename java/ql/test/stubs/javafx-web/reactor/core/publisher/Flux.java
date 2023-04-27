// Generated automatically from reactor.core.publisher.Flux for testing purposes

package reactor.core.publisher;

import java.time.Duration;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.Callable;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.BiPredicate;
import java.util.function.BooleanSupplier;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.LongConsumer;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.logging.Level;
import java.util.stream.Collector;
import java.util.stream.Stream;
import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;
import reactor.core.CorePublisher;
import reactor.core.CoreSubscriber;
import reactor.core.Disposable;
import reactor.core.observability.SignalListener;
import reactor.core.observability.SignalListenerFactory;
import reactor.core.publisher.BufferOverflowStrategy;
import reactor.core.publisher.ConnectableFlux;
import reactor.core.publisher.FluxSink;
import reactor.core.publisher.GroupedFlux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.ParallelFlux;
import reactor.core.publisher.Signal;
import reactor.core.publisher.SignalType;
import reactor.core.publisher.SynchronousSink;
import reactor.core.publisher.Timed;
import reactor.core.scheduler.Scheduler;
import reactor.util.Logger;
import reactor.util.context.Context;
import reactor.util.context.ContextView;
import reactor.util.function.Tuple2;
import reactor.util.function.Tuple3;
import reactor.util.function.Tuple4;
import reactor.util.function.Tuple5;
import reactor.util.function.Tuple6;
import reactor.util.function.Tuple7;
import reactor.util.function.Tuple8;
import reactor.util.retry.Retry;

abstract public class Flux<T> implements reactor.core.CorePublisher<T>
{
    protected static <T> reactor.core.publisher.ConnectableFlux<T> onAssembly(reactor.core.publisher.ConnectableFlux<T> p0){ return null; }
    protected static <T> reactor.core.publisher.Flux<T> onAssembly(reactor.core.publisher.Flux<T> p0){ return null; }
    public Flux(){}
    public Flux<T> hide(){ return null; }
    public String toString(){ return null; }
    public abstract void subscribe(reactor.core.CoreSubscriber<? super T> p0);
    public final <A> reactor.core.publisher.Flux<A> scan(A p0, java.util.function.BiFunction<A, ? super T, A> p1){ return null; }
    public final <A> reactor.core.publisher.Flux<A> scanWith(java.util.function.Supplier<A> p0, java.util.function.BiFunction<A, ? super T, A> p1){ return null; }
    public final <A> reactor.core.publisher.Mono<A> reduce(A p0, java.util.function.BiFunction<A, ? super T, A> p1){ return null; }
    public final <A> reactor.core.publisher.Mono<A> reduceWith(java.util.function.Supplier<A> p0, java.util.function.BiFunction<A, ? super T, A> p1){ return null; }
    public final <C extends Collection<? super T>> reactor.core.publisher.Flux<C> buffer(Publisher<? extends Object> p0, java.util.function.Supplier<C> p1){ return null; }
    public final <C extends Collection<? super T>> reactor.core.publisher.Flux<C> buffer(int p0, int p1, java.util.function.Supplier<C> p2){ return null; }
    public final <C extends Collection<? super T>> reactor.core.publisher.Flux<C> buffer(int p0, java.util.function.Supplier<C> p1){ return null; }
    public final <C extends Collection<? super T>> reactor.core.publisher.Flux<C> bufferTimeout(int p0, Duration p1, Scheduler p2, java.util.function.Supplier<C> p3){ return null; }
    public final <C extends Collection<? super T>> reactor.core.publisher.Flux<C> bufferTimeout(int p0, Duration p1, java.util.function.Supplier<C> p2){ return null; }
    public final <E extends Throwable> Flux<T> doOnError(java.lang.Class<E> p0, java.util.function.Consumer<? super E> p1){ return null; }
    public final <E extends Throwable> Flux<T> onErrorContinue(java.lang.Class<E> p0, BiConsumer<Throwable, Object> p1){ return null; }
    public final <E extends Throwable> Flux<T> onErrorContinue(java.util.function.Predicate<E> p0, BiConsumer<Throwable, Object> p1){ return null; }
    public final <E extends Throwable> Flux<T> onErrorMap(java.lang.Class<E> p0, java.util.function.Function<? super E, ? extends Throwable> p1){ return null; }
    public final <E extends Throwable> Flux<T> onErrorResume(java.lang.Class<E> p0, java.util.function.Function<? super E, ? extends org.reactivestreams.Publisher<? extends T>> p1){ return null; }
    public final <E extends Throwable> Flux<T> onErrorReturn(java.lang.Class<E> p0, T p1){ return null; }
    public final <E extends org.reactivestreams.Subscriber<? super T>> E subscribeWith(E p0){ return null; }
    public final <E> Flux<E> cast(java.lang.Class<E> p0){ return null; }
    public final <E> reactor.core.publisher.Mono<E> collect(Supplier<E> p0, java.util.function.BiConsumer<E, ? super T> p1){ return null; }
    public final <I> reactor.core.publisher.Flux<I> index(java.util.function.BiFunction<? super Long, ? super T, ? extends I> p0){ return null; }
    public final <K, V> reactor.core.publisher.Flux<reactor.core.publisher.GroupedFlux<K, V>> groupBy(java.util.function.Function<? super T, ? extends K> p0, java.util.function.Function<? super T, ? extends V> p1){ return null; }
    public final <K, V> reactor.core.publisher.Flux<reactor.core.publisher.GroupedFlux<K, V>> groupBy(java.util.function.Function<? super T, ? extends K> p0, java.util.function.Function<? super T, ? extends V> p1, int p2){ return null; }
    public final <K, V> reactor.core.publisher.Mono<java.util.Map<K, V>> collectMap(java.util.function.Function<? super T, ? extends K> p0, java.util.function.Function<? super T, ? extends V> p1){ return null; }
    public final <K, V> reactor.core.publisher.Mono<java.util.Map<K, V>> collectMap(java.util.function.Function<? super T, ? extends K> p0, java.util.function.Function<? super T, ? extends V> p1, Supplier<java.util.Map<K, V>> p2){ return null; }
    public final <K, V> reactor.core.publisher.Mono<java.util.Map<K, java.util.Collection<V>>> collectMultimap(java.util.function.Function<? super T, ? extends K> p0, java.util.function.Function<? super T, ? extends V> p1){ return null; }
    public final <K, V> reactor.core.publisher.Mono<java.util.Map<K, java.util.Collection<V>>> collectMultimap(java.util.function.Function<? super T, ? extends K> p0, java.util.function.Function<? super T, ? extends V> p1, Supplier<java.util.Map<K, java.util.Collection<V>>> p2){ return null; }
    public final <K> reactor.core.publisher.Flux<reactor.core.publisher.GroupedFlux<K, T>> groupBy(java.util.function.Function<? super T, ? extends K> p0){ return null; }
    public final <K> reactor.core.publisher.Flux<reactor.core.publisher.GroupedFlux<K, T>> groupBy(java.util.function.Function<? super T, ? extends K> p0, int p1){ return null; }
    public final <K> reactor.core.publisher.Mono<java.util.Map<K, T>> collectMap(java.util.function.Function<? super T, ? extends K> p0){ return null; }
    public final <K> reactor.core.publisher.Mono<java.util.Map<K, java.util.Collection<T>>> collectMultimap(java.util.function.Function<? super T, ? extends K> p0){ return null; }
    public final <P> P as(Function<? super Flux<T>, P> p0){ return null; }
    public final <R, A> reactor.core.publisher.Mono<R> collect(java.util.stream.Collector<? super T, A, ? extends R> p0){ return null; }
    public final <R> Flux<T> doOnDiscard(java.lang.Class<R> p0, java.util.function.Consumer<? super R> p1){ return null; }
    public final <R> reactor.core.publisher.Flux<R> concatMapIterable(java.util.function.Function<? super T, ? extends java.lang.Iterable<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.Flux<R> concatMapIterable(java.util.function.Function<? super T, ? extends java.lang.Iterable<? extends R>> p0, int p1){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, java.util.function.Function<? super Throwable, ? extends org.reactivestreams.Publisher<? extends R>> p1, java.util.function.Supplier<? extends org.reactivestreams.Publisher<? extends R>> p2){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapIterable(java.util.function.Function<? super T, ? extends java.lang.Iterable<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapIterable(java.util.function.Function<? super T, ? extends java.lang.Iterable<? extends R>> p0, int p1){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapSequential(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapSequential(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, int p1){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapSequential(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, int p1, int p2){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapSequentialDelayError(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, int p1, int p2){ return null; }
    public final <R> reactor.core.publisher.Flux<R> handle(java.util.function.BiConsumer<? super T, reactor.core.publisher.SynchronousSink<R>> p0){ return null; }
    public final <R> reactor.core.publisher.Flux<R> publish(java.util.function.Function<? super Flux<T>, ? extends org.reactivestreams.Publisher<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.Flux<R> publish(java.util.function.Function<? super Flux<T>, ? extends org.reactivestreams.Publisher<? extends R>> p0, int p1){ return null; }
    public final <T2, V> reactor.core.publisher.Flux<V> zipWith(org.reactivestreams.Publisher<? extends T2> p0, int p1, java.util.function.BiFunction<? super T, ? super T2, ? extends V> p2){ return null; }
    public final <T2, V> reactor.core.publisher.Flux<V> zipWith(org.reactivestreams.Publisher<? extends T2> p0, java.util.function.BiFunction<? super T, ? super T2, ? extends V> p1){ return null; }
    public final <T2, V> reactor.core.publisher.Flux<V> zipWithIterable(java.lang.Iterable<? extends T2> p0, java.util.function.BiFunction<? super T, ? super T2, ? extends V> p1){ return null; }
    public final <T2> reactor.core.publisher.Flux<reactor.util.function.Tuple2<T, T2>> zipWith(org.reactivestreams.Publisher<? extends T2> p0){ return null; }
    public final <T2> reactor.core.publisher.Flux<reactor.util.function.Tuple2<T, T2>> zipWith(org.reactivestreams.Publisher<? extends T2> p0, int p1){ return null; }
    public final <T2> reactor.core.publisher.Flux<reactor.util.function.Tuple2<T, T2>> zipWithIterable(java.lang.Iterable<? extends T2> p0){ return null; }
    public final <TRight, TLeftEnd, TRightEnd, R> reactor.core.publisher.Flux<R> groupJoin(org.reactivestreams.Publisher<? extends TRight> p0, java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<TLeftEnd>> p1, java.util.function.Function<? super TRight, ? extends org.reactivestreams.Publisher<TRightEnd>> p2, java.util.function.BiFunction<? super T, ? super Flux<TRight>, ? extends R> p3){ return null; }
    public final <TRight, TLeftEnd, TRightEnd, R> reactor.core.publisher.Flux<R> join(org.reactivestreams.Publisher<? extends TRight> p0, java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<TLeftEnd>> p1, java.util.function.Function<? super TRight, ? extends org.reactivestreams.Publisher<TRightEnd>> p2, java.util.function.BiFunction<? super T, ? super TRight, ? extends R> p3){ return null; }
    public final <U, R> reactor.core.publisher.Flux<R> withLatestFrom(org.reactivestreams.Publisher<? extends U> p0, java.util.function.BiFunction<? super T, ? super U, ? extends R> p1){ return null; }
    public final <U, V, C extends Collection<? super T>> reactor.core.publisher.Flux<C> bufferWhen(org.reactivestreams.Publisher<U> p0, java.util.function.Function<? super U, ? extends org.reactivestreams.Publisher<V>> p1, java.util.function.Supplier<C> p2){ return null; }
    public final <U, V> Flux<Flux<T>> windowWhen(org.reactivestreams.Publisher<U> p0, java.util.function.Function<? super U, ? extends org.reactivestreams.Publisher<V>> p1){ return null; }
    public final <U, V> Flux<T> timeout(org.reactivestreams.Publisher<U> p0, java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<V>> p1){ return null; }
    public final <U, V> Flux<T> timeout(org.reactivestreams.Publisher<U> p0, java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<V>> p1, org.reactivestreams.Publisher<? extends T> p2){ return null; }
    public final <U, V> reactor.core.publisher.Flux<java.util.List<T>> bufferWhen(org.reactivestreams.Publisher<U> p0, java.util.function.Function<? super U, ? extends org.reactivestreams.Publisher<V>> p1){ return null; }
    public final <U> Flux<T> delaySubscription(org.reactivestreams.Publisher<U> p0){ return null; }
    public final <U> Flux<T> sample(org.reactivestreams.Publisher<U> p0){ return null; }
    public final <U> Flux<T> sampleFirst(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<U>> p0){ return null; }
    public final <U> Flux<T> sampleTimeout(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<U>> p0){ return null; }
    public final <U> Flux<T> sampleTimeout(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<U>> p0, int p1){ return null; }
    public final <U> Flux<T> timeout(org.reactivestreams.Publisher<U> p0){ return null; }
    public final <U> Flux<U> ofType(java.lang.Class<U> p0){ return null; }
    public final <V, C extends Collection<? super V>> Flux<T> distinct(java.util.function.Function<? super T, ? extends V> p0, java.util.function.Supplier<C> p1){ return null; }
    public final <V, C> Flux<T> distinct(java.util.function.Function<? super T, ? extends V> p0, java.util.function.Supplier<C> p1, BiPredicate<C, V> p2, java.util.function.Consumer<C> p3){ return null; }
    public final <V> Flux<Flux<T>> windowUntilChanged(java.util.function.Function<? super T, ? extends V> p0, java.util.function.BiPredicate<? super V, ? super V> p1){ return null; }
    public final <V> Flux<Flux<T>> windowUntilChanged(java.util.function.Function<? super T, ? super V> p0){ return null; }
    public final <V> Flux<T> distinct(java.util.function.Function<? super T, ? extends V> p0){ return null; }
    public final <V> Flux<T> distinctUntilChanged(java.util.function.Function<? super T, ? extends V> p0){ return null; }
    public final <V> Flux<T> distinctUntilChanged(java.util.function.Function<? super T, ? extends V> p0, java.util.function.BiPredicate<? super V, ? super V> p1){ return null; }
    public final <V> reactor.core.publisher.Flux<V> concatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends V>> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> concatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends V>> p0, int p1){ return null; }
    public final <V> reactor.core.publisher.Flux<V> concatMapDelayError(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends V>> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> concatMapDelayError(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends V>> p0, boolean p1, int p2){ return null; }
    public final <V> reactor.core.publisher.Flux<V> concatMapDelayError(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends V>> p0, int p1){ return null; }
    public final <V> reactor.core.publisher.Flux<V> flatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends V>> p0, int p1){ return null; }
    public final <V> reactor.core.publisher.Flux<V> flatMap(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends V>> p0, int p1, int p2){ return null; }
    public final <V> reactor.core.publisher.Flux<V> flatMapDelayError(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends V>> p0, int p1, int p2){ return null; }
    public final <V> reactor.core.publisher.Flux<V> map(java.util.function.Function<? super T, ? extends V> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> mapNotNull(java.util.function.Function<? super T, ? extends V> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> switchMap(java.util.function.Function<? super T, org.reactivestreams.Publisher<? extends V>> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> switchMap(java.util.function.Function<? super T, org.reactivestreams.Publisher<? extends V>> p0, int p1){ return null; }
    public final <V> reactor.core.publisher.Flux<V> switchOnFirst(java.util.function.BiFunction<reactor.core.publisher.Signal<? extends T>, Flux<T>, org.reactivestreams.Publisher<? extends V>> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> switchOnFirst(java.util.function.BiFunction<reactor.core.publisher.Signal<? extends T>, Flux<T>, org.reactivestreams.Publisher<? extends V>> p0, boolean p1){ return null; }
    public final <V> reactor.core.publisher.Flux<V> thenMany(org.reactivestreams.Publisher<V> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> transform(java.util.function.Function<? super Flux<T>, ? extends org.reactivestreams.Publisher<V>> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> transformDeferred(java.util.function.Function<? super Flux<T>, ? extends org.reactivestreams.Publisher<V>> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> transformDeferredContextual(BiFunction<? super Flux<T>, ? super ContextView, ? extends org.reactivestreams.Publisher<V>> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<java.util.List<T>> bufferUntilChanged(java.util.function.Function<? super T, ? extends V> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<java.util.List<T>> bufferUntilChanged(java.util.function.Function<? super T, ? extends V> p0, java.util.function.BiPredicate<? super V, ? super V> p1){ return null; }
    public final <V> reactor.core.publisher.Mono<V> then(reactor.core.publisher.Mono<V> p0){ return null; }
    public final <X> Flux<X> dematerialize(){ return null; }
    public final Disposable subscribe(){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2, Consumer<? super Subscription> p3){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2, Context p3){ return null; }
    public final Flux<Flux<T>> window(Duration p0){ return null; }
    public final Flux<Flux<T>> window(Duration p0, Duration p1){ return null; }
    public final Flux<Flux<T>> window(Duration p0, Duration p1, Scheduler p2){ return null; }
    public final Flux<Flux<T>> window(Duration p0, Scheduler p1){ return null; }
    public final Flux<Flux<T>> window(Publisher<? extends Object> p0){ return null; }
    public final Flux<Flux<T>> window(int p0){ return null; }
    public final Flux<Flux<T>> window(int p0, int p1){ return null; }
    public final Flux<Flux<T>> windowTimeout(int p0, Duration p1){ return null; }
    public final Flux<Flux<T>> windowTimeout(int p0, Duration p1, Scheduler p2){ return null; }
    public final Flux<Flux<T>> windowTimeout(int p0, Duration p1, Scheduler p2, boolean p3){ return null; }
    public final Flux<Flux<T>> windowTimeout(int p0, Duration p1, boolean p2){ return null; }
    public final Flux<Flux<T>> windowUntil(java.util.function.Predicate<T> p0){ return null; }
    public final Flux<Flux<T>> windowUntil(java.util.function.Predicate<T> p0, boolean p1){ return null; }
    public final Flux<Flux<T>> windowUntil(java.util.function.Predicate<T> p0, boolean p1, int p2){ return null; }
    public final Flux<Flux<T>> windowUntilChanged(){ return null; }
    public final Flux<Flux<T>> windowWhile(java.util.function.Predicate<T> p0){ return null; }
    public final Flux<Flux<T>> windowWhile(java.util.function.Predicate<T> p0, int p1){ return null; }
    public final Flux<T> cache(){ return null; }
    public final Flux<T> cache(Duration p0){ return null; }
    public final Flux<T> cache(Duration p0, Scheduler p1){ return null; }
    public final Flux<T> cache(int p0){ return null; }
    public final Flux<T> cache(int p0, Duration p1){ return null; }
    public final Flux<T> cache(int p0, Duration p1, Scheduler p2){ return null; }
    public final Flux<T> cancelOn(Scheduler p0){ return null; }
    public final Flux<T> checkpoint(){ return null; }
    public final Flux<T> checkpoint(String p0){ return null; }
    public final Flux<T> checkpoint(String p0, boolean p1){ return null; }
    public final Flux<T> concatWith(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public final Flux<T> concatWithValues(T... p0){ return null; }
    public final Flux<T> contextCapture(){ return null; }
    public final Flux<T> contextWrite(ContextView p0){ return null; }
    public final Flux<T> contextWrite(Function<Context, Context> p0){ return null; }
    public final Flux<T> defaultIfEmpty(T p0){ return null; }
    public final Flux<T> delayElements(Duration p0){ return null; }
    public final Flux<T> delayElements(Duration p0, Scheduler p1){ return null; }
    public final Flux<T> delaySequence(Duration p0){ return null; }
    public final Flux<T> delaySequence(Duration p0, Scheduler p1){ return null; }
    public final Flux<T> delaySubscription(Duration p0){ return null; }
    public final Flux<T> delaySubscription(Duration p0, Scheduler p1){ return null; }
    public final Flux<T> delayUntil(java.util.function.Function<? super T, ? extends Publisher<? extends Object>> p0){ return null; }
    public final Flux<T> distinct(){ return null; }
    public final Flux<T> distinctUntilChanged(){ return null; }
    public final Flux<T> doAfterTerminate(Runnable p0){ return null; }
    public final Flux<T> doFinally(Consumer<SignalType> p0){ return null; }
    public final Flux<T> doFirst(Runnable p0){ return null; }
    public final Flux<T> doOnCancel(Runnable p0){ return null; }
    public final Flux<T> doOnComplete(Runnable p0){ return null; }
    public final Flux<T> doOnEach(java.util.function.Consumer<? super reactor.core.publisher.Signal<T>> p0){ return null; }
    public final Flux<T> doOnError(Consumer<? super Throwable> p0){ return null; }
    public final Flux<T> doOnError(Predicate<? super Throwable> p0, Consumer<? super Throwable> p1){ return null; }
    public final Flux<T> doOnNext(java.util.function.Consumer<? super T> p0){ return null; }
    public final Flux<T> doOnRequest(LongConsumer p0){ return null; }
    public final Flux<T> doOnSubscribe(Consumer<? super Subscription> p0){ return null; }
    public final Flux<T> doOnTerminate(Runnable p0){ return null; }
    public final Flux<T> expand(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public final Flux<T> expand(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends T>> p0, int p1){ return null; }
    public final Flux<T> expandDeep(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public final Flux<T> expandDeep(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends T>> p0, int p1){ return null; }
    public final Flux<T> filter(java.util.function.Predicate<? super T> p0){ return null; }
    public final Flux<T> filterWhen(java.util.function.Function<? super T, ? extends Publisher<Boolean>> p0){ return null; }
    public final Flux<T> filterWhen(java.util.function.Function<? super T, ? extends Publisher<Boolean>> p0, int p1){ return null; }
    public final Flux<T> limitRate(int p0){ return null; }
    public final Flux<T> limitRate(int p0, int p1){ return null; }
    public final Flux<T> limitRequest(long p0){ return null; }
    public final Flux<T> log(){ return null; }
    public final Flux<T> log(Logger p0){ return null; }
    public final Flux<T> log(Logger p0, Level p1, boolean p2, SignalType... p3){ return null; }
    public final Flux<T> log(String p0){ return null; }
    public final Flux<T> log(String p0, Level p1, SignalType... p2){ return null; }
    public final Flux<T> log(String p0, Level p1, boolean p2, SignalType... p3){ return null; }
    public final Flux<T> mergeComparingWith(org.reactivestreams.Publisher<? extends T> p0, java.util.Comparator<? super T> p1){ return null; }
    public final Flux<T> mergeOrderedWith(org.reactivestreams.Publisher<? extends T> p0, java.util.Comparator<? super T> p1){ return null; }
    public final Flux<T> mergeWith(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public final Flux<T> metrics(){ return null; }
    public final Flux<T> name(String p0){ return null; }
    public final Flux<T> onBackpressureBuffer(){ return null; }
    public final Flux<T> onBackpressureBuffer(Duration p0, int p1, java.util.function.Consumer<? super T> p2){ return null; }
    public final Flux<T> onBackpressureBuffer(Duration p0, int p1, java.util.function.Consumer<? super T> p2, Scheduler p3){ return null; }
    public final Flux<T> onBackpressureBuffer(int p0){ return null; }
    public final Flux<T> onBackpressureBuffer(int p0, BufferOverflowStrategy p1){ return null; }
    public final Flux<T> onBackpressureBuffer(int p0, java.util.function.Consumer<? super T> p1){ return null; }
    public final Flux<T> onBackpressureBuffer(int p0, java.util.function.Consumer<? super T> p1, BufferOverflowStrategy p2){ return null; }
    public final Flux<T> onBackpressureDrop(){ return null; }
    public final Flux<T> onBackpressureDrop(java.util.function.Consumer<? super T> p0){ return null; }
    public final Flux<T> onBackpressureError(){ return null; }
    public final Flux<T> onBackpressureLatest(){ return null; }
    public final Flux<T> onErrorComplete(){ return null; }
    public final Flux<T> onErrorComplete(Class<? extends Throwable> p0){ return null; }
    public final Flux<T> onErrorComplete(Predicate<? super Throwable> p0){ return null; }
    public final Flux<T> onErrorContinue(BiConsumer<Throwable, Object> p0){ return null; }
    public final Flux<T> onErrorMap(Function<? super Throwable, ? extends Throwable> p0){ return null; }
    public final Flux<T> onErrorMap(Predicate<? super Throwable> p0, Function<? super Throwable, ? extends Throwable> p1){ return null; }
    public final Flux<T> onErrorResume(Predicate<? super Throwable> p0, java.util.function.Function<? super Throwable, ? extends org.reactivestreams.Publisher<? extends T>> p1){ return null; }
    public final Flux<T> onErrorResume(java.util.function.Function<? super Throwable, ? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public final Flux<T> onErrorReturn(Predicate<? super Throwable> p0, T p1){ return null; }
    public final Flux<T> onErrorReturn(T p0){ return null; }
    public final Flux<T> onErrorStop(){ return null; }
    public final Flux<T> onTerminateDetach(){ return null; }
    public final Flux<T> or(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public final Flux<T> publishOn(Scheduler p0){ return null; }
    public final Flux<T> publishOn(Scheduler p0, boolean p1, int p2){ return null; }
    public final Flux<T> publishOn(Scheduler p0, int p1){ return null; }
    public final Flux<T> repeat(){ return null; }
    public final Flux<T> repeat(BooleanSupplier p0){ return null; }
    public final Flux<T> repeat(long p0){ return null; }
    public final Flux<T> repeat(long p0, BooleanSupplier p1){ return null; }
    public final Flux<T> repeatWhen(Function<Flux<Long>, ? extends Publisher<? extends Object>> p0){ return null; }
    public final Flux<T> retry(){ return null; }
    public final Flux<T> retry(long p0){ return null; }
    public final Flux<T> retryWhen(Retry p0){ return null; }
    public final Flux<T> sample(Duration p0){ return null; }
    public final Flux<T> sampleFirst(Duration p0){ return null; }
    public final Flux<T> scan(java.util.function.BiFunction<T, T, T> p0){ return null; }
    public final Flux<T> share(){ return null; }
    public final Flux<T> skip(Duration p0){ return null; }
    public final Flux<T> skip(Duration p0, Scheduler p1){ return null; }
    public final Flux<T> skip(long p0){ return null; }
    public final Flux<T> skipLast(int p0){ return null; }
    public final Flux<T> skipUntil(java.util.function.Predicate<? super T> p0){ return null; }
    public final Flux<T> skipUntilOther(Publisher<? extends Object> p0){ return null; }
    public final Flux<T> skipWhile(java.util.function.Predicate<? super T> p0){ return null; }
    public final Flux<T> sort(){ return null; }
    public final Flux<T> sort(java.util.Comparator<? super T> p0){ return null; }
    public final Flux<T> startWith(T... p0){ return null; }
    public final Flux<T> startWith(java.lang.Iterable<? extends T> p0){ return null; }
    public final Flux<T> startWith(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public final Flux<T> subscribeOn(Scheduler p0){ return null; }
    public final Flux<T> subscribeOn(Scheduler p0, boolean p1){ return null; }
    public final Flux<T> switchIfEmpty(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public final Flux<T> tag(String p0, String p1){ return null; }
    public final Flux<T> take(Duration p0){ return null; }
    public final Flux<T> take(Duration p0, Scheduler p1){ return null; }
    public final Flux<T> take(long p0){ return null; }
    public final Flux<T> take(long p0, boolean p1){ return null; }
    public final Flux<T> takeLast(int p0){ return null; }
    public final Flux<T> takeUntil(java.util.function.Predicate<? super T> p0){ return null; }
    public final Flux<T> takeUntilOther(Publisher<? extends Object> p0){ return null; }
    public final Flux<T> takeWhile(java.util.function.Predicate<? super T> p0){ return null; }
    public final Flux<T> tap(java.util.function.Function<ContextView, reactor.core.observability.SignalListener<T>> p0){ return null; }
    public final Flux<T> tap(java.util.function.Supplier<reactor.core.observability.SignalListener<T>> p0){ return null; }
    public final Flux<T> tap(reactor.core.observability.SignalListenerFactory<T, ? extends Object> p0){ return null; }
    public final Flux<T> timeout(Duration p0){ return null; }
    public final Flux<T> timeout(Duration p0, Scheduler p1){ return null; }
    public final Flux<T> timeout(Duration p0, org.reactivestreams.Publisher<? extends T> p1){ return null; }
    public final Flux<T> timeout(Duration p0, org.reactivestreams.Publisher<? extends T> p1, Scheduler p2){ return null; }
    public final Mono<Boolean> all(java.util.function.Predicate<? super T> p0){ return null; }
    public final Mono<Boolean> any(java.util.function.Predicate<? super T> p0){ return null; }
    public final Mono<Boolean> hasElement(T p0){ return null; }
    public final Mono<Boolean> hasElements(){ return null; }
    public final Mono<Long> count(){ return null; }
    public final Mono<Void> then(){ return null; }
    public final Mono<Void> thenEmpty(Publisher<Void> p0){ return null; }
    public final T blockFirst(){ return null; }
    public final T blockFirst(Duration p0){ return null; }
    public final T blockLast(){ return null; }
    public final T blockLast(Duration p0){ return null; }
    public final java.lang.Iterable<T> toIterable(){ return null; }
    public final java.lang.Iterable<T> toIterable(int p0){ return null; }
    public final java.lang.Iterable<T> toIterable(int p0, java.util.function.Supplier<java.util.Queue<T>> p1){ return null; }
    public final java.util.stream.Stream<T> toStream(){ return null; }
    public final java.util.stream.Stream<T> toStream(int p0){ return null; }
    public final reactor.core.publisher.ConnectableFlux<T> publish(){ return null; }
    public final reactor.core.publisher.ConnectableFlux<T> publish(int p0){ return null; }
    public final reactor.core.publisher.ConnectableFlux<T> replay(){ return null; }
    public final reactor.core.publisher.ConnectableFlux<T> replay(Duration p0){ return null; }
    public final reactor.core.publisher.ConnectableFlux<T> replay(Duration p0, Scheduler p1){ return null; }
    public final reactor.core.publisher.ConnectableFlux<T> replay(int p0){ return null; }
    public final reactor.core.publisher.ConnectableFlux<T> replay(int p0, Duration p1){ return null; }
    public final reactor.core.publisher.ConnectableFlux<T> replay(int p0, Duration p1, Scheduler p2){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> buffer(){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> buffer(Duration p0){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> buffer(Duration p0, Duration p1){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> buffer(Duration p0, Duration p1, Scheduler p2){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> buffer(Duration p0, Scheduler p1){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> buffer(Publisher<? extends Object> p0){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> buffer(int p0){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> buffer(int p0, int p1){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> bufferTimeout(int p0, Duration p1){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> bufferTimeout(int p0, Duration p1, Scheduler p2){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> bufferUntil(java.util.function.Predicate<? super T> p0){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> bufferUntil(java.util.function.Predicate<? super T> p0, boolean p1){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> bufferUntilChanged(){ return null; }
    public final reactor.core.publisher.Flux<java.util.List<T>> bufferWhile(java.util.function.Predicate<? super T> p0){ return null; }
    public final reactor.core.publisher.Flux<reactor.core.publisher.Signal<T>> materialize(){ return null; }
    public final reactor.core.publisher.Flux<reactor.core.publisher.Timed<T>> timed(){ return null; }
    public final reactor.core.publisher.Flux<reactor.core.publisher.Timed<T>> timed(Scheduler p0){ return null; }
    public final reactor.core.publisher.Flux<reactor.util.function.Tuple2<Long, T>> elapsed(){ return null; }
    public final reactor.core.publisher.Flux<reactor.util.function.Tuple2<Long, T>> elapsed(Scheduler p0){ return null; }
    public final reactor.core.publisher.Flux<reactor.util.function.Tuple2<Long, T>> index(){ return null; }
    public final reactor.core.publisher.Flux<reactor.util.function.Tuple2<Long, T>> timestamp(){ return null; }
    public final reactor.core.publisher.Flux<reactor.util.function.Tuple2<Long, T>> timestamp(Scheduler p0){ return null; }
    public final reactor.core.publisher.Mono<T> elementAt(int p0){ return null; }
    public final reactor.core.publisher.Mono<T> elementAt(int p0, T p1){ return null; }
    public final reactor.core.publisher.Mono<T> ignoreElements(){ return null; }
    public final reactor.core.publisher.Mono<T> last(){ return null; }
    public final reactor.core.publisher.Mono<T> last(T p0){ return null; }
    public final reactor.core.publisher.Mono<T> next(){ return null; }
    public final reactor.core.publisher.Mono<T> publishNext(){ return null; }
    public final reactor.core.publisher.Mono<T> reduce(java.util.function.BiFunction<T, T, T> p0){ return null; }
    public final reactor.core.publisher.Mono<T> shareNext(){ return null; }
    public final reactor.core.publisher.Mono<T> single(){ return null; }
    public final reactor.core.publisher.Mono<T> single(T p0){ return null; }
    public final reactor.core.publisher.Mono<T> singleOrEmpty(){ return null; }
    public final reactor.core.publisher.Mono<java.util.List<T>> collectList(){ return null; }
    public final reactor.core.publisher.Mono<java.util.List<T>> collectSortedList(){ return null; }
    public final reactor.core.publisher.Mono<java.util.List<T>> collectSortedList(java.util.Comparator<? super T> p0){ return null; }
    public final reactor.core.publisher.ParallelFlux<T> parallel(){ return null; }
    public final reactor.core.publisher.ParallelFlux<T> parallel(int p0){ return null; }
    public final reactor.core.publisher.ParallelFlux<T> parallel(int p0, int p1){ return null; }
    public final void subscribe(org.reactivestreams.Subscriber<? super T> p0){}
    public int getPrefetch(){ return 0; }
    public static <I extends java.lang.Comparable<? super I>> reactor.core.publisher.Flux<I> mergeComparing(org.reactivestreams.Publisher<? extends I>... p0){ return null; }
    public static <I extends java.lang.Comparable<? super I>> reactor.core.publisher.Flux<I> mergeOrdered(org.reactivestreams.Publisher<? extends I>... p0){ return null; }
    public static <I extends java.lang.Comparable<? super I>> reactor.core.publisher.Flux<I> mergePriority(org.reactivestreams.Publisher<? extends I>... p0){ return null; }
    public static <I, O> reactor.core.publisher.Flux<O> zip(java.util.function.Function<? super Object[], ? extends O> p0, int p1, org.reactivestreams.Publisher<? extends I>... p2){ return null; }
    public static <I, O> reactor.core.publisher.Flux<O> zip(java.util.function.Function<? super Object[], ? extends O> p0, org.reactivestreams.Publisher<? extends I>... p1){ return null; }
    public static <I> reactor.core.publisher.Flux<I> first(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends I>> p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> first(org.reactivestreams.Publisher<? extends I>... p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> firstWithSignal(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends I>> p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> firstWithSignal(org.reactivestreams.Publisher<? extends I>... p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> firstWithValue(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends I>> p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> firstWithValue(org.reactivestreams.Publisher<? extends I> p0, org.reactivestreams.Publisher<? extends I>... p1){ return null; }
    public static <I> reactor.core.publisher.Flux<I> merge(int p0, org.reactivestreams.Publisher<? extends I>... p1){ return null; }
    public static <I> reactor.core.publisher.Flux<I> merge(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends I>> p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> merge(org.reactivestreams.Publisher<? extends I>... p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> mergeDelayError(int p0, org.reactivestreams.Publisher<? extends I>... p1){ return null; }
    public static <I> reactor.core.publisher.Flux<I> mergeSequential(int p0, org.reactivestreams.Publisher<? extends I>... p1){ return null; }
    public static <I> reactor.core.publisher.Flux<I> mergeSequential(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends I>> p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> mergeSequential(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends I>> p0, int p1, int p2){ return null; }
    public static <I> reactor.core.publisher.Flux<I> mergeSequential(org.reactivestreams.Publisher<? extends I>... p0){ return null; }
    public static <I> reactor.core.publisher.Flux<I> mergeSequentialDelayError(int p0, org.reactivestreams.Publisher<? extends I>... p1){ return null; }
    public static <I> reactor.core.publisher.Flux<I> mergeSequentialDelayError(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends I>> p0, int p1, int p2){ return null; }
    public static <O> reactor.core.publisher.Flux<O> error(Throwable p0, boolean p1){ return null; }
    public static <O> reactor.core.publisher.Flux<O> zip(Iterable<? extends Publisher<? extends Object>> p0, int p1, java.util.function.Function<? super Object[], ? extends O> p2){ return null; }
    public static <O> reactor.core.publisher.Flux<O> zip(Iterable<? extends Publisher<? extends Object>> p0, java.util.function.Function<? super Object[], ? extends O> p1){ return null; }
    public static <T, D> reactor.core.publisher.Flux<T> using(java.util.concurrent.Callable<? extends D> p0, java.util.function.Function<? super D, ? extends org.reactivestreams.Publisher<? extends T>> p1, java.util.function.Consumer<? super D> p2){ return null; }
    public static <T, D> reactor.core.publisher.Flux<T> using(java.util.concurrent.Callable<? extends D> p0, java.util.function.Function<? super D, ? extends org.reactivestreams.Publisher<? extends T>> p1, java.util.function.Consumer<? super D> p2, boolean p3){ return null; }
    public static <T, D> reactor.core.publisher.Flux<T> usingWhen(org.reactivestreams.Publisher<D> p0, java.util.function.Function<? super D, ? extends org.reactivestreams.Publisher<? extends T>> p1, java.util.function.Function<? super D, ? extends Publisher<? extends Object>> p2){ return null; }
    public static <T, D> reactor.core.publisher.Flux<T> usingWhen(org.reactivestreams.Publisher<D> p0, java.util.function.Function<? super D, ? extends org.reactivestreams.Publisher<? extends T>> p1, java.util.function.Function<? super D, ? extends Publisher<? extends Object>> p2, java.util.function.BiFunction<? super D, ? super Throwable, ? extends Publisher<? extends Object>> p3, java.util.function.Function<? super D, ? extends Publisher<? extends Object>> p4){ return null; }
    public static <T, S> reactor.core.publisher.Flux<T> generate(java.util.concurrent.Callable<S> p0, java.util.function.BiFunction<S, reactor.core.publisher.SynchronousSink<T>, S> p1){ return null; }
    public static <T, S> reactor.core.publisher.Flux<T> generate(java.util.concurrent.Callable<S> p0, java.util.function.BiFunction<S, reactor.core.publisher.SynchronousSink<T>, S> p1, Consumer<? super S> p2){ return null; }
    public static <T, V> reactor.core.publisher.Flux<V> combineLatest(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends T>> p0, int p1, java.util.function.Function<Object[], V> p2){ return null; }
    public static <T, V> reactor.core.publisher.Flux<V> combineLatest(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends T>> p0, java.util.function.Function<Object[], V> p1){ return null; }
    public static <T, V> reactor.core.publisher.Flux<V> combineLatest(java.util.function.Function<Object[], V> p0, int p1, org.reactivestreams.Publisher<? extends T>... p2){ return null; }
    public static <T, V> reactor.core.publisher.Flux<V> combineLatest(java.util.function.Function<Object[], V> p0, org.reactivestreams.Publisher<? extends T>... p1){ return null; }
    public static <T1, T2, O> reactor.core.publisher.Flux<O> zip(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, java.util.function.BiFunction<? super T1, ? super T2, ? extends O> p2){ return null; }
    public static <T1, T2, T3, T4, T5, T6, T7, T8> Flux<reactor.util.function.Tuple8<T1, T2, T3, T4, T5, T6, T7, T8>> zip(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, org.reactivestreams.Publisher<? extends T4> p3, org.reactivestreams.Publisher<? extends T5> p4, org.reactivestreams.Publisher<? extends T6> p5, org.reactivestreams.Publisher<? extends T7> p6, org.reactivestreams.Publisher<? extends T8> p7){ return null; }
    public static <T1, T2, T3, T4, T5, T6, T7> Flux<reactor.util.function.Tuple7<T1, T2, T3, T4, T5, T6, T7>> zip(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, org.reactivestreams.Publisher<? extends T4> p3, org.reactivestreams.Publisher<? extends T5> p4, org.reactivestreams.Publisher<? extends T6> p5, org.reactivestreams.Publisher<? extends T7> p6){ return null; }
    public static <T1, T2, T3, T4, T5, T6, V> reactor.core.publisher.Flux<V> combineLatest(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, org.reactivestreams.Publisher<? extends T4> p3, org.reactivestreams.Publisher<? extends T5> p4, org.reactivestreams.Publisher<? extends T6> p5, java.util.function.Function<Object[], V> p6){ return null; }
    public static <T1, T2, T3, T4, T5, T6> Flux<reactor.util.function.Tuple6<T1, T2, T3, T4, T5, T6>> zip(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, org.reactivestreams.Publisher<? extends T4> p3, org.reactivestreams.Publisher<? extends T5> p4, org.reactivestreams.Publisher<? extends T6> p5){ return null; }
    public static <T1, T2, T3, T4, T5, V> reactor.core.publisher.Flux<V> combineLatest(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, org.reactivestreams.Publisher<? extends T4> p3, org.reactivestreams.Publisher<? extends T5> p4, java.util.function.Function<Object[], V> p5){ return null; }
    public static <T1, T2, T3, T4, T5> Flux<reactor.util.function.Tuple5<T1, T2, T3, T4, T5>> zip(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, org.reactivestreams.Publisher<? extends T4> p3, org.reactivestreams.Publisher<? extends T5> p4){ return null; }
    public static <T1, T2, T3, T4, V> reactor.core.publisher.Flux<V> combineLatest(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, org.reactivestreams.Publisher<? extends T4> p3, java.util.function.Function<Object[], V> p4){ return null; }
    public static <T1, T2, T3, T4> Flux<reactor.util.function.Tuple4<T1, T2, T3, T4>> zip(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, org.reactivestreams.Publisher<? extends T4> p3){ return null; }
    public static <T1, T2, T3, V> reactor.core.publisher.Flux<V> combineLatest(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2, java.util.function.Function<Object[], V> p3){ return null; }
    public static <T1, T2, T3> Flux<reactor.util.function.Tuple3<T1, T2, T3>> zip(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, org.reactivestreams.Publisher<? extends T3> p2){ return null; }
    public static <T1, T2, V> reactor.core.publisher.Flux<V> combineLatest(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1, BiFunction<? super T1, ? super T2, ? extends V> p2){ return null; }
    public static <T1, T2> Flux<reactor.util.function.Tuple2<T1, T2>> zip(org.reactivestreams.Publisher<? extends T1> p0, org.reactivestreams.Publisher<? extends T2> p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> concat(java.lang.Iterable<? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> concat(org.reactivestreams.Publisher<? extends T>... p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> concat(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> concat(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0, int p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> concatDelayError(org.reactivestreams.Publisher<? extends T>... p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> concatDelayError(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> concatDelayError(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0, boolean p1, int p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> concatDelayError(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0, int p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> create(java.util.function.Consumer<? super reactor.core.publisher.FluxSink<T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> create(java.util.function.Consumer<? super reactor.core.publisher.FluxSink<T>> p0, FluxSink.OverflowStrategy p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> defer(Supplier<? extends org.reactivestreams.Publisher<T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> deferContextual(Function<ContextView, ? extends org.reactivestreams.Publisher<T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> empty(){ return null; }
    public static <T> reactor.core.publisher.Flux<T> error(Supplier<? extends Throwable> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> error(Throwable p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> from(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> fromArray(T[] p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> fromIterable(java.lang.Iterable<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> fromStream(Supplier<java.util.stream.Stream<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> fromStream(java.util.stream.Stream<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> generate(Consumer<reactor.core.publisher.SynchronousSink<T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> just(T p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> just(T... p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> merge(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> merge(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0, int p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> merge(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0, int p1, int p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergeComparing(int p0, java.util.Comparator<? super T> p1, org.reactivestreams.Publisher<? extends T>... p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergeComparing(java.util.Comparator<? super T> p0, org.reactivestreams.Publisher<? extends T>... p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergeComparingDelayError(int p0, java.util.Comparator<? super T> p1, org.reactivestreams.Publisher<? extends T>... p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergeOrdered(int p0, java.util.Comparator<? super T> p1, org.reactivestreams.Publisher<? extends T>... p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergeOrdered(java.util.Comparator<? super T> p0, org.reactivestreams.Publisher<? extends T>... p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergePriority(int p0, java.util.Comparator<? super T> p1, org.reactivestreams.Publisher<? extends T>... p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergePriority(java.util.Comparator<? super T> p0, org.reactivestreams.Publisher<? extends T>... p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergePriorityDelayError(int p0, java.util.Comparator<? super T> p1, org.reactivestreams.Publisher<? extends T>... p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergeSequential(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergeSequential(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0, int p1, int p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> mergeSequentialDelayError(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0, int p1, int p2){ return null; }
    public static <T> reactor.core.publisher.Flux<T> never(){ return null; }
    public static <T> reactor.core.publisher.Flux<T> push(java.util.function.Consumer<? super reactor.core.publisher.FluxSink<T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> push(java.util.function.Consumer<? super reactor.core.publisher.FluxSink<T>> p0, FluxSink.OverflowStrategy p1){ return null; }
    public static <T> reactor.core.publisher.Flux<T> switchOnNext(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Flux<T> switchOnNext(org.reactivestreams.Publisher<? extends org.reactivestreams.Publisher<? extends T>> p0, int p1){ return null; }
    public static <TUPLE extends Tuple2, V> reactor.core.publisher.Flux<V> zip(Publisher<? extends Publisher<? extends Object>> p0, Function<? super TUPLE, ? extends V> p1){ return null; }
    public static Flux<Integer> range(int p0, int p1){ return null; }
    public static Flux<Long> interval(Duration p0){ return null; }
    public static Flux<Long> interval(Duration p0, Duration p1){ return null; }
    public static Flux<Long> interval(Duration p0, Duration p1, Scheduler p2){ return null; }
    public static Flux<Long> interval(Duration p0, Scheduler p1){ return null; }
}
