// Generated automatically from org.slf4j.Logger for testing purposes

package org.slf4j;

import org.slf4j.Marker;
import org.slf4j.event.Level;
import org.slf4j.spi.LoggingEventBuilder;

public interface Logger
{
    String getName();
    boolean isDebugEnabled();
    boolean isDebugEnabled(Marker p0);
    boolean isErrorEnabled();
    boolean isErrorEnabled(Marker p0);
    boolean isInfoEnabled();
    boolean isInfoEnabled(Marker p0);
    boolean isTraceEnabled();
    boolean isTraceEnabled(Marker p0);
    boolean isWarnEnabled();
    boolean isWarnEnabled(Marker p0);
    default LoggingEventBuilder atDebug(){ return null; }
    default LoggingEventBuilder atError(){ return null; }
    default LoggingEventBuilder atInfo(){ return null; }
    default LoggingEventBuilder atTrace(){ return null; }
    default LoggingEventBuilder atWarn(){ return null; }
    default LoggingEventBuilder makeLoggingEventBuilder(Level p0){ return null; }
    default boolean isEnabledForLevel(Level p0){ return false; }
    static String ROOT_LOGGER_NAME = null;
    void debug(Marker p0, String p1);
    void debug(Marker p0, String p1, Object p2);
    void debug(Marker p0, String p1, Object p2, Object p3);
    void debug(Marker p0, String p1, Object... p2);
    void debug(Marker p0, String p1, Throwable p2);
    void debug(String p0);
    void debug(String p0, Object p1);
    void debug(String p0, Object p1, Object p2);
    void debug(String p0, Object... p1);
    void debug(String p0, Throwable p1);
    void error(Marker p0, String p1);
    void error(Marker p0, String p1, Object p2);
    void error(Marker p0, String p1, Object p2, Object p3);
    void error(Marker p0, String p1, Object... p2);
    void error(Marker p0, String p1, Throwable p2);
    void error(String p0);
    void error(String p0, Object p1);
    void error(String p0, Object p1, Object p2);
    void error(String p0, Object... p1);
    void error(String p0, Throwable p1);
    void info(Marker p0, String p1);
    void info(Marker p0, String p1, Object p2);
    void info(Marker p0, String p1, Object p2, Object p3);
    void info(Marker p0, String p1, Object... p2);
    void info(Marker p0, String p1, Throwable p2);
    void info(String p0);
    void info(String p0, Object p1);
    void info(String p0, Object p1, Object p2);
    void info(String p0, Object... p1);
    void info(String p0, Throwable p1);
    void trace(Marker p0, String p1);
    void trace(Marker p0, String p1, Object p2);
    void trace(Marker p0, String p1, Object p2, Object p3);
    void trace(Marker p0, String p1, Object... p2);
    void trace(Marker p0, String p1, Throwable p2);
    void trace(String p0);
    void trace(String p0, Object p1);
    void trace(String p0, Object p1, Object p2);
    void trace(String p0, Object... p1);
    void trace(String p0, Throwable p1);
    void warn(Marker p0, String p1);
    void warn(Marker p0, String p1, Object p2);
    void warn(Marker p0, String p1, Object p2, Object p3);
    void warn(Marker p0, String p1, Object... p2);
    void warn(Marker p0, String p1, Throwable p2);
    void warn(String p0);
    void warn(String p0, Object p1);
    void warn(String p0, Object p1, Object p2);
    void warn(String p0, Object... p1);
    void warn(String p0, Throwable p1);
}
