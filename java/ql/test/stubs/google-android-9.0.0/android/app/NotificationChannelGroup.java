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
package android.app;

import android.os.Parcel;
import android.os.Parcelable;
import java.util.List;

public final class NotificationChannelGroup implements Parcelable {
  public NotificationChannelGroup(String id, CharSequence name) {}

  @Override
  public void writeToParcel(Parcel dest, int flags) {}

  public String getId() {
    return null;
  }

  public CharSequence getName() {
    return null;
  }

  public String getDescription() {
    return null;
  }

  public List<NotificationChannel> getChannels() {
    return null;
  }

  public boolean isBlocked() {
    return false;
  }

  public void setDescription(String description) {}

  public void setBlocked(boolean blocked) {}

  public void addChannel(NotificationChannel channel) {}

  public void setChannels(List<NotificationChannel> channels) {}

  public void lockFields(int field) {}

  public void unlockFields(int field) {}

  public int getUserLockedFields() {
    return 0;
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

  @Override
  public NotificationChannelGroup clone() {
    return null;
  }

  @Override
  public String toString() {
    return null;
  }

}
