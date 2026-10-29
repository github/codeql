/*
 * Copyright (c) 2012, 2017 Oracle and/or its affiliates. All rights reserved.
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

package javax.ws.rs.core;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

public abstract class AbstractMultivaluedMap<K, V> implements MultivaluedMap<K, V> {
    public AbstractMultivaluedMap(Map<K, List<V>> store) {
    }

    @Override
    public final void putSingle(K key, V value) {
    }

    @Override
    public final void add(K key, V value) {
    }

    @Override
    public final void addAll(K key, V... newValues) {
    }

    @Override
    public final void addAll(K key, List<V> valueList) {
    }

    @Override
    public final V getFirst(K key) {
      return null;
    }

    @Override
    public final void addFirst(K key, V value) {
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
    public boolean equals(Object o) {
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
    public List<V> remove(Object key) {
      return null;
    }

    @Override
    public void putAll(Map<? extends K, ? extends List<V>> m) {
    }

    @Override
    public List<V> put(K key, List<V> value) {
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
    public List<V> get(Object key) {
      return null;
    }

    @Override
    public Set<Entry<K, List<V>>> entrySet() {
      return null;
    }

    @Override
    public boolean containsValue(Object value) {
      return false;
    }

    @Override
    public boolean containsKey(Object key) {
      return false;
    }

    @Override
    public void clear() {
    }

    @Override
    public boolean equalsIgnoreValueOrder(MultivaluedMap<K, V> omap) {
      return false;
    }

}
