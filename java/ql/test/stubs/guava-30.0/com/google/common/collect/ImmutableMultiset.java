/*
 * Copyright (C) 2008 The Guava Authors
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

public abstract class ImmutableMultiset<E> extends ImmutableCollection<E>
    implements Multiset<E> {

  public static <E> ImmutableMultiset<E> of() {
    return null;
  }

  public static <E> ImmutableMultiset<E> of(E element) {
    return null;
  }

  public static <E> ImmutableMultiset<E> of(E e1, E e2) {
    return null;
  }

  public static <E> ImmutableMultiset<E> of(E e1, E e2, E e3) {
    return null;
  }

  public static <E> ImmutableMultiset<E> of(E e1, E e2, E e3, E e4) {
    return null;
  }

  public static <E> ImmutableMultiset<E> of(E e1, E e2, E e3, E e4, E e5) {
    return null;
  }

  public static <E> ImmutableMultiset<E> of(E e1, E e2, E e3, E e4, E e5, E e6, E... others) {
    return null;
  }

  public static <E> ImmutableMultiset<E> copyOf(E[] elements) {
    return null;
  }

  public static <E> ImmutableMultiset<E> copyOf(Iterable<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableMultiset<E> copyOf(Iterator<? extends E> elements) {
    return null;
  }

  @Override
  public boolean contains(Object object) {
    return false;
  }

  @Override
  public final int add(E element, int occurrences) {
    return 0;
  }

  @Override
  public final int remove(Object element, int occurrences) {
    return 0;
  }

  @Override
  public final int setCount(E element, int count) {
    return 0;
  }

  @Override
  public final boolean setCount(E element, int oldCount, int newCount) {
    return false;
  }

  @Override
  public abstract ImmutableSet<E> elementSet();

  @Override
  public ImmutableSet<Entry<E>> entrySet() {
    return null;
  }

  public static <E> Builder<E> builder() {
    return null;
  }

  public static class Builder<E> extends ImmutableCollection.Builder<E> {
    public Builder() {
    }

    @Override
    public Builder<E> add(E element) {
      return null;
    }

    public Builder<E> addCopies(E element, int occurrences) {
      return null;
    }

    public Builder<E> setCount(E element, int count) {
      return null;
    }

    @Override
    public ImmutableMultiset<E> build() {
      return null;
    }

  }
}
