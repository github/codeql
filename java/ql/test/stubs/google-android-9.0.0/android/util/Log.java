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

package android.util;

import android.annotation.Nullable;

public final class Log {
  public @interface Level {
  }

  public static class TerribleFailure extends Exception {
  }
  public interface TerribleFailureHandler {
    void onTerribleFailure(String tag, TerribleFailure what, boolean system);

  }

  public static int v(@Nullable String tag, String msg) {
    return 0;
  }

  public static int v(@Nullable String tag, @Nullable String msg, @Nullable Throwable tr) {
    return 0;
  }

  public static int d(@Nullable String tag, String msg) {
    return 0;
  }

  public static int d(@Nullable String tag, @Nullable String msg, @Nullable Throwable tr) {
    return 0;
  }

  public static int i(@Nullable String tag, String msg) {
    return 0;
  }

  public static int i(@Nullable String tag, @Nullable String msg, @Nullable Throwable tr) {
    return 0;
  }

  public static int w(@Nullable String tag, String msg) {
    return 0;
  }

  public static int w(@Nullable String tag, @Nullable String msg, @Nullable Throwable tr) {
    return 0;
  }

  public static native boolean isLoggable(@Nullable String tag, @Level int level);

  public static int w(@Nullable String tag, @Nullable Throwable tr) {
    return 0;
  }

  public static int e(@Nullable String tag, String msg) {
    return 0;
  }

  public static int e(@Nullable String tag, @Nullable String msg, @Nullable Throwable tr) {
    return 0;
  }

  public static int wtf(@Nullable String tag, @Nullable String msg) {
    return 0;
  }

  public static int wtfStack(@Nullable String tag, @Nullable String msg) {
    return 0;
  }

  public static int wtf(@Nullable String tag, Throwable tr) {
    return 0;
  }

  public static int wtf(@Nullable String tag, @Nullable String msg, @Nullable Throwable tr) {
    return 0;
  }

  public static TerribleFailureHandler setWtfHandler(TerribleFailureHandler handler) {
    return null;
  }

  public static String getStackTraceString(@Nullable Throwable tr) {
    return null;
  }

  public static int println(@Level int priority, @Nullable String tag, String msg) {
    return 0;
  }

  public static native int println_native(int bufID, int priority, String tag, String msg);

  public static int logToRadioBuffer(@Level int priority, @Nullable String tag,
      @Nullable String message) {
    return 0;
  }

  public static int printlns(int bufID, int priority, @Nullable String tag, String msg,
      @Nullable Throwable tr) {
    return 0;
  }

}
