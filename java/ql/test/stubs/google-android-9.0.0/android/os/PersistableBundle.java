/*
 * Copyright (C) 2014 The Android Open Source Project
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

package android.os;

import android.annotation.NonNull;
import android.annotation.Nullable;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public final class PersistableBundle extends BaseBundle implements Cloneable, Parcelable {
  public static boolean isValidType(Object value) {
    return false;
  }

  public PersistableBundle() {}

  public PersistableBundle(int capacity) {}

  public PersistableBundle(PersistableBundle b) {}

  public PersistableBundle(Bundle b) {}

  public static PersistableBundle forPair(String key, String value) {
    return null;
  }

  @Override
  public Object clone() {
    return null;
  }

  public PersistableBundle deepCopy() {
    return null;
  }

  public void putPersistableBundle(@Nullable String key, @Nullable PersistableBundle value) {}

  public PersistableBundle getPersistableBundle(@Nullable String key) {
    return null;
  }

  @Override
  public void writeToParcel(Parcel parcel, int flags) {}

  @Override
  synchronized public String toString() {
    return null;
  }

  synchronized public String toShortString() {
    return null;
  }

  public void writeToStream(@NonNull OutputStream outputStream) throws IOException {}

  public static PersistableBundle readFromStream(@NonNull InputStream inputStream)
      throws IOException {
    return null;
  }

}
