/*
 * Copyright 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package androidx.slice.builders;
import android.app.PendingIntent;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.graphics.drawable.IconCompat;
import androidx.remotecallback.RemoteCallback;
import java.util.List;

public class GridRowBuilder {
    public GridRowBuilder() {
    }

    public GridRowBuilder addCell(@NonNull CellBuilder builder) {
      return null;
    }

    public GridRowBuilder setSeeMoreCell(@NonNull CellBuilder builder) {
      return null;
    }

    public GridRowBuilder setSeeMoreAction(@NonNull PendingIntent intent) {
      return null;
    }

    public GridRowBuilder setSeeMoreAction(@NonNull RemoteCallback callback) {
      return null;
    }

    public GridRowBuilder setPrimaryAction(@NonNull SliceAction action) {
      return null;
    }

    public GridRowBuilder setContentDescription(@NonNull CharSequence description) {
      return null;
    }

    public GridRowBuilder setLayoutDirection(@ListBuilder.LayoutDirection int layoutDirection) {
      return null;
    }

    public SliceAction getPrimaryAction() {
      return null;
    }

    public List<CellBuilder> getCells() {
      return null;
    }

    public CellBuilder getSeeMoreCell() {
      return null;
    }

    public PendingIntent getSeeMoreIntent() {
      return null;
    }

    public CharSequence getDescription() {
      return null;
    }

    public int getLayoutDirection() {
      return 0;
    }

    public static class CellBuilder {
        public CellBuilder() {
        }

        public CellBuilder addText(@NonNull CharSequence text) {
          return null;
        }

        public CellBuilder addText(@Nullable CharSequence text, boolean isLoading) {
          return null;
        }

        public CellBuilder addTitleText(@NonNull CharSequence text) {
          return null;
        }

        public CellBuilder addTitleText(@Nullable CharSequence text, boolean isLoading) {
          return null;
        }

        public CellBuilder addImage(@NonNull IconCompat image,
                @ListBuilder.ImageMode int imageMode) {
          return null;
        }

        public CellBuilder addImage(@Nullable IconCompat image,
                @ListBuilder.ImageMode int imageMode, boolean isLoading) {
          return null;
        }

        public CellBuilder addOverlayText(@NonNull CharSequence text) {
          return null;
        }

        public CellBuilder addOverlayText(@Nullable CharSequence text, boolean isLoading) {
          return null;
        }

        public CellBuilder setContentIntent(@NonNull PendingIntent intent) {
          return null;
        }

        public CellBuilder setContentIntent(@NonNull RemoteCallback callback) {
          return null;
        }

        public CellBuilder setContentDescription(@NonNull CharSequence description) {
          return null;
        }

        public CellBuilder setSliceAction(@NonNull SliceAction action) {
          return null;
        }

        public List<Object> getObjects() {
          return null;
        }

        public List<Integer> getTypes() {
          return null;
        }

        public List<Boolean> getLoadings() {
          return null;
        }

        public CharSequence getCellDescription() {
          return null;
        }

        public PendingIntent getContentIntent() {
          return null;
        }

        public CharSequence getTitle() {
          return null;
        }

        public CharSequence getSubtitle() {
          return null;
        }

        public SliceAction getSliceAction() {
          return null;
        }

    }
}
