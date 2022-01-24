/*
 * ====================================================================
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */

package org.apache.http.util;

import java.util.Collection;

public class Args {
    public static void check(final boolean expression, final String message) {
    }

    public static void check(final boolean expression, final String message, final Object... args) {
    }

    public static void check(final boolean expression, final String message, final Object arg) {
    }

    public static <T> T notNull(final T argument, final String name) {
      return null;
    }

    public static <T extends CharSequence> T notEmpty(final T argument, final String name) {
      return null;
    }

    public static <T extends CharSequence> T notBlank(final T argument, final String name) {
      return null;
    }

    public static <T extends CharSequence> T containsNoBlanks(final T argument, final String name) {
      return null;
    }

    public static <E, T extends Collection<E>> T notEmpty(final T argument, final String name) {
      return null;
    }

    public static int positive(final int n, final String name) {
      return 0;
    }

    public static long positive(final long n, final String name) {
      return 0;
    }

    public static int notNegative(final int n, final String name) {
      return 0;
    }

    public static long notNegative(final long n, final String name) {
      return 0;
    }

}
