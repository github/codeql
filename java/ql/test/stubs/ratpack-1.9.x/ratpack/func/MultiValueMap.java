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

import com.google.common.collect.ListMultimap;

import java.util.List;
import java.util.Map;

/**
 * A map that may contain multiple values for a given key, but typically only one value.
 * <p>
 * Unlike other multi map types, this type is optimized for the case where there is only one value for a key.
 * The map acts just like a normal {@link Map}, but has extra methods for getting all values for a key.
 * <p>
 * <b>All implementations of this type are immutable.</b> Mutating operations throw {@link UnsupportedOperationException}.
 * <p>
 * Where there is multiple values for a given key, retrieving a single value will return the <i>first</i> value,
 * where the first value is intrinsic to the service in which the map is being used.
 *
 * @param <K> The type of key objects
 * @param <V> The type of value objects
 */
public interface MultiValueMap<K, V> extends Map<K, V> {

  static <K, V> MultiValueMap<K, V> empty() {
    return null;
  }

  /**
   * All of the values for the given key. An empty list if there are no values for the key.
   * <p>
   * The returned list is immutable.
   *
   * @param key The key to return all values of
   * @return all of the values for the given key, or an empty list if there are no values for the key.
   */
  List<V> getAll(K key);

  /**
   * Returns a new view of the map where each map value is a list of all the values for the given key (i.e. a traditional multi map).
   * <p>
   * The returned map is immutable.
   * @return A new view of the map where each map value is a list of all the values for the given key
   */
  Map<K, List<V>> getAll();

  /**
   * Get the first value for the key, or {@code null} if there are no values for the key.
   *
   * @param key The key to obtain the first value for
   * @return The first value for the given key, or {@code null} if there are no values for the given key
   */
  V get(Object key);

  /**
   * Throws {@link UnsupportedOperationException}.
   *
   * {@inheritDoc}
   */
  V put(K key, V value);

  /**
   * Throws {@link UnsupportedOperationException}.
   *
   * {@inheritDoc}
   */
  V remove(Object key);

  /**
   * Throws {@link UnsupportedOperationException}.
   *
   * {@inheritDoc}
   */
  @SuppressWarnings("NullableProblems")
  void putAll(Map<? extends K, ? extends V> m);

  /**
   * Throws {@link UnsupportedOperationException}.
   *
   * {@inheritDoc}
   */
  void clear();

  ListMultimap<K, V> asMultimap();

}
