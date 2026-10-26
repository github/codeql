/*
 * Copyright (C) 2017 The Android Open Source Project
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

package androidx.core.graphics.drawable;

import android.content.Context;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import java.io.InputStream;

public class IconCompat {
  public @interface IconType {
  }

  public static IconCompat createWithData(byte[] data, int offset, int length) {
    return null;
  }

  public static IconCompat createWithContentUri(String uri) {
    return null;
  }

  public static IconCompat createWithContentUri(Uri uri) {
    return null;
  }

  public static IconCompat createWithAdaptiveBitmapContentUri(@NonNull String uri) {
    return null;
  }

  public static IconCompat createWithAdaptiveBitmapContentUri(@NonNull Uri uri) {
    return null;
  }

  public IconCompat() {}

  public int getType() {
    return 0;
  }

  public String getResPackage() {
    return null;
  }

  public int getResId() {
    return 0;
  }

  public Uri getUri() {
    return null;
  }

  public Icon toIcon() {
    return null;
  }

  public Icon toIcon(@Nullable Context context) {
    return null;
  }

  public void checkResource(@NonNull Context context) {}


  public InputStream getUriInputStream(@NonNull Context context) {
    return null;
  }

  public Bundle toBundle() {
    return null;
  }

  public static @Nullable IconCompat createFromBundle(@NonNull Bundle bundle) {
    return null;
  }

  public static IconCompat createFromIcon(@NonNull Context context, @NonNull Icon icon) {
    return null;
  }

  public static IconCompat createFromIcon(@NonNull Icon icon) {
    return null;
  }

  public static IconCompat createFromIconOrNullIfZeroResId(@NonNull Icon icon) {
    return null;
  }

}
