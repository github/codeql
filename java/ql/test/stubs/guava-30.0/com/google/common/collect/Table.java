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
import java.util.Map;
import java.util.Set;

public interface Table<R, C, V> {
  boolean contains(Object rowKey, Object columnKey);

  boolean containsRow(Object rowKey);

  boolean containsColumn(Object columnKey);

  boolean containsValue(Object value);

  V get(Object rowKey, Object columnKey);

  boolean isEmpty();

  int size();

  void clear();

  V put(R rowKey, C columnKey, V value);

  void putAll(Table<? extends R, ? extends C, ? extends V> table);

  V remove(Object rowKey, Object columnKey);

  Map<C, V> row(R rowKey);

  Map<R, V> column(C columnKey);

  Set<Cell<R, C, V>> cellSet();

  Set<R> rowKeySet();

  Set<C> columnKeySet();

  Collection<V> values();

  Map<R, Map<C, V>> rowMap();

  Map<C, Map<R, V>> columnMap();

  interface Cell<R, C, V> {
    R getRowKey();

    C getColumnKey();

    V getValue();
  }
}
