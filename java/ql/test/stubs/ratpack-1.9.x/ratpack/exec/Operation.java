/*
 * Copyright 2015 the original author or authors.
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

import ratpack.exec.api.NonBlocking;
import ratpack.func.Action;
import ratpack.func.Block;
import ratpack.func.Factory;
import ratpack.func.Function;
import ratpack.func.Predicate;

import java.util.Optional;

/**
 * A logical operation.
 * <p>
 * An operation encapsulates a logical piece of work, which will complete some time in the future.
 * It is similar to a {@link Promise} except that it does not produce a value.
 * It merely succeeds, or throws an exception.
 * <p>
 * The {@link #then(Block)} method allows specifying what should happen after the operation completes.
 * The {@link #onError(Action)} method allows specifying what should happen if the operation fails.
 * Like {@link Promise}, the operation will not start until it is subscribed to, via {@link #then(Block)} or {@link #then()}.
 * <p>
 * It is common for methods that would naturally return {@code void} to return an {@link Operation} instead,
 * to allow the method implementation to be effectively asynchronous.
 * The caller of the method is then expected to use the {@link #then(Block)} method to specify what should happen after the operation
 * that the method represents finishes.
 * <pre class="java">{@code
 * import ratpack.exec.Blocking;
 * import ratpack.exec.Operation;
 * import com.google.common.collect.Lists;
 * import ratpack.test.exec.ExecHarness;
 *
 * import java.util.Arrays;
 * import java.util.List;
 *
 * import static org.junit.Assert.assertEquals;
 *
 * public class Example {
 *   public static void main(String... args) throws Exception {
 *     List<String> events = Lists.newArrayList();
 *     ExecHarness.runSingle(e ->
 *       Operation.of(() ->
 *         Blocking.get(() -> events.add("1"))
 *           .then(b -> events.add("2"))
 *       )
 *       .then(() -> events.add("3"))
 *     );
 *     assertEquals(Arrays.asList("1", "2", "3"), events);
 *   }
 * }
 * }</pre>
 */
public interface Operation {

  static Operation of(Block block) {
    return null;
  }

  static Operation flatten(Factory<Operation> factory) {
    return null;
  }

  default Operation onError(Action<? super Throwable> onError) {
    return null;
  }

  Operation onError(Predicate<? super Throwable> predicate, Action<? super Throwable> errorHandler);

  default <E extends Throwable> Operation onError(Class<E> errorType, Action<? super E> errorHandler) {
    return null;
  }

  default Operation mapError(Action<? super Throwable> action) {
    return null;
  }

  @NonBlocking
  void then(Block block);

  @NonBlocking
  default void then() {
    // empty
  }

  Promise<Void> promise();

  default <T> Promise<T> map(Factory<? extends T> factory) {
    return null;
  }

  default <T> Promise<T> flatMap(Factory<? extends Promise<T>> factory) {
    return null;
  }

  default <T> Promise<T> flatMap(Promise<T> promise) {
    return null;
  }

  default Operation next(Operation operation) {
    return null;
  }

  default Operation next(Block operation) {
    return null;
  }

  default Operation blockingNext(Block operation) {
    return null;
  }

  default <O> O to(Function<? super Operation, ? extends O> function) throws Exception {
    return null;
  }

  default Operation wiretap(Action<? super Optional<? extends Throwable>> action) {
    return null;
  }

  static Operation noop() {
    return null;
  }

}
