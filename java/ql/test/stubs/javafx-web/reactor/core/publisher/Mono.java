// Generated automatically from reactor.core.publisher.Mono for testing purposes

package reactor.core.publisher;

import java.time.Duration;
import java.util.Optional;
import java.util.concurrent.Callable;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionStage;
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
import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;
import reactor.core.CorePublisher;
import reactor.core.CoreSubscriber;
import reactor.core.Disposable;
import reactor.core.observability.SignalListener;
import reactor.core.observability.SignalListenerFactory;
import reactor.core.publisher.Flux;
import reactor.core.publisher.MonoSink;
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

abstract public class Mono<T> implements reactor.core.CorePublisher<T>
{
    protected static <T> reactor.core.publisher.Mono<T> onAssembly(reactor.core.publisher.Mono<T> p0){ return null; }
    public Mono(){}
    public String toString(){ return null; }
    public T block(){ return null; }
    public T block(Duration p0){ return null; }
    public abstract void subscribe(reactor.core.CoreSubscriber<? super T> p0);
    public final <E extends Throwable> Mono<T> doOnError(java.lang.Class<E> p0, java.util.function.Consumer<? super E> p1){ return null; }
    public final <E extends Throwable> Mono<T> onErrorContinue(java.lang.Class<E> p0, BiConsumer<Throwable, Object> p1){ return null; }
    public final <E extends Throwable> Mono<T> onErrorContinue(java.util.function.Predicate<E> p0, BiConsumer<Throwable, Object> p1){ return null; }
    public final <E extends Throwable> Mono<T> onErrorMap(java.lang.Class<E> p0, java.util.function.Function<? super E, ? extends Throwable> p1){ return null; }
    public final <E extends Throwable> Mono<T> onErrorResume(java.lang.Class<E> p0, Function<? super E, ? extends reactor.core.publisher.Mono<? extends T>> p1){ return null; }
    public final <E extends Throwable> Mono<T> onErrorReturn(java.lang.Class<E> p0, T p1){ return null; }
    public final <E extends org.reactivestreams.Subscriber<? super T>> E subscribeWith(E p0){ return null; }
    public final <E> reactor.core.publisher.Mono<E> cast(java.lang.Class<E> p0){ return null; }
    public final <P> P as(Function<? super Mono<T>, P> p0){ return null; }
    public final <R> Mono<T> doOnDiscard(java.lang.Class<R> p0, java.util.function.Consumer<? super R> p1){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapIterable(java.util.function.Function<? super T, ? extends java.lang.Iterable<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapMany(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.Flux<R> flatMapMany(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends R>> p0, java.util.function.Function<? super Throwable, ? extends org.reactivestreams.Publisher<? extends R>> p1, java.util.function.Supplier<? extends org.reactivestreams.Publisher<? extends R>> p2){ return null; }
    public final <R> reactor.core.publisher.Mono<R> flatMap(Function<? super T, ? extends reactor.core.publisher.Mono<? extends R>> p0){ return null; }
    public final <R> reactor.core.publisher.Mono<R> handle(java.util.function.BiConsumer<? super T, reactor.core.publisher.SynchronousSink<R>> p0){ return null; }
    public final <R> reactor.core.publisher.Mono<R> map(java.util.function.Function<? super T, ? extends R> p0){ return null; }
    public final <R> reactor.core.publisher.Mono<R> mapNotNull(java.util.function.Function<? super T, ? extends R> p0){ return null; }
    public final <R> reactor.core.publisher.Mono<R> publish(Function<? super Mono<T>, ? extends reactor.core.publisher.Mono<? extends R>> p0){ return null; }
    public final <T2, O> reactor.core.publisher.Mono<O> zipWhen(java.util.function.Function<T, reactor.core.publisher.Mono<? extends T2>> p0, BiFunction<T, T2, O> p1){ return null; }
    public final <T2, O> reactor.core.publisher.Mono<O> zipWith(reactor.core.publisher.Mono<? extends T2> p0, BiFunction<? super T, ? super T2, ? extends O> p1){ return null; }
    public final <T2> reactor.core.publisher.Mono<reactor.util.function.Tuple2<T, T2>> zipWhen(java.util.function.Function<T, reactor.core.publisher.Mono<? extends T2>> p0){ return null; }
    public final <T2> reactor.core.publisher.Mono<reactor.util.function.Tuple2<T, T2>> zipWith(reactor.core.publisher.Mono<? extends T2> p0){ return null; }
    public final <U> Mono<T> delaySubscription(org.reactivestreams.Publisher<U> p0){ return null; }
    public final <U> Mono<T> timeout(org.reactivestreams.Publisher<U> p0){ return null; }
    public final <U> Mono<T> timeout(org.reactivestreams.Publisher<U> p0, reactor.core.publisher.Mono<? extends T> p1){ return null; }
    public final <U> Mono<U> ofType(java.lang.Class<U> p0){ return null; }
    public final <V> reactor.core.publisher.Flux<V> thenMany(org.reactivestreams.Publisher<V> p0){ return null; }
    public final <V> reactor.core.publisher.Mono<V> then(reactor.core.publisher.Mono<V> p0){ return null; }
    public final <V> reactor.core.publisher.Mono<V> thenReturn(V p0){ return null; }
    public final <V> reactor.core.publisher.Mono<V> transform(java.util.function.Function<? super Mono<T>, ? extends org.reactivestreams.Publisher<V>> p0){ return null; }
    public final <V> reactor.core.publisher.Mono<V> transformDeferred(java.util.function.Function<? super Mono<T>, ? extends org.reactivestreams.Publisher<V>> p0){ return null; }
    public final <V> reactor.core.publisher.Mono<V> transformDeferredContextual(BiFunction<? super Mono<T>, ? super ContextView, ? extends org.reactivestreams.Publisher<V>> p0){ return null; }
    public final <X> Mono<X> dematerialize(){ return null; }
    public final Disposable subscribe(){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2, Consumer<? super Subscription> p3){ return null; }
    public final Disposable subscribe(java.util.function.Consumer<? super T> p0, Consumer<? super Throwable> p1, Runnable p2, Context p3){ return null; }
    public final Mono<Boolean> hasElement(){ return null; }
    public final Mono<T> cache(){ return null; }
    public final Mono<T> cache(Duration p0){ return null; }
    public final Mono<T> cache(Duration p0, Scheduler p1){ return null; }
    public final Mono<T> cache(Function<? super T, Duration> p0, Function<Throwable, Duration> p1, Supplier<Duration> p2){ return null; }
    public final Mono<T> cache(Function<? super T, Duration> p0, Function<Throwable, Duration> p1, Supplier<Duration> p2, Scheduler p3){ return null; }
    public final Mono<T> cacheInvalidateIf(java.util.function.Predicate<? super T> p0){ return null; }
    public final Mono<T> cacheInvalidateWhen(Function<? super T, Mono<Void>> p0){ return null; }
    public final Mono<T> cacheInvalidateWhen(Function<? super T, Mono<Void>> p0, java.util.function.Consumer<? super T> p1){ return null; }
    public final Mono<T> cancelOn(Scheduler p0){ return null; }
    public final Mono<T> checkpoint(){ return null; }
    public final Mono<T> checkpoint(String p0){ return null; }
    public final Mono<T> checkpoint(String p0, boolean p1){ return null; }
    public final Mono<T> contextCapture(){ return null; }
    public final Mono<T> contextWrite(ContextView p0){ return null; }
    public final Mono<T> contextWrite(Function<Context, Context> p0){ return null; }
    public final Mono<T> defaultIfEmpty(T p0){ return null; }
    public final Mono<T> delayElement(Duration p0){ return null; }
    public final Mono<T> delayElement(Duration p0, Scheduler p1){ return null; }
    public final Mono<T> delaySubscription(Duration p0){ return null; }
    public final Mono<T> delaySubscription(Duration p0, Scheduler p1){ return null; }
    public final Mono<T> delayUntil(java.util.function.Function<? super T, ? extends Publisher<? extends Object>> p0){ return null; }
    public final Mono<T> doAfterTerminate(Runnable p0){ return null; }
    public final Mono<T> doFinally(Consumer<SignalType> p0){ return null; }
    public final Mono<T> doFirst(Runnable p0){ return null; }
    public final Mono<T> doOnCancel(Runnable p0){ return null; }
    public final Mono<T> doOnEach(java.util.function.Consumer<? super reactor.core.publisher.Signal<T>> p0){ return null; }
    public final Mono<T> doOnError(Consumer<? super Throwable> p0){ return null; }
    public final Mono<T> doOnError(Predicate<? super Throwable> p0, Consumer<? super Throwable> p1){ return null; }
    public final Mono<T> doOnNext(java.util.function.Consumer<? super T> p0){ return null; }
    public final Mono<T> doOnRequest(LongConsumer p0){ return null; }
    public final Mono<T> doOnSubscribe(Consumer<? super Subscription> p0){ return null; }
    public final Mono<T> doOnSuccess(java.util.function.Consumer<? super T> p0){ return null; }
    public final Mono<T> doOnTerminate(Runnable p0){ return null; }
    public final Mono<T> filter(java.util.function.Predicate<? super T> p0){ return null; }
    public final Mono<T> filterWhen(java.util.function.Function<? super T, ? extends Publisher<Boolean>> p0){ return null; }
    public final Mono<T> hide(){ return null; }
    public final Mono<T> ignoreElement(){ return null; }
    public final Mono<T> log(){ return null; }
    public final Mono<T> log(Logger p0){ return null; }
    public final Mono<T> log(Logger p0, Level p1, boolean p2, SignalType... p3){ return null; }
    public final Mono<T> log(String p0){ return null; }
    public final Mono<T> log(String p0, Level p1, SignalType... p2){ return null; }
    public final Mono<T> log(String p0, Level p1, boolean p2, SignalType... p3){ return null; }
    public final Mono<T> metrics(){ return null; }
    public final Mono<T> name(String p0){ return null; }
    public final Mono<T> onErrorComplete(){ return null; }
    public final Mono<T> onErrorComplete(Class<? extends Throwable> p0){ return null; }
    public final Mono<T> onErrorComplete(Predicate<? super Throwable> p0){ return null; }
    public final Mono<T> onErrorContinue(BiConsumer<Throwable, Object> p0){ return null; }
    public final Mono<T> onErrorMap(Function<? super Throwable, ? extends Throwable> p0){ return null; }
    public final Mono<T> onErrorMap(Predicate<? super Throwable> p0, Function<? super Throwable, ? extends Throwable> p1){ return null; }
    public final Mono<T> onErrorResume(Function<? super Throwable, ? extends reactor.core.publisher.Mono<? extends T>> p0){ return null; }
    public final Mono<T> onErrorResume(Predicate<? super Throwable> p0, Function<? super Throwable, ? extends reactor.core.publisher.Mono<? extends T>> p1){ return null; }
    public final Mono<T> onErrorReturn(Predicate<? super Throwable> p0, T p1){ return null; }
    public final Mono<T> onErrorReturn(T p0){ return null; }
    public final Mono<T> onErrorStop(){ return null; }
    public final Mono<T> onTerminateDetach(){ return null; }
    public final Mono<T> or(reactor.core.publisher.Mono<? extends T> p0){ return null; }
    public final Mono<T> publishOn(Scheduler p0){ return null; }
    public final Mono<T> repeatWhenEmpty(Function<Flux<Long>, ? extends Publisher<? extends Object>> p0){ return null; }
    public final Mono<T> repeatWhenEmpty(int p0, Function<Flux<Long>, ? extends Publisher<? extends Object>> p1){ return null; }
    public final Mono<T> retry(){ return null; }
    public final Mono<T> retry(long p0){ return null; }
    public final Mono<T> retryWhen(Retry p0){ return null; }
    public final Mono<T> share(){ return null; }
    public final Mono<T> single(){ return null; }
    public final Mono<T> subscribeOn(Scheduler p0){ return null; }
    public final Mono<T> switchIfEmpty(reactor.core.publisher.Mono<? extends T> p0){ return null; }
    public final Mono<T> tag(String p0, String p1){ return null; }
    public final Mono<T> take(Duration p0){ return null; }
    public final Mono<T> take(Duration p0, Scheduler p1){ return null; }
    public final Mono<T> takeUntilOther(Publisher<? extends Object> p0){ return null; }
    public final Mono<T> tap(java.util.function.Function<ContextView, reactor.core.observability.SignalListener<T>> p0){ return null; }
    public final Mono<T> tap(java.util.function.Supplier<reactor.core.observability.SignalListener<T>> p0){ return null; }
    public final Mono<T> tap(reactor.core.observability.SignalListenerFactory<T, ? extends Object> p0){ return null; }
    public final Mono<T> timeout(Duration p0){ return null; }
    public final Mono<T> timeout(Duration p0, Scheduler p1){ return null; }
    public final Mono<T> timeout(Duration p0, reactor.core.publisher.Mono<? extends T> p1){ return null; }
    public final Mono<T> timeout(Duration p0, reactor.core.publisher.Mono<? extends T> p1, Scheduler p2){ return null; }
    public final Mono<Void> and(Publisher<? extends Object> p0){ return null; }
    public final Mono<Void> then(){ return null; }
    public final Mono<Void> thenEmpty(Publisher<Void> p0){ return null; }
    public final Mono<java.util.Optional<T>> singleOptional(){ return null; }
    public final Mono<reactor.core.publisher.Signal<T>> materialize(){ return null; }
    public final Mono<reactor.core.publisher.Timed<T>> timed(){ return null; }
    public final Mono<reactor.core.publisher.Timed<T>> timed(Scheduler p0){ return null; }
    public final Mono<reactor.util.function.Tuple2<Long, T>> elapsed(){ return null; }
    public final Mono<reactor.util.function.Tuple2<Long, T>> elapsed(Scheduler p0){ return null; }
    public final Mono<reactor.util.function.Tuple2<Long, T>> timestamp(){ return null; }
    public final Mono<reactor.util.function.Tuple2<Long, T>> timestamp(Scheduler p0){ return null; }
    public final java.util.concurrent.CompletableFuture<T> toFuture(){ return null; }
    public final reactor.core.publisher.Flux<T> concatWith(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public final reactor.core.publisher.Flux<T> expand(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public final reactor.core.publisher.Flux<T> expand(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends T>> p0, int p1){ return null; }
    public final reactor.core.publisher.Flux<T> expandDeep(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends T>> p0){ return null; }
    public final reactor.core.publisher.Flux<T> expandDeep(java.util.function.Function<? super T, ? extends org.reactivestreams.Publisher<? extends T>> p0, int p1){ return null; }
    public final reactor.core.publisher.Flux<T> flux(){ return null; }
    public final reactor.core.publisher.Flux<T> mergeWith(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public final reactor.core.publisher.Flux<T> repeat(){ return null; }
    public final reactor.core.publisher.Flux<T> repeat(BooleanSupplier p0){ return null; }
    public final reactor.core.publisher.Flux<T> repeat(long p0){ return null; }
    public final reactor.core.publisher.Flux<T> repeat(long p0, BooleanSupplier p1){ return null; }
    public final reactor.core.publisher.Flux<T> repeatWhen(Function<Flux<Long>, ? extends Publisher<? extends Object>> p0){ return null; }
    public final void subscribe(org.reactivestreams.Subscriber<? super T> p0){}
    public java.util.Optional<T> blockOptional(){ return null; }
    public java.util.Optional<T> blockOptional(Duration p0){ return null; }
    public static <I> Mono<I> fromDirect(org.reactivestreams.Publisher<? extends I> p0){ return null; }
    public static <R> reactor.core.publisher.Mono<R> zip(Iterable<? extends Mono<? extends Object>> p0, java.util.function.Function<? super Object[], ? extends R> p1){ return null; }
    public static <R> reactor.core.publisher.Mono<R> zip(java.util.function.Function<? super Object[], ? extends R> p0, Mono<? extends Object>... p1){ return null; }
    public static <R> reactor.core.publisher.Mono<R> zipDelayError(Iterable<? extends Mono<? extends Object>> p0, java.util.function.Function<? super Object[], ? extends R> p1){ return null; }
    public static <R> reactor.core.publisher.Mono<R> zipDelayError(java.util.function.Function<? super Object[], ? extends R> p0, Mono<? extends Object>... p1){ return null; }
    public static <T, D> reactor.core.publisher.Mono<T> using(java.util.concurrent.Callable<? extends D> p0, java.util.function.Function<? super D, ? extends reactor.core.publisher.Mono<? extends T>> p1, java.util.function.Consumer<? super D> p2){ return null; }
    public static <T, D> reactor.core.publisher.Mono<T> using(java.util.concurrent.Callable<? extends D> p0, java.util.function.Function<? super D, ? extends reactor.core.publisher.Mono<? extends T>> p1, java.util.function.Consumer<? super D> p2, boolean p3){ return null; }
    public static <T, D> reactor.core.publisher.Mono<T> usingWhen(org.reactivestreams.Publisher<D> p0, java.util.function.Function<? super D, ? extends reactor.core.publisher.Mono<? extends T>> p1, java.util.function.Function<? super D, ? extends Publisher<? extends Object>> p2){ return null; }
    public static <T, D> reactor.core.publisher.Mono<T> usingWhen(org.reactivestreams.Publisher<D> p0, java.util.function.Function<? super D, ? extends reactor.core.publisher.Mono<? extends T>> p1, java.util.function.Function<? super D, ? extends Publisher<? extends Object>> p2, java.util.function.BiFunction<? super D, ? super Throwable, ? extends Publisher<? extends Object>> p3, java.util.function.Function<? super D, ? extends Publisher<? extends Object>> p4){ return null; }
    public static <T1, T2, O> reactor.core.publisher.Mono<O> zip(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, java.util.function.BiFunction<? super T1, ? super T2, ? extends O> p2){ return null; }
    public static <T1, T2, T3, T4, T5, T6, T7, T8> reactor.core.publisher.Mono<reactor.util.function.Tuple8<T1, T2, T3, T4, T5, T6, T7, T8>> zip(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3, reactor.core.publisher.Mono<? extends T5> p4, reactor.core.publisher.Mono<? extends T6> p5, reactor.core.publisher.Mono<? extends T7> p6, reactor.core.publisher.Mono<? extends T8> p7){ return null; }
    public static <T1, T2, T3, T4, T5, T6, T7, T8> reactor.core.publisher.Mono<reactor.util.function.Tuple8<T1, T2, T3, T4, T5, T6, T7, T8>> zipDelayError(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3, reactor.core.publisher.Mono<? extends T5> p4, reactor.core.publisher.Mono<? extends T6> p5, reactor.core.publisher.Mono<? extends T7> p6, reactor.core.publisher.Mono<? extends T8> p7){ return null; }
    public static <T1, T2, T3, T4, T5, T6, T7> reactor.core.publisher.Mono<reactor.util.function.Tuple7<T1, T2, T3, T4, T5, T6, T7>> zip(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3, reactor.core.publisher.Mono<? extends T5> p4, reactor.core.publisher.Mono<? extends T6> p5, reactor.core.publisher.Mono<? extends T7> p6){ return null; }
    public static <T1, T2, T3, T4, T5, T6, T7> reactor.core.publisher.Mono<reactor.util.function.Tuple7<T1, T2, T3, T4, T5, T6, T7>> zipDelayError(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3, reactor.core.publisher.Mono<? extends T5> p4, reactor.core.publisher.Mono<? extends T6> p5, reactor.core.publisher.Mono<? extends T7> p6){ return null; }
    public static <T1, T2, T3, T4, T5, T6> reactor.core.publisher.Mono<reactor.util.function.Tuple6<T1, T2, T3, T4, T5, T6>> zip(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3, reactor.core.publisher.Mono<? extends T5> p4, reactor.core.publisher.Mono<? extends T6> p5){ return null; }
    public static <T1, T2, T3, T4, T5, T6> reactor.core.publisher.Mono<reactor.util.function.Tuple6<T1, T2, T3, T4, T5, T6>> zipDelayError(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3, reactor.core.publisher.Mono<? extends T5> p4, reactor.core.publisher.Mono<? extends T6> p5){ return null; }
    public static <T1, T2, T3, T4, T5> reactor.core.publisher.Mono<reactor.util.function.Tuple5<T1, T2, T3, T4, T5>> zip(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3, reactor.core.publisher.Mono<? extends T5> p4){ return null; }
    public static <T1, T2, T3, T4, T5> reactor.core.publisher.Mono<reactor.util.function.Tuple5<T1, T2, T3, T4, T5>> zipDelayError(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3, reactor.core.publisher.Mono<? extends T5> p4){ return null; }
    public static <T1, T2, T3, T4> reactor.core.publisher.Mono<reactor.util.function.Tuple4<T1, T2, T3, T4>> zip(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3){ return null; }
    public static <T1, T2, T3, T4> reactor.core.publisher.Mono<reactor.util.function.Tuple4<T1, T2, T3, T4>> zipDelayError(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2, reactor.core.publisher.Mono<? extends T4> p3){ return null; }
    public static <T1, T2, T3> reactor.core.publisher.Mono<reactor.util.function.Tuple3<T1, T2, T3>> zip(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2){ return null; }
    public static <T1, T2, T3> reactor.core.publisher.Mono<reactor.util.function.Tuple3<T1, T2, T3>> zipDelayError(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1, reactor.core.publisher.Mono<? extends T3> p2){ return null; }
    public static <T1, T2> reactor.core.publisher.Mono<reactor.util.function.Tuple2<T1, T2>> zip(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1){ return null; }
    public static <T1, T2> reactor.core.publisher.Mono<reactor.util.function.Tuple2<T1, T2>> zipDelayError(reactor.core.publisher.Mono<? extends T1> p0, reactor.core.publisher.Mono<? extends T2> p1){ return null; }
    public static <T> Mono<Boolean> sequenceEqual(org.reactivestreams.Publisher<? extends T> p0, org.reactivestreams.Publisher<? extends T> p1){ return null; }
    public static <T> Mono<Boolean> sequenceEqual(org.reactivestreams.Publisher<? extends T> p0, org.reactivestreams.Publisher<? extends T> p1, java.util.function.BiPredicate<? super T, ? super T> p2){ return null; }
    public static <T> Mono<Boolean> sequenceEqual(org.reactivestreams.Publisher<? extends T> p0, org.reactivestreams.Publisher<? extends T> p1, java.util.function.BiPredicate<? super T, ? super T> p2, int p3){ return null; }
    public static <T> reactor.core.publisher.Mono<T> create(Consumer<MonoSink<T>> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> defer(Supplier<? extends reactor.core.publisher.Mono<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> deferContextual(Function<ContextView, ? extends reactor.core.publisher.Mono<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> empty(){ return null; }
    public static <T> reactor.core.publisher.Mono<T> error(Supplier<? extends Throwable> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> error(Throwable p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> first(java.lang.Iterable<? extends reactor.core.publisher.Mono<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> first(reactor.core.publisher.Mono<? extends T>... p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> firstWithSignal(java.lang.Iterable<? extends reactor.core.publisher.Mono<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> firstWithSignal(reactor.core.publisher.Mono<? extends T>... p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> firstWithValue(java.lang.Iterable<? extends reactor.core.publisher.Mono<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> firstWithValue(reactor.core.publisher.Mono<? extends T> p0, reactor.core.publisher.Mono<? extends T>... p1){ return null; }
    public static <T> reactor.core.publisher.Mono<T> from(org.reactivestreams.Publisher<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromCallable(java.util.concurrent.Callable<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromCompletionStage(Supplier<? extends java.util.concurrent.CompletionStage<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromCompletionStage(java.util.concurrent.CompletionStage<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromFuture(java.util.concurrent.CompletableFuture<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromFuture(java.util.concurrent.CompletableFuture<? extends T> p0, boolean p1){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromFuture(java.util.function.Supplier<? extends java.util.concurrent.CompletableFuture<? extends T>> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromFuture(java.util.function.Supplier<? extends java.util.concurrent.CompletableFuture<? extends T>> p0, boolean p1){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromRunnable(Runnable p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> fromSupplier(java.util.function.Supplier<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> ignoreElements(org.reactivestreams.Publisher<T> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> just(T p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> justOrEmpty(T p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> justOrEmpty(java.util.Optional<? extends T> p0){ return null; }
    public static <T> reactor.core.publisher.Mono<T> never(){ return null; }
    public static Mono<Long> delay(Duration p0){ return null; }
    public static Mono<Long> delay(Duration p0, Scheduler p1){ return null; }
    public static Mono<Void> when(Iterable<? extends Publisher<? extends Object>> p0){ return null; }
    public static Mono<Void> when(Publisher<? extends Object>... p0){ return null; }
    public static Mono<Void> whenDelayError(Iterable<? extends Publisher<? extends Object>> p0){ return null; }
    public static Mono<Void> whenDelayError(Publisher<? extends Object>... p0){ return null; }
}
