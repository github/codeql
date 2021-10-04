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
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.graphics.drawable.IconCompat;
import java.util.List;

public final class SliceItem {
  public @interface SliceType {
  }

  public SliceItem(Object obj, @SliceType String format, String subType,
      @Slice.SliceHint String[] hints) {}

  public SliceItem(Object obj, @SliceType String format, String subType,
      @Slice.SliceHint List<String> hints) {}

  public SliceItem() {}

  public SliceItem(PendingIntent intent, Slice slice, String format, String subType,
      @Slice.SliceHint String[] hints) {}

  public SliceItem(ActionHandler action, Slice slice, String format, String subType,
      @Slice.SliceHint String[] hints) {}

  public @NonNull @Slice.SliceHint List<String> getHints() {
    return null;
  }

  public @NonNull @Slice.SliceHint String[] getHintArray() {
    return null;
  }

  public void addHint(@Slice.SliceHint String hint) {}

  public @SliceType String getFormat() {
    return null;
  }

  public String getSubType() {
    return null;
  }

  public CharSequence getText() {
    return null;
  }

  public CharSequence getSanitizedText() {
    return null;
  }

  public CharSequence getRedactedText() {
    return null;
  }

  public IconCompat getIcon() {
    return null;
  }

  public PendingIntent getAction() {
    return null;
  }

  public void fireAction(@Nullable Context context, @Nullable Intent i)
      throws PendingIntent.CanceledException {}

  public boolean fireActionInternal(@Nullable Context context, @Nullable Intent i)
      throws PendingIntent.CanceledException {
    return false;
  }

  public int getInt() {
    return 0;
  }

  public Slice getSlice() {
    return null;
  }

  public long getLong() {
    return 0;
  }

  public boolean hasHint(@Slice.SliceHint String hint) {
    return false;
  }

  public SliceItem(Bundle in) {}

  public Bundle toBundle() {
    return null;
  }

  public boolean hasHints(@Slice.SliceHint String[] hints) {
    return false;
  }

  public boolean hasAnyHints(@Slice.SliceHint String... hints) {
    return false;
  }

  public static String typeToString(String format) {
    return null;
  }

  @Override
  public String toString() {
    return null;
  }

  public String toString(String indent) {
    return null;
  }

  public interface ActionHandler {
    void onAction(SliceItem item, Context context, Intent intent);

  }
}
