/*
 * Copyright (C) 2013 The Guava Authors
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

package com.google.common.collect;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

abstract class AbstractTable<R, C, V> implements Table<R, C, V> {
  @Override
  public boolean containsRow(Object rowKey) {
    return false;
  }

  @Override
  public boolean containsColumn(Object columnKey) {
    return false;
  }

  @Override
  public Set<R> rowKeySet() {
    return null;
  }

  @Override
  public Set<C> columnKeySet() {
    return null;
  }

  @Override
  public boolean containsValue(Object value) {
    return false;
  }

  @Override
  public boolean contains(Object rowKey, Object columnKey) {
    return false;
  }

  @Override
  public V get(Object rowKey, Object columnKey) {
    return null;
  }

  @Override
  public boolean isEmpty() {
    return false;
  }

  @Override
  public void clear() {
  }

  @Override
  public V remove(Object rowKey, Object columnKey) {
    return null;
  }

  @Override
  public V put(R rowKey, C columnKey, V value) {
    return null;
  }

  @Override
  public void putAll(Table<? extends R, ? extends C, ? extends V> table) {
  }

  @Override
  public Set<Cell<R, C, V>> cellSet() {
    return null;
  }

  @Override
  public Collection<V> values() {
    return null;
  }

}
