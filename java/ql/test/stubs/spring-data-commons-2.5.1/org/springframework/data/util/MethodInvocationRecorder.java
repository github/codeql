/*
 * Copyright 2016-2021 the original author or authors.
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
package org.springframework.data.util;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;


public class MethodInvocationRecorder {
	public static <T> Recorded<T> forProxyOf(Class<T> type) {
   return null;
 }

	public interface PropertyNameDetectionStrategy {
		String getPropertyName(Method method);

 }
	public static class Recorded<T> {
		public Optional<String> getPropertyPath() {
    return null;
  }

		public Optional<String> getPropertyPath(PropertyNameDetectionStrategy strategy) {
    return null;
  }

		public Optional<String> getPropertyPath(List<PropertyNameDetectionStrategy> strategies) {
    return null;
  }

		public <S> Recorded<S> record(Function<? super T, S> converter) {
    return null;
  }

		public <S> Recorded<S> record(ToCollectionConverter<T, S> converter) {
    return null;
  }

		public <S> Recorded<S> record(ToMapConverter<T, S> converter) {
    return null;
  }

		@Override
		public String toString() {
    return null;
  }

		public interface ToCollectionConverter<T, S> extends Function<T, Collection<S>> {
  }
		public interface ToMapConverter<T, S> extends Function<T, Map<?, S>> {
  }
 }
}
