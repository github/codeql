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

package androidx.slice.builders;

import android.app.PendingIntent;
import android.graphics.drawable.Icon;
import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.core.graphics.drawable.IconCompat;
import androidx.remotecallback.RemoteCallback;
import androidx.slice.Slice;
import androidx.slice.core.SliceActionImpl;

public class SliceAction implements androidx.slice.core.SliceAction {
  public SliceAction(@NonNull PendingIntent action, @NonNull Icon actionIcon,
      @NonNull CharSequence actionTitle) {}

  public SliceAction(@NonNull PendingIntent action, @NonNull Icon actionIcon,
      @ListBuilder.ImageMode int imageMode, @NonNull CharSequence actionTitle) {}

  public SliceAction(@NonNull PendingIntent action, @NonNull Icon actionIcon,
      @NonNull CharSequence actionTitle, boolean isChecked) {}

  public SliceAction(@NonNull PendingIntent action, @NonNull IconCompat actionIcon,
      @NonNull CharSequence actionTitle) {}

  public SliceAction(@NonNull PendingIntent action, @NonNull IconCompat actionIcon,
      @ListBuilder.ImageMode int imageMode, @NonNull CharSequence actionTitle) {}

  public SliceAction(@NonNull PendingIntent action, @NonNull IconCompat actionIcon,
      @NonNull CharSequence actionTitle, boolean isChecked) {}

  public SliceAction(@NonNull PendingIntent action, @NonNull CharSequence actionTitle,
      boolean isChecked) {}

  public SliceAction(@NonNull PendingIntent action, @NonNull CharSequence actionTitle,
      long dateTimeMillis, boolean isDatePicker) {}

  public static SliceAction create(@NonNull PendingIntent action, @NonNull IconCompat actionIcon,
      @ListBuilder.ImageMode int imageMode, @NonNull CharSequence actionTitle) {
    return null;
  }

  public static SliceAction create(@NonNull RemoteCallback action, @NonNull IconCompat actionIcon,
      @ListBuilder.ImageMode int imageMode, @NonNull CharSequence actionTitle) {
    return null;
  }

  public static SliceAction createDatePicker(@NonNull PendingIntent action,
      @NonNull CharSequence actionTitle, long dateTimeMillis) {
    return null;
  }

  public static SliceAction createTimePicker(@NonNull PendingIntent action,
      @NonNull CharSequence actionTitle, long dateTimeMillis) {
    return null;
  }

  public static SliceAction createDeeplink(@NonNull PendingIntent action,
      @NonNull IconCompat actionIcon, @ListBuilder.ImageMode int imageMode,
      @NonNull CharSequence actionTitle) {
    return null;
  }

  public static SliceAction createDeeplink(@NonNull RemoteCallback action,
      @NonNull IconCompat actionIcon, @ListBuilder.ImageMode int imageMode,
      @NonNull CharSequence actionTitle) {
    return null;
  }

  public static SliceAction createToggle(@NonNull PendingIntent action,
      @NonNull CharSequence actionTitle, boolean isChecked) {
    return null;
  }

  public static SliceAction createToggle(@NonNull RemoteCallback action,
      @NonNull CharSequence actionTitle, boolean isChecked) {
    return null;
  }

  public static SliceAction createToggle(@NonNull PendingIntent action,
      @NonNull IconCompat actionIcon, @NonNull CharSequence actionTitle, boolean isChecked) {
    return null;
  }

  public static SliceAction createToggle(@NonNull RemoteCallback action,
      @NonNull IconCompat actionIcon, @NonNull CharSequence actionTitle, boolean isChecked) {
    return null;
  }

  @Override
  public SliceAction setContentDescription(@NonNull CharSequence description) {
    return null;
  }

  @Override
  public SliceAction setChecked(boolean isChecked) {
    return null;
  }

  @Override
  public SliceAction setPriority(@IntRange(from = 0) int priority) {
    return null;
  }

  @Override
  public PendingIntent getAction() {
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
  public boolean isActivity() {
    return false;
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
  public boolean isToggle() {
    return false;
  }

  @Override
  public boolean isChecked() {
    return false;
  }

  @Override
  public @ListBuilder.ImageMode int getImageMode() {
    return 0;
  }

  @Override
  public boolean isDefaultToggle() {
    return false;
  }

  public Slice buildSlice(@NonNull Slice.Builder builder) {
    return null;
  }

  public SliceActionImpl getImpl() {
    return null;
  }

  public void setPrimaryAction(@NonNull Slice.Builder builder) {}

  @Override
  public androidx.slice.core.SliceAction setKey(String key) {
    return null;
  }

  @Override
  public String getKey() {
    return null;
  }

}
