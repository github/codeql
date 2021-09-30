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

package android.os;

import android.annotation.NonNull;
import android.annotation.Nullable;

public class Handler {
  public interface Callback {
  }

  public Handler() {}

  public Handler(@Nullable Callback callback) {}

  public Handler(boolean async) {}

  public Handler(@Nullable Callback callback, boolean async) {}

  public static Handler getMain() {
    return null;
  }

  public static Handler mainIfNull(@Nullable Handler handler) {
    return null;
  }

  public final boolean post(@NonNull Runnable r) {
    return false;
  }

  public final boolean postAtTime(@NonNull Runnable r, long uptimeMillis) {
    return false;
  }

  public final boolean postAtTime(@NonNull Runnable r, @Nullable Object token, long uptimeMillis) {
    return false;
  }

  public final boolean postDelayed(@NonNull Runnable r, long delayMillis) {
    return false;
  }

  public final boolean postDelayed(Runnable r, int what, long delayMillis) {
    return false;
  }

  public final boolean postDelayed(@NonNull Runnable r, @Nullable Object token, long delayMillis) {
    return false;
  }

  public final boolean postAtFrontOfQueue(@NonNull Runnable r) {
    return false;
  }

  public final boolean runWithScissors(@NonNull Runnable r, long timeout) {
    return false;
  }

  public final void removeCallbacks(@NonNull Runnable r) {}

  public final void removeCallbacks(@NonNull Runnable r, @Nullable Object token) {}

  public final boolean sendEmptyMessage(int what) {
    return false;
  }

  public final boolean sendEmptyMessageDelayed(int what, long delayMillis) {
    return false;
  }

  public final boolean sendEmptyMessageAtTime(int what, long uptimeMillis) {
    return false;
  }

  public final void removeMessages(int what) {}

  public final void removeMessages(int what, @Nullable Object object) {}

  public final void removeEqualMessages(int what, @Nullable Object object) {}

  public final void removeCallbacksAndMessages(@Nullable Object token) {}

  public final void removeCallbacksAndEqualMessages(@Nullable Object token) {}

  public final boolean hasMessages(int what) {
    return false;
  }

  public final boolean hasMessagesOrCallbacks() {
    return false;
  }

  public final boolean hasMessages(int what, @Nullable Object object) {
    return false;
  }

  public final boolean hasEqualMessages(int what, @Nullable Object object) {
    return false;
  }

  public final boolean hasCallbacks(@NonNull Runnable r) {
    return false;
  }

  @Override
  public String toString() {
    return null;
  }

}
