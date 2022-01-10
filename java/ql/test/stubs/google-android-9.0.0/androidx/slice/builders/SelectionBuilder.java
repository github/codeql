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
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.remotecallback.RemoteCallback;

public class SelectionBuilder {
  public SelectionBuilder() {}

  public SelectionBuilder addOption(String optionKey, CharSequence optionText) {
    return null;
  }

  public SelectionBuilder setPrimaryAction(@NonNull SliceAction primaryAction) {
    return null;
  }

  public SelectionBuilder setInputAction(@NonNull PendingIntent inputAction) {
    return null;
  }

  public SelectionBuilder setInputAction(@NonNull RemoteCallback inputAction) {
    return null;
  }

  public SelectionBuilder setSelectedOption(String selectedOption) {
    return null;
  }

  public SelectionBuilder setTitle(@Nullable CharSequence title) {
    return null;
  }

  public SelectionBuilder setSubtitle(@Nullable CharSequence subtitle) {
    return null;
  }

  public SelectionBuilder setContentDescription(@Nullable CharSequence contentDescription) {
    return null;
  }

  public SelectionBuilder setLayoutDirection(
      @androidx.slice.builders.ListBuilder.LayoutDirection int layoutDirection) {
    return null;
  }

  public SliceAction getPrimaryAction() {
    return null;
  }

  public PendingIntent getInputAction() {
    return null;
  }

  public String getSelectedOption() {
    return null;
  }

  public CharSequence getTitle() {
    return null;
  }

  public CharSequence getSubtitle() {
    return null;
  }

  public CharSequence getContentDescription() {
    return null;
  }

  public int getLayoutDirection() {
    return 0;
  }

  public void check() {}

}
