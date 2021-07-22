/*
 * Copyright (C) 2011 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.common.base;
import java.io.Serializable;
import java.util.Set;
import org.checkerframework.checker.nullness.qual.Nullable;

public abstract class Optional<T> implements Serializable {
  public static <T> Optional<T> absent() {
    return null;
  }

  public static <T> Optional<T> of(T reference) {
    return null;
  }

  public static <T> Optional<T> fromNullable(@Nullable T nullableReference) {
    return null;
  }

  public static <T> @Nullable Optional<T> fromJavaUtil(
      java.util.@Nullable Optional<T> javaUtilOptional) {
    return null;
  }

  public static <T> java.util.@Nullable Optional<T> toJavaUtil(
      @Nullable Optional<T> googleOptional) {
    return null;
  }

  public java.util.Optional<T> toJavaUtil() {
    return null;
  }

  public abstract boolean isPresent();

  public abstract T get();

  public abstract T or(T defaultValue);

  public abstract Optional<T> or(Optional<? extends T> secondChoice);

  public abstract T or(Supplier<? extends T> supplier);

  public abstract @Nullable T orNull();

  public abstract Set<T> asSet();

  public abstract <V> Optional<V> transform(Function<? super T, V> function);

  @Override
  public abstract boolean equals(@Nullable Object object);

  @Override
  public abstract int hashCode();

  @Override
  public abstract String toString();

  public static <T> Iterable<T> presentInstances(
      final Iterable<? extends Optional<? extends T>> optionals) {
    return null;
  }

}
