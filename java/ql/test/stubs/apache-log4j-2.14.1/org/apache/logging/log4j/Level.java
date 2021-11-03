/*
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for additional information regarding
 * copyright ownership. The ASF licenses this file to You under the Apache license, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a
 * copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the license for the specific language governing permissions and limitations under
 * the license.
 */
package org.apache.logging.log4j;

import java.io.Serializable;

public final class Level implements Comparable<Level>, Serializable {
  public int intLevel() {
    return 0;
  }

  public boolean isInRange(final Level minLevel, final Level maxLevel) {
    return false;
  }

  public boolean isLessSpecificThan(final Level level) {
    return false;
  }

  public boolean isMoreSpecificThan(final Level level) {
    return false;
  }

  public Level clone() throws CloneNotSupportedException {
    return null;
  }

  @Override
  public int compareTo(final Level other) {
    return 0;
  }

  @Override
  public boolean equals(final Object other) {
    return false;
  }

  public Class<Level> getDeclaringClass() {
    return null;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  public String name() {
    return null;
  }

  @Override
  public String toString() {
    return null;
  }

  public static Level forName(final String name, final int intValue) {
    return null;
  }

  public static Level getLevel(final String name) {
    return null;
  }

  public static Level toLevel(final String sArg) {
    return null;
  }

  public static Level toLevel(final String name, final Level defaultLevel) {
    return null;
  }

  public static Level[] values() {
    return null;
  }

  public static Level valueOf(final String name) {
    return null;
  }

  public static <T extends Enum<T>> T valueOf(final Class<T> enumType, final String name) {
    return null;
  }

}
