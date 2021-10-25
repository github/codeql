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

package org.apache.hc.core5.util;

import java.io.Serializable;
import java.nio.ByteBuffer;

public final class ByteArrayBuffer implements Serializable {
    public ByteArrayBuffer(final int capacity) {
    }

    public void append(final byte[] b, final int off, final int len) {
    }

    public void append(final int b) {
    }

    public void append(final char[] b, final int off, final int len) {
    }

    public void append(final CharArrayBuffer b, final int off, final int len) {
    }

    public void append(final ByteBuffer buffer) {
    }

    public void clear() {
    }

    public byte[] toByteArray() {
      return null;
    }

    public int byteAt(final int i) {
      return 0;
    }

    public int capacity() {
      return 0;
    }

    public int length() {
      return 0;
    }

    public void ensureCapacity(final int required) {
    }

    public byte[] array() {
      return null;
    }

    public void setLength(final int len) {
    }

    public boolean isEmpty() {
      return false;
    }

    public boolean isFull() {
      return false;
    }

    public int indexOf(final byte b, final int from, final int to) {
      return 0;
    }

    public int indexOf(final byte b) {
      return 0;
    }

}
