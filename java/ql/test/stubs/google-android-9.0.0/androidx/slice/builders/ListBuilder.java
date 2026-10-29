/*
 * Copyright 2017 The Android Open Source Project
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
import android.content.Context;
import android.net.Uri;
import android.os.PersistableBundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.graphics.drawable.IconCompat;
import androidx.remotecallback.RemoteCallback;
import androidx.slice.Slice;
import java.time.Duration;
import java.util.List;
import java.util.Set;

public class ListBuilder extends TemplateSliceBuilder {
  public @interface ImageMode {
  }
  public @interface LayoutDirection {
  }

  public ListBuilder addRating(@NonNull RatingBuilder b) {
    return null;
  }

  public ListBuilder(@NonNull Context context, @NonNull Uri uri, long ttl) {
    super(null, null);
  }

  public ListBuilder(@NonNull Context context, @NonNull Uri uri, @Nullable Duration ttl) {
    super(null, null);
  }

  @Override
  public Slice build() {
    return null;
  }

  public ListBuilder addRow(@NonNull RowBuilder builder) {
    return null;
  }

  public ListBuilder addGridRow(@NonNull GridRowBuilder builder) {
    return null;
  }

  public ListBuilder setHeader(@NonNull HeaderBuilder builder) {
    return null;
  }

  public ListBuilder addAction(@NonNull SliceAction action) {
    return null;
  }

  public ListBuilder setAccentColor(int color) {
    return null;
  }

  public ListBuilder setKeywords(@NonNull final Set<String> keywords) {
    return null;
  }

  public ListBuilder setLayoutDirection(@LayoutDirection int layoutDirection) {
    return null;
  }

  public ListBuilder setHostExtras(@NonNull PersistableBundle extras) {
    return null;
  }

  public ListBuilder setSeeMoreRow(@NonNull RowBuilder builder) {
    return null;
  }

  public ListBuilder setSeeMoreAction(@NonNull PendingIntent intent) {
    return null;
  }

  public ListBuilder setSeeMoreAction(@NonNull RemoteCallback callback) {
    return null;
  }

  public ListBuilder setIsError(boolean isError) {
    return null;
  }

  public androidx.slice.builders.impl.ListBuilder getImpl() {
    return null;
  }

  public @interface RangeMode {
  }

  public ListBuilder addInputRange(@NonNull InputRangeBuilder b) {
    return null;
  }

  public ListBuilder addRange(@NonNull RangeBuilder rangeBuilder) {
    return null;
  }

  public ListBuilder addSelection(@NonNull SelectionBuilder selectionBuilder) {
    return null;
  }

  public static class RangeBuilder {
    public RangeBuilder() {}

    public RangeBuilder setTitleItem(@NonNull IconCompat icon, @ImageMode int imageMode) {
      return null;
    }

    public RangeBuilder setTitleItem(@NonNull IconCompat icon, @ImageMode int imageMode,
        boolean isLoading) {
      return null;
    }

    public RangeBuilder setMax(int max) {
      return null;
    }

    public RangeBuilder setValue(int value) {
      return null;
    }

    public RangeBuilder setTitle(@NonNull CharSequence title) {
      return null;
    }

    public RangeBuilder setSubtitle(@NonNull CharSequence title) {
      return null;
    }

    public RangeBuilder setPrimaryAction(@NonNull SliceAction action) {
      return null;
    }

    public RangeBuilder setContentDescription(@NonNull CharSequence description) {
      return null;
    }

    public RangeBuilder setLayoutDirection(@LayoutDirection int layoutDirection) {
      return null;
    }

    public RangeBuilder setMode(@RangeMode int mode) {
      return null;
    }

    public boolean isTitleItemLoading() {
      return false;
    }

    public int getTitleImageMode() {
      return 0;
    }

    public IconCompat getTitleIcon() {
      return null;
    }

    public int getValue() {
      return 0;
    }

    public int getMax() {
      return 0;
    }

    public boolean isValueSet() {
      return false;
    }

    public CharSequence getTitle() {
      return null;
    }

    public CharSequence getSubtitle() {
      return null;
    }

    public SliceAction getPrimaryAction() {
      return null;
    }

    public CharSequence getContentDescription() {
      return null;
    }

    public int getLayoutDirection() {
      return 0;
    }

    public int getMode() {
      return 0;
    }

  }
  public static final class RatingBuilder {
    public RatingBuilder() {}

    public int getMin() {
      return 0;
    }

    public RatingBuilder setMin(int min) {
      return null;
    }

    public int getMax() {
      return 0;
    }

    public RatingBuilder setMax(int max) {
      return null;
    }

    public float getValue() {
      return 0;
    }

    public RatingBuilder setValue(float value) {
      return null;
    }

    public boolean isValueSet() {
      return false;
    }

    public PendingIntent getAction() {
      return null;
    }

    public CharSequence getContentDescription() {
      return null;
    }

    public RatingBuilder setTitle(@NonNull CharSequence title) {
      return null;
    }

    public RatingBuilder setSubtitle(@NonNull CharSequence title) {
      return null;
    }

    public RatingBuilder setPrimaryAction(@NonNull SliceAction action) {
      return null;
    }

    public RatingBuilder setTitleItem(@NonNull IconCompat icon, @ImageMode int imageMode) {
      return null;
    }

    public RatingBuilder setTitleItem(@NonNull IconCompat icon, @ImageMode int imageMode,
        boolean isLoading) {
      return null;
    }

    public RatingBuilder setContentDescription(@NonNull CharSequence description) {
      return null;
    }

    public PendingIntent getInputAction() {
      return null;
    }

    public RatingBuilder setInputAction(@NonNull PendingIntent action) {
      return null;
    }

    public RatingBuilder setInputAction(@NonNull RemoteCallback callback) {
      return null;
    }

    public CharSequence getTitle() {
      return null;
    }

    public CharSequence getSubtitle() {
      return null;
    }

    public SliceAction getPrimaryAction() {
      return null;
    }

    public boolean isTitleItemLoading() {
      return false;
    }

    public int getTitleImageMode() {
      return 0;
    }

    public IconCompat getTitleIcon() {
      return null;
    }

  }
  public static class InputRangeBuilder {
    public InputRangeBuilder() {}

    public InputRangeBuilder setTitleItem(@NonNull IconCompat icon, @ImageMode int imageMode) {
      return null;
    }

    public InputRangeBuilder addEndItem(@NonNull SliceAction action) {
      return null;
    }

    public InputRangeBuilder addEndItem(@NonNull SliceAction action, boolean isLoading) {
      return null;
    }

    public InputRangeBuilder setTitleItem(@NonNull IconCompat icon, @ImageMode int imageMode,
        boolean isLoading) {
      return null;
    }

    public InputRangeBuilder setMin(int min) {
      return null;
    }

    public InputRangeBuilder setMax(int max) {
      return null;
    }

    public InputRangeBuilder setValue(int value) {
      return null;
    }

    public InputRangeBuilder setTitle(@NonNull CharSequence title) {
      return null;
    }

    public InputRangeBuilder setSubtitle(@NonNull CharSequence title) {
      return null;
    }

    public InputRangeBuilder setInputAction(@NonNull PendingIntent action) {
      return null;
    }

    public InputRangeBuilder setInputAction(@NonNull RemoteCallback callback) {
      return null;
    }

    public InputRangeBuilder setThumb(@NonNull IconCompat thumb) {
      return null;
    }

    public InputRangeBuilder setPrimaryAction(@NonNull SliceAction action) {
      return null;
    }

    public InputRangeBuilder setContentDescription(@NonNull CharSequence description) {
      return null;
    }

    public InputRangeBuilder setLayoutDirection(@LayoutDirection int layoutDirection) {
      return null;
    }

    public boolean isTitleItemLoading() {
      return false;
    }

    public int getTitleImageMode() {
      return 0;
    }

    public IconCompat getTitleIcon() {
      return null;
    }

    public List<Object> getEndItems() {
      return null;
    }

    public List<Integer> getEndTypes() {
      return null;
    }

    public List<Boolean> getEndLoads() {
      return null;
    }

    public int getMin() {
      return 0;
    }

    public int getMax() {
      return 0;
    }

    public int getValue() {
      return 0;
    }

    public boolean isValueSet() {
      return false;
    }

    public CharSequence getTitle() {
      return null;
    }

    public CharSequence getSubtitle() {
      return null;
    }

    public PendingIntent getAction() {
      return null;
    }

    public PendingIntent getInputAction() {
      return null;
    }

    public IconCompat getThumb() {
      return null;
    }

    public SliceAction getPrimaryAction() {
      return null;
    }

    public CharSequence getContentDescription() {
      return null;
    }

    public int getLayoutDirection() {
      return 0;
    }

  }
  public static class RowBuilder {
    public RowBuilder() {}

    public RowBuilder(@NonNull final Uri uri) {}

    public RowBuilder setEndOfSection(boolean isEndOfSection) {
      return null;
    }

    public RowBuilder setTitleItem(long timeStamp) {
      return null;
    }

    public RowBuilder setTitleItem(@NonNull IconCompat icon, @ImageMode int imageMode) {
      return null;
    }

    public RowBuilder setTitleItem(@Nullable IconCompat icon, @ImageMode int imageMode,
        boolean isLoading) {
      return null;
    }

    public RowBuilder setTitleItem(@NonNull SliceAction action) {
      return null;
    }

    public RowBuilder setTitleItem(@NonNull SliceAction action, boolean isLoading) {
      return null;
    }

    public RowBuilder setPrimaryAction(@NonNull SliceAction action) {
      return null;
    }

    public RowBuilder setTitle(@NonNull CharSequence title) {
      return null;
    }

    public RowBuilder setTitle(@Nullable CharSequence title, boolean isLoading) {
      return null;
    }

    public RowBuilder setSubtitle(@NonNull CharSequence subtitle) {
      return null;
    }

    public RowBuilder setSubtitle(@Nullable CharSequence subtitle, boolean isLoading) {
      return null;
    }

    public RowBuilder addEndItem(long timeStamp) {
      return null;
    }

    public RowBuilder addEndItem(@NonNull IconCompat icon, @ImageMode int imageMode) {
      return null;
    }

    public RowBuilder addEndItem(@Nullable IconCompat icon, @ImageMode int imageMode,
        boolean isLoading) {
      return null;
    }

    public RowBuilder addEndItem(@NonNull SliceAction action) {
      return null;
    }

    public RowBuilder addEndItem(@NonNull SliceAction action, boolean isLoading) {
      return null;
    }

    public RowBuilder setContentDescription(@NonNull CharSequence description) {
      return null;
    }

    public RowBuilder setLayoutDirection(@LayoutDirection int layoutDirection) {
      return null;
    }

    public Uri getUri() {
      return null;
    }

    public boolean isEndOfSection() {
      return false;
    }

    public boolean hasEndActionOrToggle() {
      return false;
    }

    public boolean hasEndImage() {
      return false;
    }

    public boolean hasDefaultToggle() {
      return false;
    }

    public boolean hasTimestamp() {
      return false;
    }

    public long getTimeStamp() {
      return 0;
    }

    public boolean isTitleItemLoading() {
      return false;
    }

    public int getTitleImageMode() {
      return 0;
    }

    public IconCompat getTitleIcon() {
      return null;
    }

    public SliceAction getTitleAction() {
      return null;
    }

    public SliceAction getPrimaryAction() {
      return null;
    }

    public CharSequence getTitle() {
      return null;
    }

    public boolean isTitleLoading() {
      return false;
    }

    public CharSequence getSubtitle() {
      return null;
    }

    public boolean isSubtitleLoading() {
      return false;
    }

    public CharSequence getContentDescription() {
      return null;
    }

    public int getLayoutDirection() {
      return 0;
    }

    public List<Object> getEndItems() {
      return null;
    }

    public List<Integer> getEndTypes() {
      return null;
    }

    public List<Boolean> getEndLoads() {
      return null;
    }

    public boolean isTitleActionLoading() {
      return false;
    }

  }
  public static class HeaderBuilder {
    public HeaderBuilder() {}

    public HeaderBuilder(@NonNull final Uri uri) {}

    public HeaderBuilder setTitle(@NonNull CharSequence title) {
      return null;
    }

    public HeaderBuilder setTitle(@NonNull CharSequence title, boolean isLoading) {
      return null;
    }

    public HeaderBuilder setSubtitle(@NonNull CharSequence subtitle) {
      return null;
    }

    public HeaderBuilder setSubtitle(@NonNull CharSequence subtitle, boolean isLoading) {
      return null;
    }

    public HeaderBuilder setSummary(@NonNull CharSequence summary) {
      return null;
    }

    public HeaderBuilder setSummary(@NonNull CharSequence summary, boolean isLoading) {
      return null;
    }

    public HeaderBuilder setPrimaryAction(@NonNull SliceAction action) {
      return null;
    }

    public HeaderBuilder setContentDescription(@NonNull CharSequence description) {
      return null;
    }

    public HeaderBuilder setLayoutDirection(@LayoutDirection int layoutDirection) {
      return null;
    }

    public Uri getUri() {
      return null;
    }

    public CharSequence getTitle() {
      return null;
    }

    public boolean isTitleLoading() {
      return false;
    }

    public CharSequence getSubtitle() {
      return null;
    }

    public boolean isSubtitleLoading() {
      return false;
    }

    public CharSequence getSummary() {
      return null;
    }

    public boolean isSummaryLoading() {
      return false;
    }

    public SliceAction getPrimaryAction() {
      return null;
    }

    public CharSequence getContentDescription() {
      return null;
    }

    public int getLayoutDirection() {
      return 0;
    }

  }
}
