/*
 * Copyright (C) 2006 The Android Open Source Project
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

package android.content.res;

import android.os.Bundle;
import android.os.Parcel;
import android.os.ParcelFileDescriptor;
import android.os.Parcelable;
import java.io.Closeable;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class AssetFileDescriptor implements Parcelable, Closeable {
  public AssetFileDescriptor(ParcelFileDescriptor fd, long startOffset, long length) {}

  public AssetFileDescriptor(ParcelFileDescriptor fd, long startOffset, long length,
      Bundle extras) {}

  public ParcelFileDescriptor getParcelFileDescriptor() {
    return null;
  }

  public FileDescriptor getFileDescriptor() {
    return null;
  }

  public long getStartOffset() {
    return 0;
  }

  public Bundle getExtras() {
    return null;
  }

  public long getLength() {
    return 0;
  }

  public long getDeclaredLength() {
    return 0;
  }

  @Override
  public void close() throws IOException {}

  public FileInputStream createInputStream() throws IOException {
    return null;
  }

  public FileOutputStream createOutputStream() throws IOException {
    return null;
  }

  @Override
  public String toString() {
    return null;
  }

  public int describeContents() {
    return 0;
  }

  @Override
  public void writeToParcel(Parcel out, int flags) {}

}
