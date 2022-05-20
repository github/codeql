/*
 * Copyright (C) 2007 The Guava Authors
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

package com.google.common.base;
import org.checkerframework.checker.nullness.qual.NonNull;
import org.checkerframework.checker.nullness.qual.Nullable;

public final class Preconditions {
  public static void checkArgument(boolean expression) {
  }

  public static void checkArgument(boolean expression, @Nullable Object errorMessage) {
  }

  public static void checkArgument(
      boolean expression,
      @Nullable String errorMessageTemplate,
      @Nullable Object @Nullable ... errorMessageArgs) {
  }

  public static void checkArgument(boolean b, @Nullable String errorMessageTemplate, char p1) {
  }

  public static void checkArgument(boolean b, @Nullable String errorMessageTemplate, int p1) {
  }

  public static void checkArgument(boolean b, @Nullable String errorMessageTemplate, long p1) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, char p1, char p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, char p1, int p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, char p1, long p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, char p1, @Nullable Object p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, int p1, char p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, int p1, int p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, int p1, long p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, int p1, @Nullable Object p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, long p1, char p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, long p1, int p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, long p1, long p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, long p1, @Nullable Object p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1, char p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1, int p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1, long p2) {
  }

  public static void checkArgument(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1, @Nullable Object p2) {
  }

  public static void checkArgument(
      boolean b,
      @Nullable String errorMessageTemplate,
      @Nullable Object p1,
      @Nullable Object p2,
      @Nullable Object p3) {
  }

  public static void checkArgument(
      boolean b,
      @Nullable String errorMessageTemplate,
      @Nullable Object p1,
      @Nullable Object p2,
      @Nullable Object p3,
      @Nullable Object p4) {
  }

  public static void checkState(boolean expression) {
  }

  public static void checkState(boolean expression, @Nullable Object errorMessage) {
  }

  public static void checkState(
      boolean expression,
      @Nullable String errorMessageTemplate,
      @Nullable Object @Nullable ... errorMessageArgs) {
  }

  public static void checkState(boolean b, @Nullable String errorMessageTemplate, char p1) {
  }

  public static void checkState(boolean b, @Nullable String errorMessageTemplate, int p1) {
  }

  public static void checkState(boolean b, @Nullable String errorMessageTemplate, long p1) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, char p1, char p2) {
  }

  public static void checkState(boolean b, @Nullable String errorMessageTemplate, char p1, int p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, char p1, long p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, char p1, @Nullable Object p2) {
  }

  public static void checkState(boolean b, @Nullable String errorMessageTemplate, int p1, char p2) {
  }

  public static void checkState(boolean b, @Nullable String errorMessageTemplate, int p1, int p2) {
  }

  public static void checkState(boolean b, @Nullable String errorMessageTemplate, int p1, long p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, int p1, @Nullable Object p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, long p1, char p2) {
  }

  public static void checkState(boolean b, @Nullable String errorMessageTemplate, long p1, int p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, long p1, long p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, long p1, @Nullable Object p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1, char p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1, int p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1, long p2) {
  }

  public static void checkState(
      boolean b, @Nullable String errorMessageTemplate, @Nullable Object p1, @Nullable Object p2) {
  }

  public static void checkState(
      boolean b,
      @Nullable String errorMessageTemplate,
      @Nullable Object p1,
      @Nullable Object p2,
      @Nullable Object p3) {
  }

  public static void checkState(
      boolean b,
      @Nullable String errorMessageTemplate,
      @Nullable Object p1,
      @Nullable Object p2,
      @Nullable Object p3,
      @Nullable Object p4) {
  }

  public static <T extends @NonNull Object> T checkNotNull(T reference) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T reference, @Nullable Object errorMessage) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T reference,
      @Nullable String errorMessageTemplate,
      @Nullable Object @Nullable ... errorMessageArgs) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, char p1) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, int p1) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, long p1) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, @Nullable Object p1) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, char p1, char p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, char p1, int p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, char p1, long p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, char p1, @Nullable Object p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, int p1, char p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, int p1, int p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, int p1, long p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, int p1, @Nullable Object p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, long p1, char p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, long p1, int p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, long p1, long p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, long p1, @Nullable Object p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, @Nullable Object p1, char p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, @Nullable Object p1, int p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, @Nullable Object p1, long p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj, @Nullable String errorMessageTemplate, @Nullable Object p1, @Nullable Object p2) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj,
      @Nullable String errorMessageTemplate,
      @Nullable Object p1,
      @Nullable Object p2,
      @Nullable Object p3) {
    return null;
  }

  public static <T extends @NonNull Object> T checkNotNull(
      T obj,
      @Nullable String errorMessageTemplate,
      @Nullable Object p1,
      @Nullable Object p2,
      @Nullable Object p3,
      @Nullable Object p4) {
    return null;
  }

  public static int checkElementIndex(int index, int size) {
    return 0;
  }

  public static int checkElementIndex(int index, int size, @Nullable String desc) {
    return 0;
  }

  public static int checkPositionIndex(int index, int size) {
    return 0;
  }

  public static int checkPositionIndex(int index, int size, @Nullable String desc) {
    return 0;
  }

  public static void checkPositionIndexes(int start, int end, int size) {
  }

}
