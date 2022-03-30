/*
 * Copyright (c) 2011, 2019 Oracle and/or its affiliates. All rights reserved.
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MultivaluedHashMap<K, V> extends AbstractMultivaluedMap<K, V> implements Serializable {
    // public MultivaluedHashMap() {
    // }

    // public MultivaluedHashMap(final int initialCapacity) {
    // }

    // public MultivaluedHashMap(final int initialCapacity, final float loadFactor) {
    // }

    public MultivaluedHashMap(final MultivaluedMap<? extends K, ? extends V> map) {
        super(new HashMap<K, List<V>>());
    }

    public MultivaluedHashMap(final Map<? extends K, ? extends V> map) {
        super(new HashMap<K, List<V>>());
    }

}
