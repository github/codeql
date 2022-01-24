/*
 * Copyright 2002-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.util;


import org.springframework.lang.Nullable;

public abstract class ObjectUtils {
  public static boolean isCheckedException(Throwable ex) {
    return false;
  }

  public static boolean isCompatibleWithThrowsClause(
      Throwable ex, @Nullable Class<?>... declaredExceptions) {
    return false;
  }

  public static boolean isArray(@Nullable Object obj) {
    return false;
  }

  public static boolean isEmpty(@Nullable Object[] array) {
    return false;
  }

  public static boolean isEmpty(@Nullable Object obj) {
    return false;
  }

  public static Object unwrapOptional(@Nullable Object obj) {
    return null;
  }

  public static boolean containsElement(@Nullable Object[] array, Object element) {
    return false;
  }

  public static boolean containsConstant(Enum<?>[] enumValues, String constant) {
    return false;
  }

  public static boolean containsConstant(
      Enum<?>[] enumValues, String constant, boolean caseSensitive) {
    return false;
  }

  public static <E extends Enum<?>> E caseInsensitiveValueOf(E[] enumValues, String constant) {
    return null;
  }

  public static <A, O extends A> A[] addObjectToArray(@Nullable A[] array, @Nullable O obj) {
    return null;
  }

  public static Object[] toObjectArray(@Nullable Object source) {
    return null;
  }

  public static boolean nullSafeEquals(@Nullable Object o1, @Nullable Object o2) {
    return false;
  }

  public static int nullSafeHashCode(@Nullable Object obj) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable Object[] array) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable boolean[] array) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable byte[] array) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable char[] array) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable double[] array) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable float[] array) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable int[] array) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable long[] array) {
    return 0;
  }

  public static int nullSafeHashCode(@Nullable short[] array) {
    return 0;
  }

  public static int hashCode(boolean bool) {
    return 0;
  }

  public static int hashCode(double dbl) {
    return 0;
  }

  public static int hashCode(float flt) {
    return 0;
  }

  public static int hashCode(long lng) {
    return 0;
  }

  public static String identityToString(@Nullable Object obj) {
    return null;
  }

  public static String getIdentityHexString(Object obj) {
    return null;
  }

  public static String getDisplayString(@Nullable Object obj) {
    return null;
  }

  public static String nullSafeClassName(@Nullable Object obj) {
    return null;
  }

  public static String nullSafeToString(@Nullable Object obj) {
    return null;
  }

  public static String nullSafeToString(@Nullable Object[] array) {
    return null;
  }

  public static String nullSafeToString(@Nullable boolean[] array) {
    return null;
  }

  public static String nullSafeToString(@Nullable byte[] array) {
    return null;
  }

  public static String nullSafeToString(@Nullable char[] array) {
    return null;
  }

  public static String nullSafeToString(@Nullable double[] array) {
    return null;
  }

  public static String nullSafeToString(@Nullable float[] array) {
    return null;
  }

  public static String nullSafeToString(@Nullable int[] array) {
    return null;
  }

  public static String nullSafeToString(@Nullable long[] array) {
    return null;
  }

  public static String nullSafeToString(@Nullable short[] array) {
    return null;
  }
}
