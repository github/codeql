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
import java.util.List;
import java.util.Map;

public class CacheControl {
    public CacheControl() {
    }

    public static CacheControl valueOf(final String value) {
      return null;
    }

    public boolean isMustRevalidate() {
      return false;
    }

    public void setMustRevalidate(final boolean mustRevalidate) {
    }

    public boolean isProxyRevalidate() {
      return false;
    }

    public void setProxyRevalidate(final boolean proxyRevalidate) {
    }

    public int getMaxAge() {
      return 0;
    }

    public void setMaxAge(final int maxAge) {
    }

    public int getSMaxAge() {
      return 0;
    }

    public void setSMaxAge(final int sMaxAge) {
    }

    public List<String> getNoCacheFields() {
      return null;
    }

    public void setNoCache(final boolean noCache) {
    }

    public boolean isNoCache() {
      return false;
    }

    public boolean isPrivate() {
      return false;
    }

    public List<String> getPrivateFields() {
      return null;
    }

    public void setPrivate(final boolean flag) {
    }

    public boolean isNoTransform() {
      return false;
    }

    public void setNoTransform(final boolean noTransform) {
    }

    public boolean isNoStore() {
      return false;
    }

    public void setNoStore(final boolean noStore) {
    }

    public Map<String, String> getCacheExtension() {
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
