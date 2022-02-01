/**
 * Copyright (c) 2004-2021 QOS.ch All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 * associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

package org.slf4j;

import org.slf4j.event.Level;
import org.slf4j.spi.LoggingEventBuilder;

public interface Logger {
  public String getName();

  default public LoggingEventBuilder makeLoggingEventBuilder(Level level) {
    return null;
  }

  default public boolean isEnabledForLevel(Level level) {
    return false;
  }

  public boolean isTraceEnabled();

  public void trace(String msg);

  public void trace(String format, Object arg);

  public void trace(String format, Object arg1, Object arg2);

  public void trace(String format, Object... arguments);

  public void trace(String msg, Throwable t);

  public boolean isTraceEnabled(Marker marker);

  default public LoggingEventBuilder atTrace() {
    return null;
  }

  public void trace(Marker marker, String msg);

  public void trace(Marker marker, String format, Object arg);

  public void trace(Marker marker, String format, Object arg1, Object arg2);

  public void trace(Marker marker, String format, Object... argArray);

  public void trace(Marker marker, String msg, Throwable t);

  public boolean isDebugEnabled();

  public void debug(String msg);

  public void debug(String format, Object arg);

  public void debug(String format, Object arg1, Object arg2);

  public void debug(String format, Object... arguments);

  public void debug(String msg, Throwable t);

  public boolean isDebugEnabled(Marker marker);

  public void debug(Marker marker, String msg);

  public void debug(Marker marker, String format, Object arg);

  public void debug(Marker marker, String format, Object arg1, Object arg2);

  public void debug(Marker marker, String format, Object... arguments);

  public void debug(Marker marker, String msg, Throwable t);

  default public LoggingEventBuilder atDebug() {
    return null;
  }

  public boolean isInfoEnabled();

  public void info(String msg);

  public void info(String format, Object arg);

  public void info(String format, Object arg1, Object arg2);

  public void info(String format, Object... arguments);

  public void info(String msg, Throwable t);

  public boolean isInfoEnabled(Marker marker);

  public void info(Marker marker, String msg);

  public void info(Marker marker, String format, Object arg);

  public void info(Marker marker, String format, Object arg1, Object arg2);

  public void info(Marker marker, String format, Object... arguments);

  public void info(Marker marker, String msg, Throwable t);

  default public LoggingEventBuilder atInfo() {
    return null;
  }

  public boolean isWarnEnabled();

  public void warn(String msg);

  public void warn(String format, Object arg);

  public void warn(String format, Object... arguments);

  public void warn(String format, Object arg1, Object arg2);

  public void warn(String msg, Throwable t);

  public boolean isWarnEnabled(Marker marker);

  public void warn(Marker marker, String msg);

  public void warn(Marker marker, String format, Object arg);

  public void warn(Marker marker, String format, Object arg1, Object arg2);

  public void warn(Marker marker, String format, Object... arguments);

  public void warn(Marker marker, String msg, Throwable t);

  default public LoggingEventBuilder atWarn() {
    return null;
  }

  public boolean isErrorEnabled();

  public void error(String msg);

  public void error(String format, Object arg);

  public void error(String format, Object arg1, Object arg2);

  public void error(String format, Object... arguments);

  public void error(String msg, Throwable t);

  public boolean isErrorEnabled(Marker marker);

  public void error(Marker marker, String msg);

  public void error(Marker marker, String format, Object arg);

  public void error(Marker marker, String format, Object arg1, Object arg2);

  public void error(Marker marker, String format, Object... arguments);

  public void error(Marker marker, String msg, Throwable t);

  default public LoggingEventBuilder atError() {
    return null;
  }

}
