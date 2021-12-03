/*
 * Copyright (c) 2012, 2019 Oracle and/or its affiliates. All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0, which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * This Source Code may also be made available under the following Secondary
 * Licenses when the conditions for such availability set forth in the
 * Eclipse Public License v. 2.0 are satisfied: GNU General Public License,
 * version 2 with the GNU Classpath Exception, which is available at
 * https://www.gnu.org/software/classpath/license.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0
 */

package jakarta.ws.rs.core;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

public abstract class AbstractMultivaluedMap<K, V> implements MultivaluedMap<K, V>, Serializable {
    public AbstractMultivaluedMap(final Map<K, List<V>> store) {
    }

    @Override
    public final void putSingle(final K key, final V value) {
    }

    @Override
    public final void add(final K key, final V value) {
    }

    @Override
    public final void addAll(final K key, final V... newValues) {
    }

    @Override
    public final void addAll(final K key, final List<V> valueList) {
    }

    @Override
    public final V getFirst(final K key) {
      return null;
    }

    @Override
    public final void addFirst(final K key, final V value) {
    }

    @Override
    public String toString() {
      return null;
    }

    @Override
    public int hashCode() {
      return 0;
    }

    @Override
    public boolean equals(final Object o) {
      return false;
    }

    @Override
    public Collection<List<V>> values() {
      return null;
    }

    @Override
    public int size() {
      return 0;
    }

    @Override
    public List<V> remove(final Object key) {
      return null;
    }

    @Override
    public void putAll(final Map<? extends K, ? extends List<V>> m) {
    }

    @Override
    public List<V> put(final K key, final List<V> value) {
      return null;
    }

    @Override
    public Set<K> keySet() {
      return null;
    }

    @Override
    public boolean isEmpty() {
      return false;
    }

    @Override
    public List<V> get(final Object key) {
      return null;
    }

    @Override
    public Set<Entry<K, List<V>>> entrySet() {
      return null;
    }

    @Override
    public boolean containsValue(final Object value) {
      return false;
    }

    @Override
    public boolean containsKey(final Object key) {
      return false;
    }

    @Override
    public void clear() {
    }

    @Override
    public boolean equalsIgnoreValueOrder(final MultivaluedMap<K, V> omap) {
      return false;
    }

}
