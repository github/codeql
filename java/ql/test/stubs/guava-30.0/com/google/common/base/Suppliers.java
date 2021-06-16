/*
 * Copyright (C) 2007 The Guava Authors
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
import java.util.concurrent.TimeUnit;
import org.checkerframework.checker.nullness.qual.Nullable;

public final class Suppliers {
  public static <F, T> Supplier<T> compose(Function<? super F, T> function, Supplier<F> supplier) {
    return null;
  }

  public static <T> Supplier<T> memoize(Supplier<T> delegate) {
    return null;
  }

  public static <T> Supplier<T> memoizeWithExpiration(
      Supplier<T> delegate, long duration, TimeUnit unit) {
    return null;
  }

  public static <T> Supplier<T> ofInstance(@Nullable T instance) {
    return null;
  }

  public static <T> Supplier<T> synchronizedSupplier(Supplier<T> delegate) {
    return null;
  }

  public static <T> Function<Supplier<T>, T> supplierFunction() {
    return null;
  }

}
