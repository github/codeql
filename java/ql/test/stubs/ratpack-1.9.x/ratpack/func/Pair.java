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

package ratpack.func;

/**
 * A generic pair implementation that can be used to cumulatively aggregate a data structure during a promise pipeline.
 * <p>
 * This can sometimes be useful when collecting facts about something as part of a data stream without using mutable data structures.
 * <pre class="java">{@code
 * import ratpack.func.Pair;
 * import ratpack.exec.Promise;
 * import ratpack.test.embed.EmbeddedApp;
 *
 * import static org.junit.Assert.assertEquals;
 *
 * public class Example {
 *
 *   public static void main(String[] args) throws Exception {
 *     EmbeddedApp.fromHandler(ctx -> {
 *       int id = 1;
 *       int age = 21;
 *       String name = "John";
 *
 *       Promise.value(id)
 *         .map(idValue -> Pair.of(idValue, age))
 *         .flatMap(pair -> Promise.value(name).map(pair::nestRight))
 *         .then(pair -> {
 *           int receivedId = pair.left;
 *           int receivedAge = pair.right.right;
 *           String receivedName = pair.right.left;
 *           ctx.render(receivedName + " [" + receivedId + "] - age: " + receivedAge);
 *         });
 *     }).test(httpClient -> {
 *       assertEquals("John [1] - age: 21", httpClient.getText());
 *     });
 *   }
 * }
 * }</pre>
 * <p>
 *
 * @param <L> the left data type
 * @param <R> the right data type
 */
public final class Pair<L, R> {

  /**
   * The left item of the pair.
   */
  public final L left;

  /**
   * The right item of the pair.
   */
  public final R right;

  private Pair(L left, R right) {
    this.left = null;
    this.right = null;
  }

  public static <L, R> Pair<L, R> of(L left, R right) {
    return null;
  }

  public L getLeft() {
    return null;
  }

  public R getRight() {
    return null;
  }

  public L left() {
    return null;
  }

  public R right() {
    return null;
  }

  public <T> Pair<T, R> left(T newLeft) {
    return null;
  }

  public <T> Pair<L, T> right(T newRight) {
    return null;
  }

  public static <L, R> Pair<L, R> pair(L left, R right) {
    return null;
  }

  public <T> Pair<T, Pair<L, R>> pushLeft(T t) {
    return null;
  }

  public <T> Pair<Pair<L, R>, T> pushRight(T t) {
    return null;
  }

  public <T> Pair<Pair<T, L>, R> nestLeft(T t) {
    return null;
  }

  public <T> Pair<L, Pair<T, R>> nestRight(T t) {
    return null;
  }

  public <T> Pair<T, R> mapLeft(Function<? super L, ? extends T> function) throws Exception {
    return null;
  }

  public <T> Pair<L, T> mapRight(Function<? super R, ? extends T> function) throws Exception {
    return null;
  }

  public <T> T map(Function<? super Pair<L, R>, ? extends T> function) throws Exception {
    return null;
  }

  public static <L, P extends Pair<L, ?>> Function<P, L> unpackLeft() {
    return null;
  }

  public static <R, P extends Pair<?, R>> Function<P, R> unpackRight() {
    return null;
  }

}
