/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.os;

public final class Bundle {
  public Bundle() {
  }

  public Bundle(ClassLoader loader) {
  }

  public Bundle(int capacity) {
  }

  public Bundle(Bundle b) {
  }

  public static Bundle forPair(String key, String value) {
    return null;
  }

  public boolean setAllowFds(boolean allowFds) {
    return false;
  }

  public void setDefusable(boolean defusable) {
  }

  public static Bundle setDefusable(Bundle bundle, boolean defusable) {
    return null;
  }

  @Override
  public Object clone() {
    return null;
  }

  public Bundle deepCopy() {
    return null;
  }

  public void remove(String key) {
  }

  public void putAll(Bundle bundle) {
  }

  public int getSize() {
    return 0;
  }

  public boolean hasFileDescriptors() {
    return false;
  }

  public Bundle filterValues() {
    return null;
  }

  @Override
  public synchronized String toString() {
    return null;
  }

  public synchronized String toShortString() {
    return null;
  }

  public String getString(String string) {
    return null;
  }

}
