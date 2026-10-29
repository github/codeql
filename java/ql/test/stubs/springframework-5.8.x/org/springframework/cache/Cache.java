/*
 * Copyright 2002-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.cache;

import java.util.concurrent.Callable;

import org.springframework.lang.Nullable;

public interface Cache {
	String getName();

	Object getNativeCache();

	ValueWrapper get(Object key);

	<T> T get(Object key, @Nullable Class<T> type);

	<T> T get(Object key, Callable<T> valueLoader);

	void put(Object key, @Nullable Object value);

	default ValueWrapper putIfAbsent(Object key, @Nullable Object value) {
   return null;
 }

	void evict(Object key);

	default boolean evictIfPresent(Object key) {
   return false;
 }

	void clear();

	default boolean invalidate() {
   return false;
 }

	interface ValueWrapper {
		Object get();

 }
	class ValueRetrievalException extends RuntimeException {
		public ValueRetrievalException(@Nullable Object key, Callable<?> loader, Throwable ex) {
  }

		public Object getKey() {
    return null;
  }

 }
}
