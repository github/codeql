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

package android.app;

import android.annotation.NonNull;
import android.annotation.Nullable;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.UserHandle;
import android.util.AndroidException;

public final class PendingIntent implements Parcelable {
  public @interface Flags {

  }

  public static final int FLAG_ONE_SHOT = 1 << 30;
  public static final int FLAG_NO_CREATE = 1 << 29;
  public static final int FLAG_CANCEL_CURRENT = 1 << 28;
  public static final int FLAG_UPDATE_CURRENT = 1 << 27;
  public static final int FLAG_IMMUTABLE = 1 << 26;

  public static class CanceledException extends AndroidException {
    public CanceledException() {}

    public CanceledException(String name) {}

    public CanceledException(Exception cause) {}

  }

  public interface OnFinished {
    void onSendFinished(PendingIntent pendingIntent, Intent intent, int resultCode,
        String resultData, Bundle resultExtras);

  }

  public interface OnMarshaledListener {
    void onMarshaled(PendingIntent intent, Parcel parcel, int flags);
  }

  public static void setOnMarshaledListener(OnMarshaledListener listener) {}

  public static PendingIntent getActivity(Context context, int requestCode, Intent intent,
      @Flags int flags) {
    return null;
  }

  public static PendingIntent getActivity(Context context, int requestCode, @NonNull Intent intent,
      @Flags int flags, @Nullable Bundle options) {
    return null;
  }

  public static PendingIntent getActivityAsUser(Context context, int requestCode,
      @NonNull Intent intent, int flags, Bundle options, UserHandle user) {
    return null;
  }

  public static PendingIntent getActivities(Context context, int requestCode,
      @NonNull Intent[] intents, @Flags int flags) {
    return null;
  }

  public static PendingIntent getActivities(Context context, int requestCode,
      @NonNull Intent[] intents, @Flags int flags, @Nullable Bundle options) {
    return null;
  }

  public static PendingIntent getActivitiesAsUser(Context context, int requestCode,
      @NonNull Intent[] intents, int flags, Bundle options, UserHandle user) {
    return null;
  }

  public static PendingIntent getBroadcast(Context context, int requestCode, Intent intent,
      @Flags int flags) {
    return null;
  }

  public static PendingIntent getBroadcastAsUser(Context context, int requestCode, Intent intent,
      int flags, UserHandle userHandle) {
    return null;
  }

  public static PendingIntent getService(Context context, int requestCode, @NonNull Intent intent,
      @Flags int flags) {
    return null;
  }

  public static PendingIntent getForegroundService(Context context, int requestCode,
      @NonNull Intent intent, @Flags int flags) {
    return null;
  }

  public void cancel() {}

  public void send() throws CanceledException {}

  public void send(int code) throws CanceledException {}

  public void send(Context context, int code, @Nullable Intent intent) throws CanceledException {}

  public void send(int code, @Nullable OnFinished onFinished, @Nullable Handler handler)
      throws CanceledException {}

  public void send(Context context, int code, @Nullable Intent intent,
      @Nullable OnFinished onFinished, @Nullable Handler handler) throws CanceledException {}

  public void send(Context context, int code, @Nullable Intent intent,
      @Nullable OnFinished onFinished, @Nullable Handler handler,
      @Nullable String requiredPermission) throws CanceledException {}

  public void send(Context context, int code, @Nullable Intent intent,
      @Nullable OnFinished onFinished, @Nullable Handler handler,
      @Nullable String requiredPermission, @Nullable Bundle options) throws CanceledException {}

  public int sendAndReturnResult(Context context, int code, @Nullable Intent intent,
      @Nullable OnFinished onFinished, @Nullable Handler handler,
      @Nullable String requiredPermission, @Nullable Bundle options) throws CanceledException {
    return 0;
  }

  public String getTargetPackage() {
    return null;
  }

  public String getCreatorPackage() {
    return null;
  }

  public int getCreatorUid() {
    return 0;
  }

  public void registerCancelListener(CancelListener cancelListener) {}

  public void unregisterCancelListener(CancelListener cancelListener) {}

  public UserHandle getCreatorUserHandle() {
    return null;
  }

  public boolean isTargetedToPackage() {
    return false;
  }

  public boolean isActivity() {
    return false;
  }

  public boolean isForegroundService() {
    return false;
  }

  public boolean isBroadcast() {
    return false;
  }

  public Intent getIntent() {
    return null;
  }

  public String getTag(String prefix) {
    return null;
  }

  @Override
  public boolean equals(Object otherObj) {
    return false;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  @Override
  public String toString() {
    return null;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel out, int flags) {}

  public static void writePendingIntentOrNullToParcel(@Nullable PendingIntent sender,
      @NonNull Parcel out) {}

  public static PendingIntent readPendingIntentOrNullFromParcel(@NonNull Parcel in) {
    return null;
  }

  public interface CancelListener {
    void onCancelled(PendingIntent intent);

  }
}
