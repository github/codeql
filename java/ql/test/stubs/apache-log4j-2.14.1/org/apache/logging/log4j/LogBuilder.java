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

import org.apache.logging.log4j.message.Message;
import org.apache.logging.log4j.util.Supplier;

public interface LogBuilder {
  public static final LogBuilder NOOP = new LogBuilder() {};

  default LogBuilder withMarker(Marker marker) {
    return null;
  }

  default LogBuilder withThrowable(Throwable throwable) {
    return null;
  }

  default LogBuilder withLocation() {
    return null;
  }

  default LogBuilder withLocation(StackTraceElement location) {
    return null;
  }

  default void log(CharSequence message) {}

  default void log(String message) {}

  default void log(String message, Object... params) {}

  default void log(String message, Supplier<?>... params) {}

  default void log(Message message) {}

  default void log(Supplier<Message> messageSupplier) {}

  default void log(Object message) {}

  default void log(String message, Object p0) {}

  default void log(String message, Object p0, Object p1) {}

  default void log(String message, Object p0, Object p1, Object p2) {}

  default void log(String message, Object p0, Object p1, Object p2, Object p3) {}

  default void log(String message, Object p0, Object p1, Object p2, Object p3, Object p4) {}

  default void log(String message, Object p0, Object p1, Object p2, Object p3, Object p4,
      Object p5) {}

  default void log(String message, Object p0, Object p1, Object p2, Object p3, Object p4, Object p5,
      Object p6) {}

  default void log(String message, Object p0, Object p1, Object p2, Object p3, Object p4, Object p5,
      Object p6, Object p7) {}

  default void log(String message, Object p0, Object p1, Object p2, Object p3, Object p4, Object p5,
      Object p6, Object p7, Object p8) {}

  default void log(String message, Object p0, Object p1, Object p2, Object p3, Object p4, Object p5,
      Object p6, Object p7, Object p8, Object p9) {}

  default void log() {}

}
