/*
 * Copyright (C) 2007 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.common.collect;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;

public abstract class ImmutableSet<E> extends ImmutableCollection<E> implements Set<E> {
  public static <E> ImmutableSet<E> of() {
    return null;
  }

  public static <E> ImmutableSet<E> of(E element) {
    return null;
  }

  public static <E> ImmutableSet<E> of(E e1, E e2) {
    return null;
  }

  public static <E> ImmutableSet<E> of(E e1, E e2, E e3) {
    return null;
  }

  public static <E> ImmutableSet<E> of(E e1, E e2, E e3, E e4) {
    return null;
  }

  public static <E> ImmutableSet<E> of(E e1, E e2, E e3, E e4, E e5) {
    return null;
  }

  public static <E> ImmutableSet<E> of(E e1, E e2, E e3, E e4, E e5, E e6, E... others) {
    return null;
  }

  public static <E> ImmutableSet<E> copyOf(Collection<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSet<E> copyOf(Iterable<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSet<E> copyOf(Iterator<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSet<E> copyOf(E[] elements) {
    return null;
  }

  ImmutableSet() {}

  public static <E> Builder<E> builder() {
    return null;
  }

  public static class Builder<E> extends ImmutableCollection.Builder<E> {
    public Builder() {
    }

    public Builder<E> add(E element) {
      return null;
    }

    public ImmutableSet<E> build() {
      return null;
    }
  }
}
