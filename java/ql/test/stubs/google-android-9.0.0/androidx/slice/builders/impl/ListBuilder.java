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

package androidx.slice.builders.impl;

import android.app.PendingIntent;
import android.os.PersistableBundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.slice.builders.GridRowBuilder;
import androidx.slice.builders.ListBuilder.HeaderBuilder;
import androidx.slice.builders.ListBuilder.InputRangeBuilder;
import androidx.slice.builders.ListBuilder.RangeBuilder;
import androidx.slice.builders.ListBuilder.RatingBuilder;
import androidx.slice.builders.ListBuilder.RowBuilder;
import androidx.slice.builders.SelectionBuilder;
import androidx.slice.builders.SliceAction;
import java.time.Duration;
import java.util.Set;

public interface ListBuilder {
    void addRow(@NonNull RowBuilder impl);

    void addGridRow(@NonNull GridRowBuilder impl);

    void setHeader(@NonNull HeaderBuilder impl);

    void addAction(@NonNull SliceAction action);

    void addRating(@NonNull RatingBuilder builder);

    void addInputRange(@NonNull InputRangeBuilder builder);

    void addRange(@NonNull RangeBuilder builder);

    void addSelection(@NonNull SelectionBuilder builder);

    void setSeeMoreRow(@NonNull RowBuilder builder);

    void setSeeMoreAction(@NonNull PendingIntent intent);

    void setColor(int color);

    void setKeywords(@NonNull Set<String> keywords);

    void setTtl(long ttl);

    void setTtl(@Nullable Duration ttl);

    void setIsError(boolean isError);

    void setLayoutDirection(int layoutDirection);

    void setHostExtras(@NonNull PersistableBundle extras);

}
