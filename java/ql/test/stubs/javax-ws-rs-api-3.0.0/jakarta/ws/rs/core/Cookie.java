/*
 * Copyright (c) 2010, 2019 Oracle and/or its affiliates. All rights reserved.
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

public class Cookie {
    public Cookie(final String name, final String value, final String path, final String domain, final int version)
            throws IllegalArgumentException {
    }

    public Cookie(final String name, final String value, final String path, final String domain)
            throws IllegalArgumentException {
    }

    public Cookie(final String name, final String value)
            throws IllegalArgumentException {
    }

    public static Cookie valueOf(final String value) {
      return null;
    }

    public String getName() {
      return null;
    }

    public String getValue() {
      return null;
    }

    public int getVersion() {
      return 0;
    }

    public String getDomain() {
      return null;
    }

    public String getPath() {
      return null;
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
    public boolean equals(final Object obj) {
      return false;
    }

}
