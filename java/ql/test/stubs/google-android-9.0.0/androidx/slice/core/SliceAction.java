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
import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.core.graphics.drawable.IconCompat;

public interface SliceAction {
    SliceAction setContentDescription(@NonNull CharSequence description);

    SliceAction setChecked(boolean isChecked);

    SliceAction setPriority(@IntRange(from = 0) int priority);

    SliceAction setKey(@NonNull String key);

    PendingIntent getAction();

    IconCompat getIcon();

    CharSequence getTitle();

    CharSequence getContentDescription();

    int getPriority();

    String getKey();

    boolean isToggle();

    boolean isChecked();

    boolean isActivity();

    @SliceHints.ImageMode
    int getImageMode();

    boolean isDefaultToggle();

}
