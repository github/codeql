/*
 * Copyright (C) 2015 The Android Open Source Project
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

package android.graphics.drawable;

import android.annotation.NonNull;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public final class Icon implements Parcelable {
  public @interface IconType {
  }

  public int getType() {
    return 0;
  }

  public int getDataLength() {
    return 0;
  }

  public int getDataOffset() {
    return 0;
  }

  public byte[] getDataBytes() {
    return null;
  }

  public String getResPackage() {
    return null;
  }

  public int getResId() {
    return 0;
  }

  public String getUriString() {
    return null;
  }

  public Uri getUri() {
    return null;
  }

  public static final int MIN_ASHMEM_ICON_SIZE = 128 * (1 << 10);

  public void convertToAshmem() {}

  public void writeToStream(OutputStream stream) throws IOException {}

  public static Icon createFromStream(InputStream stream) throws IOException {
    return null;
  }

  public boolean sameAs(Icon otherIcon) {
    return false;
  }

  public static Icon createWithData(byte[] data, int offset, int length) {
    return null;
  }

  public static Icon createWithContentUri(String uri) {
    return null;
  }

  public static Icon createWithContentUri(Uri uri) {
    return null;
  }

  public static Icon createWithAdaptiveBitmapContentUri(@NonNull String uri) {
    return null;
  }

  public static Icon createWithAdaptiveBitmapContentUri(@NonNull Uri uri) {
    return null;
  }

  public boolean hasTint() {
    return false;
  }

  public static Icon createWithFilePath(String path) {
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
  public void writeToParcel(Parcel dest, int flags) {}

  public void scaleDownIfNecessary(int maxWidth, int maxHeight) {}

}
