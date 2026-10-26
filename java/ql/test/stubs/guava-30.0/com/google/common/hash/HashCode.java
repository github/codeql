/*
 * Copyright (C) 2011 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.common.hash;
import org.checkerframework.checker.nullness.qual.Nullable;

public abstract class HashCode {
  public abstract int bits();

  public abstract int asInt();

  public abstract long asLong();

  public abstract long padToLong();

  public abstract byte[] asBytes();

  public int writeBytesTo(byte[] dest, int offset, int maxLength) {
    return 0;
  }

  public static HashCode fromInt(int hash) {
    return null;
  }

  public static HashCode fromLong(long hash) {
    return null;
  }

  public static HashCode fromBytes(byte[] bytes) {
    return null;
  }

  public static HashCode fromString(String string) {
    return null;
  }

  @Override
  public final boolean equals(@Nullable Object object) {
    return false;
  }

  @Override
  public final int hashCode() {
    return 0;
  }

  @Override
  public final String toString() {
    return null;
  }

}
