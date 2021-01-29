/*
 * Copyright (C) 2009 The Guava Authors
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

import java.util.Map;

public abstract class ImmutableTable<R, C, V> extends AbstractTable<R, C, V> {

  public static <R, C, V> ImmutableTable<R, C, V> of() {
    return null;
  }

  public static <R, C, V> ImmutableTable<R, C, V> of(R rowKey, C columnKey, V value) {
    return null;
  }

  public static <R, C, V> ImmutableTable<R, C, V> copyOf(
      Table<? extends R, ? extends C, ? extends V> table) {
    return null;
  }

  public static <R, C, V> Builder<R, C, V> builder() {
    return null;
  }

  public static final class Builder<R, C, V> {
    public Builder() {}

    public Builder<R, C, V> put(R rowKey, C columnKey, V value) {
      return null;
    }

    public Builder<R, C, V> put(Cell<? extends R, ? extends C, ? extends V> cell) {
      return null;
    }

    public Builder<R, C, V> putAll(Table<? extends R, ? extends C, ? extends V> table) {
      return null;
    }

    public ImmutableTable<R, C, V> build() {
      return null;
    }

  }
  @Override
  public ImmutableSet<Cell<R, C, V>> cellSet() {
    return null;
  }

  @Override
  public ImmutableCollection<V> values() {
    return null;
  }

  @Override
  public ImmutableMap<R, V> column(C columnKey) {
    return null;
  }

  @Override
  public ImmutableSet<C> columnKeySet() {
    return null;
  }

  @Override
  public abstract ImmutableMap<C, Map<R, V>> columnMap();

  @Override
  public ImmutableMap<C, V> row(R rowKey) {
    return null;
  }

  @Override
  public ImmutableSet<R> rowKeySet() {
    return null;
  }

  @Override
  public abstract ImmutableMap<R, Map<C, V>> rowMap();

  @Override
  public boolean contains(Object rowKey, Object columnKey) {
    return false;
  }

  @Override
  public boolean containsValue(Object value) {
    return false;
  }

  @Override
  public final void clear() {
  }

  @Override
  public final V put(R rowKey, C columnKey, V value) {
    return null;
  }

  @Override
  public final void putAll(Table<? extends R, ? extends C, ? extends V> table) {
  }

  @Override
  public final V remove(Object rowKey, Object columnKey) {
    return null;
  }

}
