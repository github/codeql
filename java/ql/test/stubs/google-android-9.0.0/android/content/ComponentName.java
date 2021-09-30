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

import android.annotation.NonNull;
import android.annotation.Nullable;
import android.os.Parcel;
import android.os.Parcelable;
import java.io.PrintWriter;

public final class ComponentName implements Parcelable, Cloneable, Comparable<ComponentName> {
  public static @NonNull ComponentName createRelative(@NonNull String pkg, @NonNull String cls) {
    return null;
  }

  public static @NonNull ComponentName createRelative(@NonNull Context pkg, @NonNull String cls) {
    return null;
  }

  public ComponentName(@NonNull String pkg, @NonNull String cls) {}

  public ComponentName(@NonNull Context pkg, @NonNull String cls) {}

  public ComponentName(@NonNull Context pkg, @NonNull Class<?> cls) {}

  public ComponentName clone() {
    return null;
  }

  public @NonNull String getPackageName() {
    return null;
  }

  public @NonNull String getClassName() {
    return null;
  }

  public String getShortClassName() {
    return null;
  }

  public static String flattenToShortString(@Nullable ComponentName componentName) {
    return null;
  }

  public @NonNull String flattenToString() {
    return null;
  }

  public @NonNull String flattenToShortString() {
    return null;
  }

  public void appendShortString(StringBuilder sb) {}

  public static void appendShortString(StringBuilder sb, String packageName, String className) {}

  public static void printShortString(PrintWriter pw, String packageName, String className) {}

  public static @Nullable ComponentName unflattenFromString(@NonNull String str) {
    return null;
  }

  public String toShortString() {
    return null;
  }

  @Override
  public String toString() {
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

  public int compareTo(ComponentName that) {
    return 0;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel out, int flags) {}

  public static void writeToParcel(ComponentName c, Parcel out) {}

  public static ComponentName readFromParcel(Parcel in) {
    return null;
  }

  public ComponentName(Parcel in) {}

  public interface WithComponentName {
    ComponentName getComponentName();

  }
}
