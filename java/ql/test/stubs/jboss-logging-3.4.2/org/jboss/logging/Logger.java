/*
 * JBoss, Home of Professional Open Source.
 *
 * Copyright 2011 Red Hat, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.jboss.logging;
import java.io.Serializable;
import java.util.Locale;

public abstract class Logger implements Serializable, BasicLogger {
    public enum Level {
    }
    public String getName() {
      return null;
    }

    public boolean isTraceEnabled() {
      return false;
    }

    public void trace(Object message) {
    }

    public void trace(Object message, Throwable t) {
    }

    public void trace(String loggerFqcn, Object message, Throwable t) {
    }

    public void trace(Object message, Object[] params) {
    }

    public void trace(Object message, Object[] params, Throwable t) {
    }

    public void trace(String loggerFqcn, Object message, Object[] params, Throwable t) {
    }

    public void tracev(String format, Object... params) {
    }

    public void tracev(String format, Object param1) {
    }

    public void tracev(String format, Object param1, Object param2) {
    }

    public void tracev(String format, Object param1, Object param2, Object param3) {
    }

    public void tracev(Throwable t, String format, Object... params) {
    }

    public void tracev(Throwable t, String format, Object param1) {
    }

    public void tracev(Throwable t, String format, Object param1, Object param2) {
    }

    public void tracev(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void tracef(String format, Object... params) {
    }

    public void tracef(String format, Object param1) {
    }

    public void tracef(String format, Object param1, Object param2) {
    }

    public void tracef(String format, Object param1, Object param2, Object param3) {
    }

    public void tracef(Throwable t, String format, Object... params) {
    }

    public void tracef(Throwable t, String format, Object param1) {
    }

    public void tracef(Throwable t, String format, Object param1, Object param2) {
    }

    public void tracef(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void tracef(final String format, final int arg) {
    }

    public void tracef(final String format, final int arg1, final int arg2) {
    }

    public void tracef(final String format, final int arg1, final Object arg2) {
    }

    public void tracef(final String format, final int arg1, final int arg2, final int arg3) {
    }

    public void tracef(final String format, final int arg1, final int arg2, final Object arg3) {
    }

    public void tracef(final String format, final int arg1, final Object arg2, final Object arg3) {
    }

    public void tracef(final Throwable t, final String format, final int arg) {
    }

    public void tracef(final Throwable t, final String format, final int arg1, final int arg2) {
    }

    public void tracef(final Throwable t, final String format, final int arg1, final Object arg2) {
    }

    public void tracef(final Throwable t, final String format, final int arg1, final int arg2, final int arg3) {
    }

    public void tracef(final Throwable t, final String format, final int arg1, final int arg2, final Object arg3) {
    }

    public void tracef(final Throwable t, final String format, final int arg1, final Object arg2, final Object arg3) {
    }

    public void tracef(final String format, final long arg) {
    }

    public void tracef(final String format, final long arg1, final long arg2) {
    }

    public void tracef(final String format, final long arg1, final Object arg2) {
    }

    public void tracef(final String format, final long arg1, final long arg2, final long arg3) {
    }

    public void tracef(final String format, final long arg1, final long arg2, final Object arg3) {
    }

    public void tracef(final String format, final long arg1, final Object arg2, final Object arg3) {
    }

    public void tracef(final Throwable t, final String format, final long arg) {
    }

    public void tracef(final Throwable t, final String format, final long arg1, final long arg2) {
    }

    public void tracef(final Throwable t, final String format, final long arg1, final Object arg2) {
    }

    public void tracef(final Throwable t, final String format, final long arg1, final long arg2, final long arg3) {
    }

    public void tracef(final Throwable t, final String format, final long arg1, final long arg2, final Object arg3) {
    }

    public void tracef(final Throwable t, final String format, final long arg1, final Object arg2, final Object arg3) {
    }

    public boolean isDebugEnabled() {
      return false;
    }

    public void debug(Object message) {
    }

    public void debug(Object message, Throwable t) {
    }

    public void debug(String loggerFqcn, Object message, Throwable t) {
    }

    public void debug(Object message, Object[] params) {
    }

    public void debug(Object message, Object[] params, Throwable t) {
    }

    public void debug(String loggerFqcn, Object message, Object[] params, Throwable t) {
    }

    public void debugv(String format, Object... params) {
    }

    public void debugv(String format, Object param1) {
    }

    public void debugv(String format, Object param1, Object param2) {
    }

    public void debugv(String format, Object param1, Object param2, Object param3) {
    }

    public void debugv(Throwable t, String format, Object... params) {
    }

    public void debugv(Throwable t, String format, Object param1) {
    }

    public void debugv(Throwable t, String format, Object param1, Object param2) {
    }

    public void debugv(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void debugf(String format, Object... params) {
    }

    public void debugf(String format, Object param1) {
    }

    public void debugf(String format, Object param1, Object param2) {
    }

    public void debugf(String format, Object param1, Object param2, Object param3) {
    }

    public void debugf(Throwable t, String format, Object... params) {
    }

    public void debugf(Throwable t, String format, Object param1) {
    }

    public void debugf(Throwable t, String format, Object param1, Object param2) {
    }

    public void debugf(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void debugf(final String format, final int arg) {
    }

    public void debugf(final String format, final int arg1, final int arg2) {
    }

    public void debugf(final String format, final int arg1, final Object arg2) {
    }

    public void debugf(final String format, final int arg1, final int arg2, final int arg3) {
    }

    public void debugf(final String format, final int arg1, final int arg2, final Object arg3) {
    }

    public void debugf(final String format, final int arg1, final Object arg2, final Object arg3) {
    }

    public void debugf(final Throwable t, final String format, final int arg) {
    }

    public void debugf(final Throwable t, final String format, final int arg1, final int arg2) {
    }

    public void debugf(final Throwable t, final String format, final int arg1, final Object arg2) {
    }

    public void debugf(final Throwable t, final String format, final int arg1, final int arg2, final int arg3) {
    }

    public void debugf(final Throwable t, final String format, final int arg1, final int arg2, final Object arg3) {
    }

    public void debugf(final Throwable t, final String format, final int arg1, final Object arg2, final Object arg3) {
    }

    public void debugf(final String format, final long arg) {
    }

    public void debugf(final String format, final long arg1, final long arg2) {
    }

    public void debugf(final String format, final long arg1, final Object arg2) {
    }

    public void debugf(final String format, final long arg1, final long arg2, final long arg3) {
    }

    public void debugf(final String format, final long arg1, final long arg2, final Object arg3) {
    }

    public void debugf(final String format, final long arg1, final Object arg2, final Object arg3) {
    }

    public void debugf(final Throwable t, final String format, final long arg) {
    }

    public void debugf(final Throwable t, final String format, final long arg1, final long arg2) {
    }

    public void debugf(final Throwable t, final String format, final long arg1, final Object arg2) {
    }

    public void debugf(final Throwable t, final String format, final long arg1, final long arg2, final long arg3) {
    }

    public void debugf(final Throwable t, final String format, final long arg1, final long arg2, final Object arg3) {
    }

    public void debugf(final Throwable t, final String format, final long arg1, final Object arg2, final Object arg3) {
    }

    public boolean isInfoEnabled() {
      return false;
    }

    public void info(Object message) {
    }

    public void info(Object message, Throwable t) {
    }

    public void info(String loggerFqcn, Object message, Throwable t) {
    }

    public void info(Object message, Object[] params) {
    }

    public void info(Object message, Object[] params, Throwable t) {
    }

    public void info(String loggerFqcn, Object message, Object[] params, Throwable t) {
    }

    public void infov(String format, Object... params) {
    }

    public void infov(String format, Object param1) {
    }

    public void infov(String format, Object param1, Object param2) {
    }

    public void infov(String format, Object param1, Object param2, Object param3) {
    }

    public void infov(Throwable t, String format, Object... params) {
    }

    public void infov(Throwable t, String format, Object param1) {
    }

    public void infov(Throwable t, String format, Object param1, Object param2) {
    }

    public void infov(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void infof(String format, Object... params) {
    }

    public void infof(String format, Object param1) {
    }

    public void infof(String format, Object param1, Object param2) {
    }

    public void infof(String format, Object param1, Object param2, Object param3) {
    }

    public void infof(Throwable t, String format, Object... params) {
    }

    public void infof(Throwable t, String format, Object param1) {
    }

    public void infof(Throwable t, String format, Object param1, Object param2) {
    }

    public void infof(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void warn(Object message) {
    }

    public void warn(Object message, Throwable t) {
    }

    public void warn(String loggerFqcn, Object message, Throwable t) {
    }

    public void warn(Object message, Object[] params) {
    }

    public void warn(Object message, Object[] params, Throwable t) {
    }

    public void warn(String loggerFqcn, Object message, Object[] params, Throwable t) {
    }

    public void warnv(String format, Object... params) {
    }

    public void warnv(String format, Object param1) {
    }

    public void warnv(String format, Object param1, Object param2) {
    }

    public void warnv(String format, Object param1, Object param2, Object param3) {
    }

    public void warnv(Throwable t, String format, Object... params) {
    }

    public void warnv(Throwable t, String format, Object param1) {
    }

    public void warnv(Throwable t, String format, Object param1, Object param2) {
    }

    public void warnv(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void warnf(String format, Object... params) {
    }

    public void warnf(String format, Object param1) {
    }

    public void warnf(String format, Object param1, Object param2) {
    }

    public void warnf(String format, Object param1, Object param2, Object param3) {
    }

    public void warnf(Throwable t, String format, Object... params) {
    }

    public void warnf(Throwable t, String format, Object param1) {
    }

    public void warnf(Throwable t, String format, Object param1, Object param2) {
    }

    public void warnf(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void error(Object message) {
    }

    public void error(Object message, Throwable t) {
    }

    public void error(String loggerFqcn, Object message, Throwable t) {
    }

    public void error(Object message, Object[] params) {
    }

    public void error(Object message, Object[] params, Throwable t) {
    }

    public void error(String loggerFqcn, Object message, Object[] params, Throwable t) {
    }

    public void errorv(String format, Object... params) {
    }

    public void errorv(String format, Object param1) {
    }

    public void errorv(String format, Object param1, Object param2) {
    }

    public void errorv(String format, Object param1, Object param2, Object param3) {
    }

    public void errorv(Throwable t, String format, Object... params) {
    }

    public void errorv(Throwable t, String format, Object param1) {
    }

    public void errorv(Throwable t, String format, Object param1, Object param2) {
    }

    public void errorv(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void errorf(String format, Object... params) {
    }

    public void errorf(String format, Object param1) {
    }

    public void errorf(String format, Object param1, Object param2) {
    }

    public void errorf(String format, Object param1, Object param2, Object param3) {
    }

    public void errorf(Throwable t, String format, Object... params) {
    }

    public void errorf(Throwable t, String format, Object param1) {
    }

    public void errorf(Throwable t, String format, Object param1, Object param2) {
    }

    public void errorf(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void fatal(Object message) {
    }

    public void fatal(Object message, Throwable t) {
    }

    public void fatal(String loggerFqcn, Object message, Throwable t) {
    }

    public void fatal(Object message, Object[] params) {
    }

    public void fatal(Object message, Object[] params, Throwable t) {
    }

    public void fatal(String loggerFqcn, Object message, Object[] params, Throwable t) {
    }

    public void fatalv(String format, Object... params) {
    }

    public void fatalv(String format, Object param1) {
    }

    public void fatalv(String format, Object param1, Object param2) {
    }

    public void fatalv(String format, Object param1, Object param2, Object param3) {
    }

    public void fatalv(Throwable t, String format, Object... params) {
    }

    public void fatalv(Throwable t, String format, Object param1) {
    }

    public void fatalv(Throwable t, String format, Object param1, Object param2) {
    }

    public void fatalv(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void fatalf(String format, Object... params) {
    }

    public void fatalf(String format, Object param1) {
    }

    public void fatalf(String format, Object param1, Object param2) {
    }

    public void fatalf(String format, Object param1, Object param2, Object param3) {
    }

    public void fatalf(Throwable t, String format, Object... params) {
    }

    public void fatalf(Throwable t, String format, Object param1) {
    }

    public void fatalf(Throwable t, String format, Object param1, Object param2) {
    }

    public void fatalf(Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void log(Level level, Object message) {
    }

    public void log(Level level, Object message, Throwable t) {
    }

    public void log(Level level, String loggerFqcn, Object message, Throwable t) {
    }

    public void log(Level level, Object message, Object[] params) {
    }

    public void log(Level level, Object message, Object[] params, Throwable t) {
    }

    public void log(String loggerFqcn, Level level, Object message, Object[] params, Throwable t) {
    }

    public void logv(Level level, String format, Object... params) {
    }

    public void logv(Level level, String format, Object param1) {
    }

    public void logv(Level level, String format, Object param1, Object param2) {
    }

    public void logv(Level level, String format, Object param1, Object param2, Object param3) {
    }

    public void logv(Level level, Throwable t, String format, Object... params) {
    }

    public void logv(Level level, Throwable t, String format, Object param1) {
    }

    public void logv(Level level, Throwable t, String format, Object param1, Object param2) {
    }

    public void logv(Level level, Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void logv(String loggerFqcn, Level level, Throwable t, String format, Object... params) {
    }

    public void logv(String loggerFqcn, Level level, Throwable t, String format, Object param1) {
    }

    public void logv(String loggerFqcn, Level level, Throwable t, String format, Object param1, Object param2) {
    }

    public void logv(String loggerFqcn, Level level, Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void logf(Level level, String format, Object... params) {
    }

    public void logf(Level level, String format, Object param1) {
    }

    public void logf(Level level, String format, Object param1, Object param2) {
    }

    public void logf(Level level, String format, Object param1, Object param2, Object param3) {
    }

    public void logf(Level level, Throwable t, String format, Object... params) {
    }

    public void logf(Level level, Throwable t, String format, Object param1) {
    }

    public void logf(Level level, Throwable t, String format, Object param1, Object param2) {
    }

    public void logf(Level level, Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void logf(String loggerFqcn, Level level, Throwable t, String format, Object param1) {
    }

    public void logf(String loggerFqcn, Level level, Throwable t, String format, Object param1, Object param2) {
    }

    public void logf(String loggerFqcn, Level level, Throwable t, String format, Object param1, Object param2, Object param3) {
    }

    public void logf(String loggerFqcn, Level level, Throwable t, String format, Object... params) {
    }

    public static Logger getLogger(String name) {
      return null;
    }

    public static Logger getLogger(String name, String suffix) {
      return null;
    }

    public static Logger getLogger(Class<?> clazz) {
      return null;
    }

    public static Logger getLogger(Class<?> clazz, String suffix) {
      return null;
    }

    public static <T> T getMessageLogger(Class<T> type, String category) {
      return null;
    }

    public static <T> T getMessageLogger(final Class<T> type, final String category, final Locale locale) {
      return null;
    }

}
