/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.commons.lang3;

import java.io.IOException;
import java.io.Serializable;
import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.time.Duration;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.TreeSet;
import java.util.function.Supplier;

import org.apache.commons.lang3.text.StrBuilder;

@SuppressWarnings("deprecation") // deprecated class StrBuilder is imported
// because it is part of the signature of deprecated methods
public class ObjectUtils {
    public static class Null implements Serializable {
    }
    public static final Null NULL = new Null();

    public static boolean allNotNull(final Object... values) {
      return false;
    }

    public static boolean allNull(final Object... values) {
      return false;
    }

    public static boolean anyNotNull(final Object... values) {
      return false;
    }

    public static boolean anyNull(final Object... values) {
      return false;
    }

    public static <T> T clone(final T obj) {
      return null;
    }

    public static <T> T cloneIfPossible(final T obj) {
      return null;
    }

    public static <T extends Comparable<? super T>> int compare(final T c1, final T c2) {
      return 0;
    }

    public static <T extends Comparable<? super T>> int compare(final T c1, final T c2, final boolean nullGreater) {
      return 0;
    }

    public static boolean CONST(final boolean v) {
      return false;
    }

    public static byte CONST(final byte v) {
      return 0;
    }

    public static char CONST(final char v) {
      return '\0';
    }

    public static double CONST(final double v) {
      return 0;
    }

    public static float CONST(final float v) {
      return 0;
    }

    public static int CONST(final int v) {
      return 0;
    }

    public static long CONST(final long v) {
      return 0;
    }

    public static short CONST(final short v) {
      return 0;
    }

    public static <T> T CONST(final T v) {
      return null;
    }

    public static byte CONST_BYTE(final int v) {
      return 0;
    }

    public static short CONST_SHORT(final int v) {
      return 0;
    }

    public static <T> T defaultIfNull(final T object, final T defaultValue) {
      return null;
    }

    public static boolean equals(final Object object1, final Object object2) {
      return false;
    }

    public static <T> T firstNonNull(final T... values) {
      return null;
    }

    public static <T> T getFirstNonNull(final Supplier<T>... suppliers) {
      return null;
    }

    public static <T> T getIfNull(final T object, final Supplier<T> defaultSupplier) {
      return null;
    }

    public static int hashCode(final Object obj) {
      return 0;
    }

    public static int hashCodeMulti(final Object... objects) {
      return 0;
    }

    public static void identityToString(final Appendable appendable, final Object object) throws IOException {
    }

    public static String identityToString(final Object object) {
      return null;
    }

    public static void identityToString(final StrBuilder builder, final Object object) {
    }

    public static void identityToString(final StringBuffer buffer, final Object object) {
    }

    public static void identityToString(final StringBuilder builder, final Object object) {
    }

    public static boolean isEmpty(final Object object) {
      return false;
    }

    public static boolean isNotEmpty(final Object object) {
      return false;
    }

    public static <T extends Comparable<? super T>> T max(final T... values) {
      return null;
    }

    public static <T> T median(final Comparator<T> comparator, final T... items) {
      return null;
    }

    public static <T extends Comparable<? super T>> T median(final T... items) {
      return null;
    }

    public static <T extends Comparable<? super T>> T min(final T... values) {
      return null;
    }

    public static <T> T mode(final T... items) {
      return null;
    }

    public static boolean notEqual(final Object object1, final Object object2) {
      return false;
    }

    public static <T> T requireNonEmpty(final T obj) {
      return null;
    }

    public static <T> T requireNonEmpty(final T obj, final String message) {
      return null;
    }

    public static String toString(final Object obj) {
      return null;
    }

    public static String toString(final Object obj, final String nullStr) {
      return null;
    }

    public static String toString(final Object obj, final Supplier<String> supplier) {
      return null;
    }

    public static void wait(final Object obj, final Duration duration) throws InterruptedException {
    }

    public ObjectUtils() {
    }

}
