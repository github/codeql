/*
 * Copyright 2013 the original author or authors.
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

import java.util.Objects;

/**
 * A single argument function.
 * <p>
 * This type serves the same purpose as the JDK's {@link java.util.function.Function}, but allows throwing checked exceptions.
 * It contains methods for bridging to and from the JDK type.
 *
 * @param <I> the type of the input
 * @param <O> the type of the output
 */
@FunctionalInterface
public interface Function<I, O> {

  /**
   * The function implementation.
   *
   * @param i the input to the function
   * @return the output of the function
   * @throws Exception any
   */
  O apply(I i) throws Exception;

  /**
   * Joins {@code this} function with the given function.
   *
   * <pre class="java">{@code
   * import ratpack.func.Function;
   *
   * import static org.junit.Assert.assertEquals;
   *
   * public class Example {
   *   public static void main(String[] args) throws Exception {
   *     Function<String, String> function = in -> in + "-bar";
   *     assertEquals("FOO-BAR", function.andThen(String::toUpperCase).apply("foo"));
   *   }
   * }
   * }</pre>
   * <p>
   * Analogous to {@link java.util.function.Function#andThen(java.util.function.Function)}.
   *
   * @param after the function to apply to the result of {@code this} function
   * @param <T> the type of the final output
   * @return the result of applying the given function to {@code this} function
   * @throws Exception any thrown by {@code this} or {@code after}
   */
  default <T> Function<I, T> andThen(Function<? super O, ? extends T> after) throws Exception {
    return null;
  }

  /**
   * Joins the given function with {@code this} function.
   *
   * <pre class="java">{@code
   * import ratpack.func.Function;
   *
   * import static org.junit.Assert.assertEquals;
   *
   * public class Example {
   *   public static void main(String... args) throws Exception {
   *     Function<String, String> function = String::toUpperCase;
   *     assertEquals("FOO-BAR", function.compose(in -> in + "-BAR").apply("foo"));
   *   }
   * }
   * }</pre>
   * <p>
   * Analogous to {@link java.util.function.Function#compose(java.util.function.Function)}.
   *
   * @param before the function to apply {@code this} function to the result of
   * @param <T> the type of the new input
   * @return the result of applying {@code this} function to the result of the given function
   * @throws Exception any thrown by {@code this} or {@code before}
   */
  default <T> Function<T, O> compose(Function<? super T, ? extends I> before) throws Exception {
    return null;
  }



  /**
   * Returns an identity function (return value always same as input).
   *
   * @param <T> the type of the input and output objects to the function
   * @return a function that always returns its input argument
   */
  static <T> Function<T, T> identity() {
    return null;
  }

  /**
   * Returns a function that <i>always</i> returns the given argument.
   *
   * @param t the value to always return
   * @param <T> the type of returned value
   * @return a function that returns the given value
   */
  static <T> Function<Object, T> constant(T t) {
    return null;
  }

  /**
   * Creates a function that delegates to the given function if the given predicate applies, else delegates to {@link #identity()}.
   * <p>
   * This is equivalent to {@link #when(Predicate, Function, Function) when(predicate, function, identity())}.
   *
   * @param predicate the condition for the argument
   * @param function the function to apply if the predicate applies
   * @param <I> the type of argument and return value
   * @return a function that delegates to the given function if the predicate applies, else returns the argument
   * @see #when(Predicate, Function, Function)
   * @see #conditional(Function, Action)
   * @since 1.5
   */
  static <I> Function<I, I> when(Predicate<? super I> predicate, Function<? super I, ? extends I> function) {
    return null;
  }

  /**
   * Creates a function that delegates to the first function if the given predicate applies, else the second function.
   *
   * @param predicate the condition for the argument
   * @param onTrue the function to apply if the predicate applies
   * @param onFalse the function to apply if the predicate DOES NOT apply
   * @param <I> the type of argument
   * @param <O> the type of return value
   * @return a function that delegates to the first function if the predicate applies, else the second argument
   * @see #when(Predicate, Function)
   * @see #conditional(Function, Action)
   * @since 1.5
   */
  static <I, O> Function<I, O> when(Predicate<? super I> predicate, Function<? super I, ? extends O> onTrue, Function<? super I, ? extends O> onFalse) {
    return null;
  }

  /**
   * A spec for adding conditions to a conditional function.
   *
   * @param <I> the input type
   * @param <O> the output type
   * @see #conditional(Function, Action)
   * @since 1.5
   */
  interface ConditionalSpec<I, O> {

    /**
     * Adds a conditional function.
     *
     * @param predicate the condition predicate
     * @param function the function to apply if the predicate applies
     * @return {@code this}
     */
    ConditionalSpec<I, O> when(Predicate<? super I> predicate, Function<? super I, ? extends O> function);
  }

  /**
   * Creates a function that delegates based on the specified conditions.
   * <p>
   * If no conditions match, an {@link IllegalArgumentException} will be thrown.
   * Use {@link #conditional(Function, Action)} alternatively to specify a different "else" strategy.
   *
   * @param conditions the conditions
   * @param <I> the input type
   * @param <O> the output type
   * @return a conditional function
   * @see #conditional(Function, Action)
   * @throws Exception any thrown by {@code conditions}
   * @since 1.5
   */
  static <I, O> Function<I, O> conditional(Action<? super ConditionalSpec<I, O>> conditions) throws Exception {
    return null;
  }

  /**
   * Creates a function that delegates based on the specified conditions.
   * <p>
   * If no condition applies, the {@code onElse} function will be delegated to.
   *
   * @param onElse the function to delegate to if no condition matches
   * @param conditions the conditions
   * @param <I> the input type
   * @param <O> the output type
   * @return a conditional function
   * @see #conditional(Action)
   * @throws Exception any thrown by {@code conditions}
   * @since 1.5
   */
  static <I, O> Function<I, O> conditional(Function<? super I, ? extends O> onElse, Action<? super ConditionalSpec<I, O>> conditions) throws Exception {
    return null;
  }
}
