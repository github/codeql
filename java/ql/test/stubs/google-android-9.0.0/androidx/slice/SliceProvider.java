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

import java.util.Collection;
import java.util.List;
import android.app.PendingIntent;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.CancellationSignal;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public abstract class SliceProvider extends ContentProvider {
  public SliceProvider(@NonNull String... autoGrantPermissions) {}

  public SliceProvider() {}

  public abstract boolean onCreateSliceProvider();

  @Override
  public final boolean onCreate() {
    return false;
  }

  @Override
  public final String getType(@NonNull Uri uri) {
    return null;
  }

  @Override
  public Bundle call(@NonNull String method, @Nullable String arg, @Nullable Bundle extras) {
    return null;
  }

  public PendingIntent onCreatePermissionRequest(@NonNull Uri sliceUri,
      @NonNull String callingPackage) {
    return null;
  }

  public Slice createPermissionSlice(@NonNull Uri sliceUri, @NonNull String callingPackage) {
    return null;
  }

  public abstract Slice onBindSlice(@NonNull Uri sliceUri);

  public void onSlicePinned(@NonNull Uri sliceUri) {}

  public void onSliceUnpinned(@NonNull Uri sliceUri) {}

  public void handleSlicePinned(@NonNull Uri sliceUri) {}

  public void handleSliceUnpinned(@NonNull Uri sliceUri) {}

  public Uri onMapIntentToUri(@NonNull Intent intent) {
    return null;
  }

  public Collection<Uri> onGetSliceDescendants(@NonNull Uri uri) {
    return null;
  }

  public List<Uri> getPinnedSlices() {
    return null;
  }

  public void validateIncomingAuthority(@Nullable String authority) throws SecurityException {}

  @Override
  public final Cursor query(@NonNull Uri uri, @Nullable String[] projection,
      @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder) {
    return null;
  }

  @Override
  public final Cursor query(@NonNull Uri uri, @Nullable String[] projection,
      @Nullable Bundle queryArgs, @Nullable CancellationSignal cancellationSignal) {
    return null;
  }

  @Override
  public final Cursor query(@NonNull Uri uri, @Nullable String[] projection,
      @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder,
      @Nullable CancellationSignal cancellationSignal) {
    return null;
  }

  @Override
  public final Uri insert(@NonNull Uri uri, @Nullable ContentValues values) {
    return null;
  }

  @Override
  public final int bulkInsert(@NonNull Uri uri, @NonNull ContentValues[] values) {
    return 0;
  }

  @Override
  public final int delete(@NonNull Uri uri, @Nullable String selection,
      @Nullable String[] selectionArgs) {
    return 0;
  }

  @Override
  public final int update(@NonNull Uri uri, @Nullable ContentValues values,
      @Nullable String selection, @Nullable String[] selectionArgs) {
    return 0;
  }

  @Override
  public final Uri canonicalize(@NonNull Uri url) {
    return null;
  }

}
