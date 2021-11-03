/*
 * Copyright (C) 2012 The Flogger Authors.
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

package com.google.common.flogger;

import java.util.concurrent.TimeUnit;

// NOTE: new methods to this interface should be coordinated with google-java-format
public interface LoggingApi<API extends LoggingApi<API>> {
  API withCause(Throwable cause);

  API every(int n);

  API atMostEvery(int n, TimeUnit unit);

  API per(Enum<?> key);

  API withInjectedLogSite(String internalClassName, String methodName, int encodedLineNumber,
      String sourceFileName);

  boolean isEnabled();

  void logVarargs(String message, Object[] varargs);

  void log();

  void log(String msg);

  void log(String msg, Object p1);

  void log(String msg, Object p1, Object p2);

  void log(String msg, Object p1, Object p2, Object p3);

  void log(String msg, Object p1, Object p2, Object p3, Object p4);

  void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5);

  void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6);

  void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7);

  void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7,
      Object p8);

  void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7,
      Object p8, Object p9);

  void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7,
      Object p8, Object p9, Object p10);

  void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7,
      Object p8, Object p9, Object p10, Object... rest);

  void log(String msg, char p1);

  void log(String msg, byte p1);

  void log(String msg, short p1);

  void log(String msg, int p1);

  void log(String msg, long p1);

  void log(String msg, Object p1, boolean p2);

  void log(String msg, Object p1, char p2);

  void log(String msg, Object p1, byte p2);

  void log(String msg, Object p1, short p2);

  void log(String msg, Object p1, int p2);

  void log(String msg, Object p1, long p2);

  void log(String msg, Object p1, float p2);

  void log(String msg, Object p1, double p2);

  void log(String msg, boolean p1, Object p2);

  void log(String msg, char p1, Object p2);

  void log(String msg, byte p1, Object p2);

  void log(String msg, short p1, Object p2);

  void log(String msg, int p1, Object p2);

  void log(String msg, long p1, Object p2);

  void log(String msg, float p1, Object p2);

  void log(String msg, double p1, Object p2);

  void log(String msg, boolean p1, boolean p2);

  void log(String msg, char p1, boolean p2);

  void log(String msg, byte p1, boolean p2);

  void log(String msg, short p1, boolean p2);

  void log(String msg, int p1, boolean p2);

  void log(String msg, long p1, boolean p2);

  void log(String msg, float p1, boolean p2);

  void log(String msg, double p1, boolean p2);

  void log(String msg, boolean p1, char p2);

  void log(String msg, char p1, char p2);

  void log(String msg, byte p1, char p2);

  void log(String msg, short p1, char p2);

  void log(String msg, int p1, char p2);

  void log(String msg, long p1, char p2);

  void log(String msg, float p1, char p2);

  void log(String msg, double p1, char p2);

  void log(String msg, boolean p1, byte p2);

  void log(String msg, char p1, byte p2);

  void log(String msg, byte p1, byte p2);

  void log(String msg, short p1, byte p2);

  void log(String msg, int p1, byte p2);

  void log(String msg, long p1, byte p2);

  void log(String msg, float p1, byte p2);

  void log(String msg, double p1, byte p2);

  void log(String msg, boolean p1, short p2);

  void log(String msg, char p1, short p2);

  void log(String msg, byte p1, short p2);

  void log(String msg, short p1, short p2);

  void log(String msg, int p1, short p2);

  void log(String msg, long p1, short p2);

  void log(String msg, float p1, short p2);

  void log(String msg, double p1, short p2);

  void log(String msg, boolean p1, int p2);

  void log(String msg, char p1, int p2);

  void log(String msg, byte p1, int p2);

  void log(String msg, short p1, int p2);

  void log(String msg, int p1, int p2);

  void log(String msg, long p1, int p2);

  void log(String msg, float p1, int p2);

  void log(String msg, double p1, int p2);

  void log(String msg, boolean p1, long p2);

  void log(String msg, char p1, long p2);

  void log(String msg, byte p1, long p2);

  void log(String msg, short p1, long p2);

  void log(String msg, int p1, long p2);

  void log(String msg, long p1, long p2);

  void log(String msg, float p1, long p2);

  void log(String msg, double p1, long p2);

  void log(String msg, boolean p1, float p2);

  void log(String msg, char p1, float p2);

  void log(String msg, byte p1, float p2);

  void log(String msg, short p1, float p2);

  void log(String msg, int p1, float p2);

  void log(String msg, long p1, float p2);

  void log(String msg, float p1, float p2);

  void log(String msg, double p1, float p2);

  void log(String msg, boolean p1, double p2);

  void log(String msg, char p1, double p2);

  void log(String msg, byte p1, double p2);

  void log(String msg, short p1, double p2);

  void log(String msg, int p1, double p2);

  void log(String msg, long p1, double p2);

  void log(String msg, float p1, double p2);

  void log(String msg, double p1, double p2);

  public static class NoOp<API extends LoggingApi<API>> implements LoggingApi<API> {

    @Override
    public API withInjectedLogSite(String internalClassName, String methodName,
        int encodedLineNumber, String sourceFileName) {
      return null;
    }

    @Override
    public final boolean isEnabled() {
      return false;
    }

    @Override
    public API per(Enum<?> key) {
      return null;
    }

    @Override
    public final API withCause(Throwable cause) {
      return null;
    }

    @Override
    public final API every(int n) {
      return null;
    }

    @Override
    public final API atMostEvery(int n, TimeUnit unit) {
      return null;
    }

    @Override
    public final void logVarargs(String msg, Object[] params) {}

    @Override
    public final void log() {}

    @Override
    public final void log(String msg) {}

    @Override
    public final void log(String msg, Object p1) {}

    @Override
    public final void log(String msg, Object p1, Object p2) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3, Object p4) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5,
        Object p6) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5,
        Object p6, Object p7) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5,
        Object p6, Object p7, Object p8) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5,
        Object p6, Object p7, Object p8, Object p9) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5,
        Object p6, Object p7, Object p8, Object p9, Object p10) {}

    @Override
    public final void log(String msg, Object p1, Object p2, Object p3, Object p4, Object p5,
        Object p6, Object p7, Object p8, Object p9, Object p10, Object... rest) {}

    @Override
    public final void log(String msg, char p1) {}

    @Override
    public final void log(String msg, byte p1) {}

    @Override
    public final void log(String msg, short p1) {}

    @Override
    public final void log(String msg, int p1) {}

    @Override
    public final void log(String msg, long p1) {}

    @Override
    public final void log(String msg, Object p1, boolean p2) {}

    @Override
    public final void log(String msg, Object p1, char p2) {}

    @Override
    public final void log(String msg, Object p1, byte p2) {}

    @Override
    public final void log(String msg, Object p1, short p2) {}

    @Override
    public final void log(String msg, Object p1, int p2) {}

    @Override
    public final void log(String msg, Object p1, long p2) {}

    @Override
    public final void log(String msg, Object p1, float p2) {}

    @Override
    public final void log(String msg, Object p1, double p2) {}

    @Override
    public final void log(String msg, boolean p1, Object p2) {}

    @Override
    public final void log(String msg, char p1, Object p2) {}

    @Override
    public final void log(String msg, byte p1, Object p2) {}

    @Override
    public final void log(String msg, short p1, Object p2) {}

    @Override
    public final void log(String msg, int p1, Object p2) {}

    @Override
    public final void log(String msg, long p1, Object p2) {}

    @Override
    public final void log(String msg, float p1, Object p2) {}

    @Override
    public final void log(String msg, double p1, Object p2) {}

    @Override
    public final void log(String msg, boolean p1, boolean p2) {}

    @Override
    public final void log(String msg, char p1, boolean p2) {}

    @Override
    public final void log(String msg, byte p1, boolean p2) {}

    @Override
    public final void log(String msg, short p1, boolean p2) {}

    @Override
    public final void log(String msg, int p1, boolean p2) {}

    @Override
    public final void log(String msg, long p1, boolean p2) {}

    @Override
    public final void log(String msg, float p1, boolean p2) {}

    @Override
    public final void log(String msg, double p1, boolean p2) {}

    @Override
    public final void log(String msg, boolean p1, char p2) {}

    @Override
    public final void log(String msg, char p1, char p2) {}

    @Override
    public final void log(String msg, byte p1, char p2) {}

    @Override
    public final void log(String msg, short p1, char p2) {}

    @Override
    public final void log(String msg, int p1, char p2) {}

    @Override
    public final void log(String msg, long p1, char p2) {}

    @Override
    public final void log(String msg, float p1, char p2) {}

    @Override
    public final void log(String msg, double p1, char p2) {}

    @Override
    public final void log(String msg, boolean p1, byte p2) {}

    @Override
    public final void log(String msg, char p1, byte p2) {}

    @Override
    public final void log(String msg, byte p1, byte p2) {}

    @Override
    public final void log(String msg, short p1, byte p2) {}

    @Override
    public final void log(String msg, int p1, byte p2) {}

    @Override
    public final void log(String msg, long p1, byte p2) {}

    @Override
    public final void log(String msg, float p1, byte p2) {}

    @Override
    public final void log(String msg, double p1, byte p2) {}

    @Override
    public final void log(String msg, boolean p1, short p2) {}

    @Override
    public final void log(String msg, char p1, short p2) {}

    @Override
    public final void log(String msg, byte p1, short p2) {}

    @Override
    public final void log(String msg, short p1, short p2) {}

    @Override
    public final void log(String msg, int p1, short p2) {}

    @Override
    public final void log(String msg, long p1, short p2) {}

    @Override
    public final void log(String msg, float p1, short p2) {}

    @Override
    public final void log(String msg, double p1, short p2) {}

    @Override
    public final void log(String msg, boolean p1, int p2) {}

    @Override
    public final void log(String msg, char p1, int p2) {}

    @Override
    public final void log(String msg, byte p1, int p2) {}

    @Override
    public final void log(String msg, short p1, int p2) {}

    @Override
    public final void log(String msg, int p1, int p2) {}

    @Override
    public final void log(String msg, long p1, int p2) {}

    @Override
    public final void log(String msg, float p1, int p2) {}

    @Override
    public final void log(String msg, double p1, int p2) {}

    @Override
    public final void log(String msg, boolean p1, long p2) {}

    @Override
    public final void log(String msg, char p1, long p2) {}

    @Override
    public final void log(String msg, byte p1, long p2) {}

    @Override
    public final void log(String msg, short p1, long p2) {}

    @Override
    public final void log(String msg, int p1, long p2) {}

    @Override
    public final void log(String msg, long p1, long p2) {}

    @Override
    public final void log(String msg, float p1, long p2) {}

    @Override
    public final void log(String msg, double p1, long p2) {}

    @Override
    public final void log(String msg, boolean p1, float p2) {}

    @Override
    public final void log(String msg, char p1, float p2) {}

    @Override
    public final void log(String msg, byte p1, float p2) {}

    @Override
    public final void log(String msg, short p1, float p2) {}

    @Override
    public final void log(String msg, int p1, float p2) {}

    @Override
    public final void log(String msg, long p1, float p2) {}

    @Override
    public final void log(String msg, float p1, float p2) {}

    @Override
    public final void log(String msg, double p1, float p2) {}

    @Override
    public final void log(String msg, boolean p1, double p2) {}

    @Override
    public final void log(String msg, char p1, double p2) {}

    @Override
    public final void log(String msg, byte p1, double p2) {}

    @Override
    public final void log(String msg, short p1, double p2) {}

    @Override
    public final void log(String msg, int p1, double p2) {}

    @Override
    public final void log(String msg, long p1, double p2) {}

    @Override
    public final void log(String msg, float p1, double p2) {}

    @Override
    public final void log(String msg, double p1, double p2) {}

  }
}
