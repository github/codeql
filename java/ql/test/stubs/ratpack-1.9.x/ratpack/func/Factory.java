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

/**
 * An object that creates another.
 *
 * Factories are expected to create a new object each time.
 * Implementors should explain there behaviour if they do not do this.
 *
 * @param <T> the type of object that this factory creates
 */
@FunctionalInterface
public interface Factory<T> {

  /**
   * Creates a new object.
   *
   * @return a newly created object
   * @throws Exception any
   */
  T create() throws Exception;

  /**
   * Creates a factory that always returns the given item.
   *
   * @param item the item to always provide
   * @param <T> the type of the item
   * @return a factory that always returns {@code item}
   * @since 1.1
   */
  static <T> Factory<T> constant(T item) {
    return () -> item;
  }

}
