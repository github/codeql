/*
 * Copyright (C) 2014 The Guava Authors
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

public final class MoreObjects {
  public static <T> T firstNonNull(@Nullable T first, @Nullable T second) {
    return null;
  }

  public static ToStringHelper toStringHelper(Object self) {
    return null;
  }

  public static ToStringHelper toStringHelper(Class<?> clazz) {
    return null;
  }

  public static ToStringHelper toStringHelper(String className) {
    return null;
  }

  public static final class ToStringHelper {
    public ToStringHelper omitNullValues() {
      return null;
    }

    public ToStringHelper add(String name, @Nullable Object value) {
      return null;
    }

    public ToStringHelper add(String name, boolean value) {
      return null;
    }

    public ToStringHelper add(String name, char value) {
      return null;
    }

    public ToStringHelper add(String name, double value) {
      return null;
    }

    public ToStringHelper add(String name, float value) {
      return null;
    }

    public ToStringHelper add(String name, int value) {
      return null;
    }

    public ToStringHelper add(String name, long value) {
      return null;
    }

    public ToStringHelper addValue(@Nullable Object value) {
      return null;
    }

    public ToStringHelper addValue(boolean value) {
      return null;
    }

    public ToStringHelper addValue(char value) {
      return null;
    }

    public ToStringHelper addValue(double value) {
      return null;
    }

    public ToStringHelper addValue(float value) {
      return null;
    }

    public ToStringHelper addValue(int value) {
      return null;
    }

    public ToStringHelper addValue(long value) {
      return null;
    }

    @Override
    public String toString() {
      return null;
    }

  }
}
