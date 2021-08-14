/*
 * Copyright (c) 2010, 2017 Oracle and/or its affiliates. All rights reserved.
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
import java.util.Date;

public class NewCookie extends Cookie {
    public NewCookie(String name, String value) {
      super("", "");
    }

    public NewCookie(String name,
                     String value,
                     String path,
                     String domain,
                     String comment,
                     int maxAge,
                     boolean secure) {
                      super("", "");
    }

    public NewCookie(String name,
                     String value,
                     String path,
                     String domain,
                     String comment,
                     int maxAge,
                     boolean secure,
                     boolean httpOnly) {
                      super("", "");
    }

    public NewCookie(String name,
                     String value,
                     String path,
                     String domain,
                     int version,
                     String comment,
                     int maxAge,
                     boolean secure) {
                      super("", "");
    }

    public NewCookie(String name,
                     String value,
                     String path,
                     String domain,
                     int version,
                     String comment,
                     int maxAge,
                     Date expiry,
                     boolean secure,
                     boolean httpOnly) {
                      super("", "");
    }

    public NewCookie(Cookie cookie) {
      super("", "");
    }

    public NewCookie(Cookie cookie, String comment, int maxAge, boolean secure) {
      super("", "");
    }

    public NewCookie(Cookie cookie, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly) {
      super("", "");
    }

    public static NewCookie valueOf(String value) {
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
    public boolean equals(Object obj) {
      return false;
    }

}
