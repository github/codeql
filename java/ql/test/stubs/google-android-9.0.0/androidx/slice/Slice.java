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

package androidx.slice;

import android.app.PendingIntent;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.graphics.drawable.IconCompat;
import java.util.List;
import java.util.Set;

public final class Slice {
  public @interface SliceHint {
  }

  public Slice() {}

  public Slice(Bundle in) {}

  public Bundle toBundle() {
    return null;
  }

  public Uri getUri() {
    return null;
  }

  public List<SliceItem> getItems() {
    return null;
  }

  public SliceItem[] getItemArray() {
    return null;
  }

  public @SliceHint List<String> getHints() {
    return null;
  }

  public @SliceHint String[] getHintArray() {
    return null;
  }

  public boolean hasHint(@SliceHint String hint) {
    return false;
  }

  public static class Builder {
    public Builder(@NonNull Uri uri) {}

    public Builder(@NonNull Slice.Builder parent) {}

    public Builder addHints(@SliceHint String... hints) {
      return null;
    }

    public Builder addHints(@SliceHint List<String> hints) {
      return null;
    }

    public Builder addSubSlice(@NonNull Slice slice) {
      return null;
    }

    public Builder addSubSlice(@NonNull Slice slice, String subType) {
      return null;
    }

    public Slice.Builder addAction(@NonNull PendingIntent action, @NonNull Slice s,
        @Nullable String subType) {
      return null;
    }

    public Slice.Builder addAction(@NonNull SliceItem.ActionHandler action, @NonNull Slice s,
        @Nullable String subType) {
      return null;
    }

    public Builder addText(CharSequence text, @Nullable String subType,
        @SliceHint String... hints) {
      return null;
    }

    public Builder addText(CharSequence text, @Nullable String subType,
        @SliceHint List<String> hints) {
      return null;
    }

    public Builder addIcon(IconCompat icon, @Nullable String subType, @SliceHint String... hints) {
      return null;
    }

    public Builder addIcon(IconCompat icon, @Nullable String subType,
        @SliceHint List<String> hints) {
      return null;
    }

    public Builder addInt(int value, @Nullable String subType, @SliceHint String... hints) {
      return null;
    }

    public Builder addInt(int value, @Nullable String subType, @SliceHint List<String> hints) {
      return null;
    }

    public Slice.Builder addLong(long time, @Nullable String subType, @SliceHint String... hints) {
      return null;
    }

    public Slice.Builder addLong(long time, @Nullable String subType,
        @SliceHint List<String> hints) {
      return null;
    }

    public Slice.Builder addTimestamp(long time, @Nullable String subType,
        @SliceHint String... hints) {
      return null;
    }

    public Slice.Builder addTimestamp(long time, @Nullable String subType,
        @SliceHint List<String> hints) {
      return null;
    }

    public Slice.Builder addItem(SliceItem item) {
      return null;
    }

    public Slice build() {
      return null;
    }

  }

  public String toString(String indent) {
    return null;
  }

  public static void appendHints(StringBuilder sb, String[] hints) {}

  public static Slice bindSlice(Context context, @NonNull Uri uri, Set<SliceSpec> supportedSpecs) {
    return null;
  }

}
