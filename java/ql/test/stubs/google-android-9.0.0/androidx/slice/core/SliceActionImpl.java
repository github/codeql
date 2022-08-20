/*
 * Copyright 2018 The Android Open Source Project
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

package androidx.slice.core;

import android.app.PendingIntent;
import androidx.annotation.NonNull;
import androidx.core.graphics.drawable.IconCompat;
import androidx.slice.Slice;
import androidx.slice.SliceItem;

public class SliceActionImpl implements SliceAction {
  public SliceActionImpl(@NonNull PendingIntent action, @NonNull IconCompat actionIcon,
      @NonNull CharSequence actionTitle) {}

  public SliceActionImpl(@NonNull PendingIntent action, @NonNull CharSequence actionTitle,
      long dateTimeMillis, boolean isDatePicker) {}

  public SliceActionImpl(@NonNull PendingIntent action, @NonNull IconCompat actionIcon,
      @SliceHints.ImageMode int imageMode, @NonNull CharSequence actionTitle) {}

  public SliceActionImpl(@NonNull PendingIntent action, @NonNull IconCompat actionIcon,
      @NonNull CharSequence actionTitle, boolean isChecked) {}

  public SliceActionImpl(@NonNull PendingIntent action, @NonNull CharSequence actionTitle,
      boolean isChecked) {}

  public SliceActionImpl(SliceItem slice) {}

  @Override
  public SliceActionImpl setContentDescription(@NonNull CharSequence description) {
    return null;
  }

  @Override
  public SliceActionImpl setChecked(boolean isChecked) {
    return null;
  }

  @Override
  public SliceActionImpl setKey(@NonNull String key) {
    return null;
  }

  @Override
  public PendingIntent getAction() {
    return null;
  }

  public SliceItem getActionItem() {
    return null;
  }

  @Override
  public IconCompat getIcon() {
    return null;
  }

  @Override
  public CharSequence getTitle() {
    return null;
  }

  @Override
  public CharSequence getContentDescription() {
    return null;
  }

  @Override
  public int getPriority() {
    return 0;
  }

  @Override
  public String getKey() {
    return null;
  }

  @Override
  public boolean isToggle() {
    return false;
  }

  @Override
  public boolean isChecked() {
    return false;
  }

  @Override
  public @SliceHints.ImageMode int getImageMode() {
    return 0;
  }

  @Override
  public boolean isDefaultToggle() {
    return false;
  }

  public SliceItem getSliceItem() {
    return null;
  }

  @Override
  public boolean isActivity() {
    return false;
  }

  public Slice buildSlice(@NonNull Slice.Builder builder) {
    return null;
  }

  public Slice buildPrimaryActionSlice(@NonNull Slice.Builder builder) {
    return null;
  }

  public String getSubtype() {
    return null;
  }

  public void setActivity(boolean isActivity) {}

  public static int parseImageMode(@NonNull SliceItem iconItem) {
    return 0;
  }

  @Override
  public SliceAction setPriority(int priority) {
    return null;
  }

}
