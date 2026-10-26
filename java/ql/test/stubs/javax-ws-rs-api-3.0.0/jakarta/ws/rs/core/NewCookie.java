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
import java.util.Date;

public class NewCookie extends Cookie {
    public NewCookie(final String name, final String value) {
      super("", "");
    }

    public NewCookie(final String name,
            final String value,
            final String path,
            final String domain,
            final String comment,
            final int maxAge,
            final boolean secure) {
              super("", "");
    }

    public NewCookie(final String name,
            final String value,
            final String path,
            final String domain,
            final String comment,
            final int maxAge,
            final boolean secure,
            final boolean httpOnly) {
              super("", "");
    }

    public NewCookie(final String name,
            final String value,
            final String path,
            final String domain,
            final int version,
            final String comment,
            final int maxAge,
            final boolean secure) {
              super("", "");
    }

    public NewCookie(final String name,
            final String value,
            final String path,
            final String domain,
            final int version,
            final String comment,
            final int maxAge,
            final Date expiry,
            final boolean secure,
            final boolean httpOnly) {
              super("", "");
            }

    public NewCookie(final Cookie cookie) {
      super("", "");
    }

    public NewCookie(final Cookie cookie, final String comment, final int maxAge, final boolean secure) {
      super("", "");
    }

    public NewCookie(final Cookie cookie, final String comment, final int maxAge, final Date expiry, final boolean secure, final boolean httpOnly) {
      super("", "");
    }

    public static NewCookie valueOf(final String value) {
      return null;
    }

    public String getComment() {
      return null;
    }

    public int getMaxAge() {
      return 0;
    }

    public Date getExpiry() {
      return null;
    }

    public boolean isSecure() {
      return false;
    }

    public boolean isHttpOnly() {
      return false;
    }

    public Cookie toCookie() {
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
