/*
 * Copyright (C) 2006 The Android Open Source Project
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

package android.content;

import androidx.annotation.NonNull;
import android.annotation.Nullable;
import android.content.pm.PathPermission;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;
import android.util.Pair;
import java.io.FileNotFoundException;

public abstract class ContentProvider implements ContentInterface {
  public ContentProvider() {}

  public ContentProvider(Context context, String readPermission, String writePermission,
      PathPermission[] pathPermissions) {}

  public final @Nullable Context getContext() {
    return null;
  }

  public final Context requireContext() {
    return null;
  }

  public final @Nullable String getCallingPackage() {
    return null;
  }

  public final @Nullable String getCallingAttributionTag() {
    return null;
  }

  public final @Nullable String getCallingFeatureId() {
    return null;
  }

  public final @Nullable String getCallingPackageUnchecked() {
    return null;
  }

  public void onCallingPackageChanged() {}

  public final class CallingIdentity {
    public CallingIdentity(long binderToken, Pair<String, String> callingPackage) {}

  }

  public final @NonNull CallingIdentity clearCallingIdentity() {
    return null;
  }

  public final void restoreCallingIdentity(@NonNull CallingIdentity identity) {}

  public final @Nullable String getReadPermission() {
    return null;
  }

  public final @Nullable String getWritePermission() {
    return null;
  }

  public final @Nullable PathPermission[] getPathPermissions() {
    return null;
  }

  public final void setAppOps(int readOp, int writeOp) {}

  public final void setTransportLoggingEnabled(boolean enabled) {}

  public abstract boolean onCreate();

  public abstract @Nullable Cursor query(@NonNull Uri uri, @Nullable String[] projection,
      @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder);

  public @Nullable Cursor query(@NonNull Uri uri, @Nullable String[] projection,
      @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder,
      @Nullable CancellationSignal cancellationSignal) {
    return null;
  }

  @Override
  public @Nullable Cursor query(@NonNull Uri uri, @Nullable String[] projection,
      @Nullable Bundle queryArgs, @Nullable CancellationSignal cancellationSignal) {
    return null;
  }

  @Override
  public abstract @Nullable String getType(@NonNull Uri uri);

  @Override
  public @Nullable Uri canonicalize(@NonNull Uri url) {
    return null;
  }

  @Override
  public @Nullable Uri uncanonicalize(@NonNull Uri url) {
    return null;
  }

  @Override
  public boolean refresh(Uri uri, @Nullable Bundle extras,
      @Nullable CancellationSignal cancellationSignal) {
    return false;
  }

  public Uri rejectInsert(Uri uri, ContentValues values) {
    return null;
  }

  public abstract @Nullable Uri insert(@NonNull Uri uri, @Nullable ContentValues values);

  @Override
  public @Nullable Uri insert(@NonNull Uri uri, @Nullable ContentValues values,
      @Nullable Bundle extras) {
    return null;
  }

  @Override
  public int bulkInsert(@NonNull Uri uri, @NonNull ContentValues[] values) {
    return 0;
  }

  public abstract int delete(@NonNull Uri uri, @Nullable String selection,
      @Nullable String[] selectionArgs);

  @Override
  public int delete(@NonNull Uri uri, @Nullable Bundle extras) {
    return 0;
  }

  public abstract int update(@NonNull Uri uri, @Nullable ContentValues values,
      @Nullable String selection, @Nullable String[] selectionArgs);

  @Override
  public int update(@NonNull Uri uri, @Nullable ContentValues values, @Nullable Bundle extras) {
    return 0;
  }

  public @Nullable ParcelFileDescriptor openFile(@NonNull Uri uri, @NonNull String mode)
      throws FileNotFoundException {
    return null;
  }

  @Override
  public @Nullable ParcelFileDescriptor openFile(@NonNull Uri uri, @NonNull String mode,
      @Nullable CancellationSignal signal) throws FileNotFoundException {
    return null;
  }

  public @Nullable AssetFileDescriptor openAssetFile(@NonNull Uri uri, @NonNull String mode)
      throws FileNotFoundException {
    return null;
  }

  @Override
  public @Nullable AssetFileDescriptor openAssetFile(@NonNull Uri uri, @NonNull String mode,
      @Nullable CancellationSignal signal) throws FileNotFoundException {
    return null;
  }

  @Override
  public @Nullable String[] getStreamTypes(@NonNull Uri uri, @NonNull String mimeTypeFilter) {
    return null;
  }

  public @Nullable AssetFileDescriptor openTypedAssetFile(@NonNull Uri uri,
      @NonNull String mimeTypeFilter, @Nullable Bundle opts) throws FileNotFoundException {
    return null;
  }

  public static int getUserIdFromAuthority(String auth, int defaultUserId) {
    return 0;
  }

  public static int getUserIdFromAuthority(String auth) {
    return 0;
  }

  public static int getUserIdFromUri(Uri uri, int defaultUserId) {
    return 0;
  }

  public static int getUserIdFromUri(Uri uri) {
    return 0;
  }

  public static String getAuthorityWithoutUserId(String auth) {
    return null;
  }

  public static Uri getUriWithoutUserId(Uri uri) {
    return null;
  }

  public static boolean uriHasUserId(Uri uri) {
    return false;
  }

  public static Uri maybeAddUserId(Uri uri, int userId) {
    return null;
  }

  public @Nullable Bundle call(@NonNull String method, @Nullable String arg,
      @Nullable Bundle extras) {
    return null;
  }

}
