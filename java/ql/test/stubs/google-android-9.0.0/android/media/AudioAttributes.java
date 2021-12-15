/*
 * Copyright (C) 2014 The Android Open Source Project
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

package android.media;

import android.annotation.NonNull;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import java.util.Set;

public final class AudioAttributes implements Parcelable {
  public final static int[] SDK_USAGES = new int[] {};

  public @interface CapturePolicy {
  }

  public int getContentType() {
    return 0;
  }

  public int getUsage() {
    return 0;
  }

  public int getSystemUsage() {
    return 0;
  }

  public int getCapturePreset() {
    return 0;
  }

  public int getFlags() {
    return 0;
  }

  public int getAllFlags() {
    return 0;
  }

  public Bundle getBundle() {
    return null;
  }

  public Set<String> getTags() {
    return null;
  }

  public boolean areHapticChannelsMuted() {
    return false;
  }

  public int getAllowedCapturePolicy() {
    return 0;
  }

  public static class Builder {
    public Builder() {}

    public Builder(AudioAttributes aa) {}

    public AudioAttributes build() {
      return null;
    }

    public Builder setUsage(@AttributeSdkUsage int usage) {
      return null;
    }

    public @NonNull Builder setSystemUsage(@AttributeSystemUsage int systemUsage) {
      return null;
    }

    public Builder setContentType(@AttributeContentType int contentType) {
      return null;
    }

    public Builder setFlags(int flags) {
      return null;
    }

    public @NonNull Builder setAllowedCapturePolicy(@CapturePolicy int capturePolicy) {
      return null;
    }

    public Builder replaceFlags(int flags) {
      return null;
    }

    public Builder addBundle(@NonNull Bundle bundle) {
      return null;
    }

    public Builder addTag(String tag) {
      return null;
    }

    public Builder setLegacyStreamType(int streamType) {
      return null;
    }

    public Builder setInternalLegacyStreamType(int streamType) {
      return null;
    }

    public Builder setCapturePreset(int preset) {
      return null;
    }

    public Builder setInternalCapturePreset(int preset) {
      return null;
    }

    public @NonNull Builder setHapticChannelsMuted(boolean muted) {
      return null;
    }

    public @NonNull Builder setPrivacySensitive(boolean privacySensitive) {
      return null;
    }

  }

  public int describeContents() {
    return 0;
  }

  @Override
  public void writeToParcel(Parcel dest, int flags) {}

  @Override
  public boolean equals(Object o) {
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

  public String usageToString() {
    return null;
  }

  public static String usageToString(int usage) {
    return null;
  }

  public String contentTypeToString() {
    return null;
  }

  public static boolean isSystemUsage(@AttributeSystemUsage int usage) {
    return false;
  }

  public int getVolumeControlStream() {
    return 0;
  }

  public static int toLegacyStreamType(@NonNull AudioAttributes aa) {
    return 0;
  }

  public static int capturePolicyToFlags(@CapturePolicy int capturePolicy, int flags) {
    return 0;
  }

  public @interface AttributeSystemUsage {
  }

  public @interface AttributeSdkUsage {
  }

  public @interface AttributeUsage {
  }

  public @interface AttributeContentType {
  }

}
