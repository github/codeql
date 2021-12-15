/*
 * Copyright (C) 2018 The Android Open Source Project
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
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;

public final class Person implements Parcelable {
  public Builder toBuilder() {
    return null;
  }

  public String getUri() {
    return null;
  }

  public CharSequence getName() {
    return null;
  }

  public Icon getIcon() {
    return null;
  }

  public String getKey() {
    return null;
  }

  public boolean isBot() {
    return false;
  }

  public boolean isImportant() {
    return false;
  }

  public String resolveToLegacyUri() {
    return null;
  }

  public Uri getIconUri() {
    return null;
  }

  @Override
  public boolean equals(Object obj) {
    return false;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  public int describeContents() {
    return 0;
  }

  @Override
  public void writeToParcel(Parcel dest, int flags) {}

  public static class Builder {
    public Builder() {}

    public Person.Builder setName(@Nullable CharSequence name) {
      return null;
    }

    public Person.Builder setIcon(@Nullable Icon icon) {
      return null;
    }

    public Person.Builder setUri(@Nullable String uri) {
      return null;
    }

    public Person.Builder setKey(@Nullable String key) {
      return null;
    }

    public Person.Builder setImportant(boolean isImportant) {
      return null;
    }

    public Person.Builder setBot(boolean isBot) {
      return null;
    }

    public Person build() {
      return null;
    }

  }

}
