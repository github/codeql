/*
 * Copyright (C) 2008 The Guava Authors
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
import org.checkerframework.checker.nullness.qual.Nullable;

public abstract class Converter<A, B> implements Function<A, B> {
  public final @Nullable B convert(@Nullable A a) {
    return null;
  }

  public Iterable<B> convertAll(final Iterable<? extends A> fromIterable) {
    return null;
  }

  public Converter<B, A> reverse() {
    return null;
  }

  public final <C> Converter<A, C> andThen(Converter<B, C> secondConverter) {
    return null;
  }

  @Override
  public final @Nullable B apply(@Nullable A a) {
    return null;
  }

  @Override
  public boolean equals(@Nullable Object object) {
    return false;
  }

  public static <A, B> Converter<A, B> from(
      Function<? super A, ? extends B> forwardFunction,
      Function<? super B, ? extends A> backwardFunction) {
    return null;
  }

  public static <T> Converter<T, T> identity() {
    return null;
  }

}
