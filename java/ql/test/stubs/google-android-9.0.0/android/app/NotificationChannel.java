/*
 * Copyright (C) 2016 The Android Open Source Project
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
import android.app.NotificationManager.Importance;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import java.io.PrintWriter;

public final class NotificationChannel implements Parcelable {
  public static final int[] LOCKABLE_FIELDS = new int[] {};

  public NotificationChannel(String id, CharSequence name, @Importance int importance) {}

  @Override
  public void writeToParcel(Parcel dest, int flags) {}

  public void lockFields(int field) {}

  public void unlockFields(int field) {}

  public void setFgServiceShown(boolean shown) {}

  public void setDeleted(boolean deleted) {}

  public void setImportantConversation(boolean importantConvo) {}

  public void setBlockable(boolean blockable) {}

  public void setName(CharSequence name) {}

  public void setDescription(String description) {}

  public void setId(String id) {}

  public void setGroup(String groupId) {}

  public void setShowBadge(boolean showBadge) {}

  public void enableLights(boolean lights) {}

  public void setLightColor(int argb) {}

  public void enableVibration(boolean vibration) {}

  public void setVibrationPattern(long[] vibrationPattern) {}

  public void setImportance(@Importance int importance) {}

  public void setBypassDnd(boolean bypassDnd) {}

  public void setLockscreenVisibility(int lockscreenVisibility) {}

  public void setAllowBubbles(boolean allowBubbles) {}

  public void setAllowBubbles(int allowed) {}

  public void setConversationId(@NonNull String parentChannelId, @NonNull String conversationId) {}

  public String getId() {
    return null;
  }

  public CharSequence getName() {
    return null;
  }

  public String getDescription() {
    return null;
  }

  public int getImportance() {
    return 0;
  }

  public boolean canBypassDnd() {
    return false;
  }

  public boolean isImportantConversation() {
    return false;
  }

  public Uri getSound() {
    return null;
  }

  public boolean shouldShowLights() {
    return false;
  }

  public int getLightColor() {
    return 0;
  }

  public boolean shouldVibrate() {
    return false;
  }

  public long[] getVibrationPattern() {
    return null;
  }

  public int getLockscreenVisibility() {
    return 0;
  }

  public boolean canShowBadge() {
    return false;
  }

  public String getGroup() {
    return null;
  }

  public boolean canBubble() {
    return false;
  }

  public int getAllowBubbles() {
    return 0;
  }

  public @Nullable String getParentChannelId() {
    return null;
  }

  public @Nullable String getConversationId() {
    return null;
  }

  public boolean isDeleted() {
    return false;
  }

  public int getUserLockedFields() {
    return 0;
  }

  public boolean isFgServiceShown() {
    return false;
  }

  public boolean isBlockable() {
    return false;
  }

  public void setImportanceLockedByOEM(boolean locked) {}

  public void setImportanceLockedByCriticalDeviceFunction(boolean locked) {}

  public boolean isImportanceLockedByOEM() {
    return false;
  }

  public boolean isImportanceLockedByCriticalDeviceFunction() {
    return false;
  }

  public int getOriginalImportance() {
    return 0;
  }

  public void setOriginalImportance(int importance) {}

  public void setDemoted(boolean demoted) {}

  public boolean isDemoted() {
    return false;
  }

  public boolean hasUserSetImportance() {
    return false;
  }

  public boolean hasUserSetSound() {
    return false;
  }

  public int describeContents() {
    return 0;
  }

  @Override
  public boolean equals(Object o) {
    return false;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  public void dump(PrintWriter pw, String prefix, boolean redacted) {}

  @Override
  public String toString() {
    return null;
  }

}
