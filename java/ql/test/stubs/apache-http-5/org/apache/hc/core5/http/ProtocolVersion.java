/*
 * ====================================================================
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */

package org.apache.hc.core5.http;

import java.io.Serializable;

public class ProtocolVersion implements Serializable {
    public ProtocolVersion(final String protocol, final int major, final int minor) {
    }

    public final String getProtocol() {
      return null;
    }

    public final int getMajor() {
      return 0;
    }

    public final int getMinor() {
      return 0;
    }

    @Override
    public final int hashCode() {
      return 0;
    }

    public final boolean equals(final int major, final int minor) {
      return false;
    }

    @Override
    public final boolean equals(final Object obj) {
      return false;
    }

    public String format() {
      return null;
    }

    public boolean isComparable(final ProtocolVersion that) {
      return false;
    }

    public int compareToVersion(final ProtocolVersion that) {
      return 0;
    }

    public final boolean greaterEquals(final ProtocolVersion version) {
      return false;
    }

    public final boolean lessEquals(final ProtocolVersion version) {
      return false;
    }

    @Override
    public String toString() {
      return null;
    }

}
