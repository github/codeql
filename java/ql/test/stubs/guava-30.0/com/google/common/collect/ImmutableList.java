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

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

public abstract class ImmutableList<E> extends ImmutableCollection<E>
    implements List<E>{

  public static <E> ImmutableList<E> of() {
    return null;
  }

  public static <E> ImmutableList<E> of(E element) {
    return null;
  }

  public static <E> ImmutableList<E> of(E e1, E e2) {
    return null;
  }

  public static <E> ImmutableList<E> of(E e1, E e2, E e3) {
    return null;
  }

  public static <E> ImmutableList<E> of(E e1, E e2, E e3, E e4) {
    return null;
  }

  public static <E> ImmutableList<E> of(
      E e1, E e2, E e3, E e4, E e5, E e6, E e7, E e8, E e9, E e10, E e11, E e12, E... others) {
    return null;
  }

  public static <E> ImmutableList<E> copyOf(Iterable<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableList<E> copyOf(Collection<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableList<E> copyOf(Iterator<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableList<E> copyOf(E[] elements) {
    return null;
  }

  public static <E extends Comparable<? super E>> ImmutableList<E> sortedCopyOf(
      Iterable<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableList<E> sortedCopyOf(
      Comparator<? super E> comparator, Iterable<? extends E> elements) {
    return null;
  }

  ImmutableList() {}

  public ImmutableList<E> reverse() {
    return null;
  }

  public static <E> Builder<E> builder() {
    return null;
  }

  public static final class Builder<E> extends ImmutableCollection.Builder<E> {
    @Override
    public Builder<E> add(E element) {
      return null;
    }

    @Override
    public ImmutableList<E> build() {
      return null;
    }
  }
}
