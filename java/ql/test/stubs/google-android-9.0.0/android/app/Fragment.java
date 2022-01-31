/*
 * Copyright (C) 2010 The Android Open Source Project
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

package android.app;

import android.annotation.Nullable;
import android.content.ComponentCallbacks2;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

public class Fragment implements ComponentCallbacks2 {
  public static class SavedState implements Parcelable {
    @Override
    public int describeContents() {
      return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {}

  }

  static public class InstantiationException {
    public InstantiationException(String msg, Exception cause) {}
  }


  public Fragment() {}

  public static Fragment instantiate(Context context, String fname) {
    return null;
  }

  public static Fragment instantiate(Context context, String fname, @Nullable Bundle args) {
    return null;
  }

  @Override
  final public boolean equals(Object o) {
    return false;
  }

  @Override
  final public int hashCode() {
    return 0;
  }

  @Override
  public String toString() {
    return null;
  }

  @Override
  public void onConfigurationChanged(Configuration p0) {}

  @Override
  public void onLowMemory() {}

  @Override
  public void onTrimMemory(int p0) {}

  public void startActivityForResult(Intent intent, int requestCode) {}

  public void startActivityForResult(Intent intent, int requestCode, Bundle options) {}

  public void onActivityResult(int requestCode, int resultCode, Intent data) {}
}
