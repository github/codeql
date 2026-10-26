/*
 * JBoss, Home of Professional Open Source.
 *
 * Copyright 2010 Red Hat, Inc., and individual contributors as indicated by the @author tags.
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

package org.jboss.logging;

public interface BasicLogger {
    boolean isEnabled(Logger.Level level);

    boolean isTraceEnabled();

    void trace(Object message);

    void trace(Object message, Throwable t);

    void trace(String loggerFqcn, Object message, Throwable t);

    void trace(String loggerFqcn, Object message, Object[] params, Throwable t);

    void tracev(String format, Object... params);

    void tracev(String format, Object param1);

    void tracev(String format, Object param1, Object param2);

    void tracev(String format, Object param1, Object param2, Object param3);

    void tracev(Throwable t, String format, Object... params);

    void tracev(Throwable t, String format, Object param1);

    void tracev(Throwable t, String format, Object param1, Object param2);

    void tracev(Throwable t, String format, Object param1, Object param2, Object param3);

    void tracef(String format, Object... params);

    void tracef(String format, Object param1);

    void tracef(String format, Object param1, Object param2);

    void tracef(String format, Object param1, Object param2, Object param3);

    void tracef(Throwable t, String format, Object... params);

    void tracef(Throwable t, String format, Object param1);

    void tracef(Throwable t, String format, Object param1, Object param2);

    void tracef(Throwable t, String format, Object param1, Object param2, Object param3);

    void tracef(String format, int arg);

    void tracef(String format, int arg1, int arg2);

    void tracef(String format, int arg1, Object arg2);

    void tracef(String format, int arg1, int arg2, int arg3);

    void tracef(String format, int arg1, int arg2, Object arg3);

    void tracef(String format, int arg1, Object arg2, Object arg3);

    void tracef(Throwable t, String format, int arg);

    void tracef(Throwable t, String format, int arg1, int arg2);

    void tracef(Throwable t, String format, int arg1, Object arg2);

    void tracef(Throwable t, String format, int arg1, int arg2, int arg3);

    void tracef(Throwable t, String format, int arg1, int arg2, Object arg3);

    void tracef(Throwable t, String format, int arg1, Object arg2, Object arg3);

    void tracef(String format, long arg);

    void tracef(String format, long arg1, long arg2);

    void tracef(String format, long arg1, Object arg2);

    void tracef(String format, long arg1, long arg2, long arg3);

    void tracef(String format, long arg1, long arg2, Object arg3);

    void tracef(String format, long arg1, Object arg2, Object arg3);

    void tracef(Throwable t, String format, long arg);

    void tracef(Throwable t, String format, long arg1, long arg2);

    void tracef(Throwable t, String format, long arg1, Object arg2);

    void tracef(Throwable t, String format, long arg1, long arg2, long arg3);

    void tracef(Throwable t, String format, long arg1, long arg2, Object arg3);

    void tracef(Throwable t, String format, long arg1, Object arg2, Object arg3);

    boolean isDebugEnabled();

    void debug(Object message);

    void debug(Object message, Throwable t);

    void debug(String loggerFqcn, Object message, Throwable t);

    void debug(String loggerFqcn, Object message, Object[] params, Throwable t);

    void debugv(String format, Object... params);

    void debugv(String format, Object param1);

    void debugv(String format, Object param1, Object param2);

    void debugv(String format, Object param1, Object param2, Object param3);

    void debugv(Throwable t, String format, Object... params);

    void debugv(Throwable t, String format, Object param1);

    void debugv(Throwable t, String format, Object param1, Object param2);

    void debugv(Throwable t, String format, Object param1, Object param2, Object param3);

    void debugf(String format, Object... params);

    void debugf(String format, Object param1);

    void debugf(String format, Object param1, Object param2);

    void debugf(String format, Object param1, Object param2, Object param3);

    void debugf(Throwable t, String format, Object... params);

    void debugf(Throwable t, String format, Object param1);

    void debugf(Throwable t, String format, Object param1, Object param2);

    void debugf(Throwable t, String format, Object param1, Object param2, Object param3);

    void debugf(String format, int arg);

    void debugf(String format, int arg1, int arg2);

    void debugf(String format, int arg1, Object arg2);

    void debugf(String format, int arg1, int arg2, int arg3);

    void debugf(String format, int arg1, int arg2, Object arg3);

    void debugf(String format, int arg1, Object arg2, Object arg3);

    void debugf(Throwable t, String format, int arg);

    void debugf(Throwable t, String format, int arg1, int arg2);

    void debugf(Throwable t, String format, int arg1, Object arg2);

    void debugf(Throwable t, String format, int arg1, int arg2, int arg3);

    void debugf(Throwable t, String format, int arg1, int arg2, Object arg3);

    void debugf(Throwable t, String format, int arg1, Object arg2, Object arg3);

    void debugf(String format, long arg);

    void debugf(String format, long arg1, long arg2);

    void debugf(String format, long arg1, Object arg2);

    void debugf(String format, long arg1, long arg2, long arg3);

    void debugf(String format, long arg1, long arg2, Object arg3);

    void debugf(String format, long arg1, Object arg2, Object arg3);

    void debugf(Throwable t, String format, long arg);

    void debugf(Throwable t, String format, long arg1, long arg2);

    void debugf(Throwable t, String format, long arg1, Object arg2);

    void debugf(Throwable t, String format, long arg1, long arg2, long arg3);

    void debugf(Throwable t, String format, long arg1, long arg2, Object arg3);

    void debugf(Throwable t, String format, long arg1, Object arg2, Object arg3);

    boolean isInfoEnabled();

    void info(Object message);

    void info(Object message, Throwable t);

    void info(String loggerFqcn, Object message, Throwable t);

    void info(String loggerFqcn, Object message, Object[] params, Throwable t);

    void infov(String format, Object... params);

    void infov(String format, Object param1);

    void infov(String format, Object param1, Object param2);

    void infov(String format, Object param1, Object param2, Object param3);

    void infov(Throwable t, String format, Object... params);

    void infov(Throwable t, String format, Object param1);

    void infov(Throwable t, String format, Object param1, Object param2);

    void infov(Throwable t, String format, Object param1, Object param2, Object param3);

    void infof(String format, Object... params);

    void infof(String format, Object param1);

    void infof(String format, Object param1, Object param2);

    void infof(String format, Object param1, Object param2, Object param3);

    void infof(Throwable t, String format, Object... params);

    void infof(Throwable t, String format, Object param1);

    void infof(Throwable t, String format, Object param1, Object param2);

    void infof(Throwable t, String format, Object param1, Object param2, Object param3);

    void warn(Object message);

    void warn(Object message, Throwable t);

    void warn(String loggerFqcn, Object message, Throwable t);

    void warn(String loggerFqcn, Object message, Object[] params, Throwable t);

    void warnv(String format, Object... params);

    void warnv(String format, Object param1);

    void warnv(String format, Object param1, Object param2);

    void warnv(String format, Object param1, Object param2, Object param3);

    void warnv(Throwable t, String format, Object... params);

    void warnv(Throwable t, String format, Object param1);

    void warnv(Throwable t, String format, Object param1, Object param2);

    void warnv(Throwable t, String format, Object param1, Object param2, Object param3);

    void warnf(String format, Object... params);

    void warnf(String format, Object param1);

    void warnf(String format, Object param1, Object param2);

    void warnf(String format, Object param1, Object param2, Object param3);

    void warnf(Throwable t, String format, Object... params);

    void warnf(Throwable t, String format, Object param1);

    void warnf(Throwable t, String format, Object param1, Object param2);

    void warnf(Throwable t, String format, Object param1, Object param2, Object param3);

    void error(Object message);

    void error(Object message, Throwable t);

    void error(String loggerFqcn, Object message, Throwable t);

    void error(String loggerFqcn, Object message, Object[] params, Throwable t);

    void errorv(String format, Object... params);

    void errorv(String format, Object param1);

    void errorv(String format, Object param1, Object param2);

    void errorv(String format, Object param1, Object param2, Object param3);

    void errorv(Throwable t, String format, Object... params);

    void errorv(Throwable t, String format, Object param1);

    void errorv(Throwable t, String format, Object param1, Object param2);

    void errorv(Throwable t, String format, Object param1, Object param2, Object param3);

    void errorf(String format, Object... params);

    void errorf(String format, Object param1);

    void errorf(String format, Object param1, Object param2);

    void errorf(String format, Object param1, Object param2, Object param3);

    void errorf(Throwable t, String format, Object... params);

    void errorf(Throwable t, String format, Object param1);

    void errorf(Throwable t, String format, Object param1, Object param2);

    void errorf(Throwable t, String format, Object param1, Object param2, Object param3);

    void fatal(Object message);

    void fatal(Object message, Throwable t);

    void fatal(String loggerFqcn, Object message, Throwable t);

    void fatal(String loggerFqcn, Object message, Object[] params, Throwable t);

    void fatalv(String format, Object... params);

    void fatalv(String format, Object param1);

    void fatalv(String format, Object param1, Object param2);

    void fatalv(String format, Object param1, Object param2, Object param3);

    void fatalv(Throwable t, String format, Object... params);

    void fatalv(Throwable t, String format, Object param1);

    void fatalv(Throwable t, String format, Object param1, Object param2);

    void fatalv(Throwable t, String format, Object param1, Object param2, Object param3);

    void fatalf(String format, Object... params);

    void fatalf(String format, Object param1);

    void fatalf(String format, Object param1, Object param2);

    void fatalf(String format, Object param1, Object param2, Object param3);

    void fatalf(Throwable t, String format, Object... params);

    void fatalf(Throwable t, String format, Object param1);

    void fatalf(Throwable t, String format, Object param1, Object param2);

    void fatalf(Throwable t, String format, Object param1, Object param2, Object param3);

    void log(Logger.Level level, Object message);

    void log(Logger.Level level, Object message, Throwable t);

    void log(Logger.Level level, String loggerFqcn, Object message, Throwable t);

    void log(String loggerFqcn, Logger.Level level, Object message, Object[] params, Throwable t);

    void logv(Logger.Level level, String format, Object... params);

    void logv(Logger.Level level, String format, Object param1);

    void logv(Logger.Level level, String format, Object param1, Object param2);

    void logv(Logger.Level level, String format, Object param1, Object param2, Object param3);

    void logv(Logger.Level level, Throwable t, String format, Object... params);

    void logv(Logger.Level level, Throwable t, String format, Object param1);

    void logv(Logger.Level level, Throwable t, String format, Object param1, Object param2);

    void logv(Logger.Level level, Throwable t, String format, Object param1, Object param2,
            Object param3);

    void logv(String loggerFqcn, Logger.Level level, Throwable t, String format, Object... params);

    void logv(String loggerFqcn, Logger.Level level, Throwable t, String format, Object param1);

    void logv(String loggerFqcn, Logger.Level level, Throwable t, String format, Object param1,
            Object param2);

    void logv(String loggerFqcn, Logger.Level level, Throwable t, String format, Object param1,
            Object param2, Object param3);

    void logf(Logger.Level level, String format, Object... params);

    void logf(Logger.Level level, String format, Object param1);

    void logf(Logger.Level level, String format, Object param1, Object param2);

    void logf(Logger.Level level, String format, Object param1, Object param2, Object param3);

    void logf(Logger.Level level, Throwable t, String format, Object... params);

    void logf(Logger.Level level, Throwable t, String format, Object param1);

    void logf(Logger.Level level, Throwable t, String format, Object param1, Object param2);

    void logf(Logger.Level level, Throwable t, String format, Object param1, Object param2,
            Object param3);

    void logf(String loggerFqcn, Logger.Level level, Throwable t, String format, Object param1);

    void logf(String loggerFqcn, Logger.Level level, Throwable t, String format, Object param1,
            Object param2);

    void logf(String loggerFqcn, Logger.Level level, Throwable t, String format, Object param1,
            Object param2, Object param3);

    void logf(String loggerFqcn, Logger.Level level, Throwable t, String format, Object... params);

}
