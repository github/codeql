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
import java.util.Set;
import java.util.function.ObjIntConsumer;

public interface Multiset<E> extends Collection<E> {
  int count(Object element);

  int add(E element, int occurrences);

  int remove(Object element, int occurrences);

  int setCount(E element, int count);

  boolean setCount(E element, int oldCount, int newCount);

  Set<E> elementSet();

  Set<Entry<E>> entrySet();

  default void forEachEntry(ObjIntConsumer<? super E> action) {
  }

  boolean equals(Object object);

  interface Entry<E> {
    E getElement();

    int getCount();
  }
}
