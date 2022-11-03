/*
 * Copyright (C) 2008 The Android Open Source Project
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

package android.os;

public class PatternMatcher implements Parcelable {
  public PatternMatcher(String pattern, int type) {}

  public final String getPath() {
    return null;
  }

  public final int getType() {
    return 0;
  }

  public boolean match(String str) {
    return false;
  }

  public String toString() {
    return null;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel dest, int flags) {}

  public PatternMatcher(Parcel src) {}

}
