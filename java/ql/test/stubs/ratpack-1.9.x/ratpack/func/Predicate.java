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
 * A function that returns {@code true} or {@code false} for a value.
 * <p>
 * This type serves the same purpose as the JDK's {@link java.util.function.Predicate}, but allows throwing checked exceptions.
 * It contains methods for bridging to and from the JDK type.
 *
 * @param <T> the type of object "tested" by the predicate
 */
@FunctionalInterface
public interface Predicate<T> {

  /**
   * Tests the given value.
   *
   * @param t the value to "test"
   * @return {@code true} if the predicate applied, otherwise {@code false}
   * @throws Exception any
   */
  boolean apply(T t) throws Exception;

  /**
   * Creates a predicate from a JDK predicate.
   *
   * @param predicate the JDK predicate
   * @param <T> the type of object this predicate tests
   * @return the given JDK predicate as a predicate
   */
  static <T> Predicate<T> from(java.util.function.Predicate<T> predicate) {
    return null;
  }

  /**
   * Creates a predicate from a Guava predicate.
   *
   * @param predicate the Guava predicate
   * @param <T> the type of object this predicate tests
   * @return the given Guava predicate as a predicate
   */
  static <T> Predicate<T> fromGuava(com.google.common.base.Predicate<T> predicate) {
    return null;
  }

  /**
   * A predicate that always returns {@code true}, regardless of the input object.
   *
   * @param <T> the type of input object
   * @return a predicate that always returns {@code true}
   * @since 1.1
   */
  static <T> Predicate<T> alwaysTrue() {
    return null;
  }

  /**
   * A predicate that always returns {@code false}, regardless of the input object.
   *
   * @param <T> the type of input object
   * @return a predicate that always returns {@code false}
   * @since 1.1
   */
  static <T> Predicate<T> alwaysFalse() {
    return null;
  }

  /**
   * Creates a function the returns one of the given values.
   *
   * @param onTrue the value to return if the predicate applies
   * @param onFalse the value to return if the predicate does not apply
   * @param <O> the output value
   * @return a function
   * @since 1.5
   */
  default <O> Function<T, O> function(O onTrue, O onFalse) {
    return null;
  }

}
