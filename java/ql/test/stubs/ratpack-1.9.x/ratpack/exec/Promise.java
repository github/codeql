/*
 * Copyright 2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ratpack.exec;

import ratpack.func.Action;
import ratpack.func.Factory;
import ratpack.func.Function;
import ratpack.func.Pair;
import ratpack.func.Predicate;

/**
 * A promise for a single value.
 * <p>
 * A promise is a representation of a value which will become available later.
 * Methods such as {@link #map(Function)}, {@link #flatMap(Function)}, {@link #cache()} etc.) allow a pipeline of "operations" to be specified,
 * that the value will travel through as it becomes available.
 * Such operations are implemented via the {@link #transform(Function)} method.
 * Each operation returns a new promise object, not the original promise object.
 * <p>
 * To create a promise, use the {@link Promise#async(Upstream)} method (or one of the variants such as {@link Promise#sync(Factory)}.
 * To test code that uses promises, use the {@link ratpack.test.exec.ExecHarness}.
 * <p>
 * The promise is not "activated" until the {@link #then(Action)} method is called.
 * This method terminates the pipeline, and receives the final value.
 * <p>
 * Promise objects are multi use.
 * Every promise pipeline has a value producing function at its start.
 * Activating a promise (i.e. calling {@link #then(Action)}) invokes the function.
 * The {@link #cache()} operation can be used to change this behaviour.
 *
 * @param <T> the type of promised value
 */
@SuppressWarnings("JavadocReference")
public interface Promise<T> {

  static <T> Promise<T> sync(Factory<T> factory) {
    return null;
  }

  static <T> Promise<T> flatten(Factory<? extends Promise<T>> factory) {
    return null;
  }

  static <T> Promise<T> value(T t) {
    return null;
  }

  <O> Promise<O> map(Function<? super T, ? extends O> transformer);

  <O> Promise<O> flatMap(Function<? super T, ? extends Promise<O>> transformer);

  void then(Action<? super T> then);

  Promise<T> next(Action<? super T> action);

  default Promise<T> nextOp(Function<? super T, ? extends Operation> function) {
    return null;
  }

  default Promise<T> nextOpIf(Predicate<? super T> predicate, Function<? super T, ? extends Operation> function) {
    return null;
  }

  default <E extends Throwable> Promise<T> onError(Class<E> errorType, Action<? super E> errorHandler) {
    return null;
  }

  default Promise<T> onError(Action<? super Throwable> errorHandler) {
    return null;
  }

  default Promise<T> mapIf(Predicate<? super T> predicate, Function<? super T, ? extends T> transformer) {
    return null;
  }

  default <O> Promise<O> mapIf(Predicate<? super T> predicate, Function<? super T, ? extends O> onTrue, Function<? super T, ? extends O> onFalse) {
    return null;
  }

  default <O> Promise<O> blockingMap(Function<? super T, ? extends O> transformer) {
    return null;
  }

  default Promise<T> blockingOp(Action<? super T> action) {
    return null;
  }

  default <O> Promise<O> replace(Promise<O> next) {
    return null;
  }

  default <O> Promise<Pair<O, T>> left(Promise<O> left) {
    return null;
  }

  default <O> Promise<Pair<O, T>> left(Function<? super T, ? extends O> leftFunction) {
    return null;
  }

  default <O> Promise<Pair<O, T>> flatLeft(Function<? super T, ? extends Promise<O>> leftFunction) {
    return null;
  }

  default <O> Promise<Pair<T, O>> right(Promise<O> right) {
    return null;
  }

  default <O> Promise<Pair<T, O>> right(Function<? super T, ? extends O> rightFunction) {
    return null;
  }

  default <O> Promise<Pair<T, O>> flatRight(Function<? super T, ? extends Promise<O>> rightFunction) {
    return null;
  }

  default Operation flatOp(Function<? super T, ? extends Operation> function) {
    return null;
  }

  default Promise<T> mapError(Function<? super Throwable, ? extends T> transformer) {
    return null;
  }

  default <E extends Throwable> Promise<T> mapError(Class<E> type, Function<? super E, ? extends T> function) {
    return null;
  }

  default Promise<T> mapError(Predicate<? super Throwable> predicate, Function<? super Throwable, ? extends T> function) {
    return null;
  }

  default Promise<T> flatMapError(Function<? super Throwable, ? extends Promise<T>> function) {
    return null;
  }

  default <E extends Throwable> Promise<T> flatMapError(Class<E> type, Function<? super E, ? extends Promise<T>> function) {
    return null;
  }

  default Promise<T> flatMapError(Predicate<? super Throwable> predicate, Function<? super Throwable, ? extends Promise<T>> function) {
    return null;
  }

  default Promise<T> route(Predicate<? super T> predicate, Action<? super T> action) {
    return null;
  }

  default Promise<T> cache() {
    return null;
  }

  default Promise<T> cacheIf(Predicate<? super T> shouldCache) {
    return null;
  }

  default Promise<T> wiretap(Action<? super Result<T>> listener) {
    return null;
  }

  default Promise<T> fork() {
    return null;
  }

  default <O> Promise<O> apply(Function<? super Promise<T>, ? extends Promise<O>> function) {
    return null;
  }
}
