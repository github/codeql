// Generated automatically from org.apache.sshd.common.util.logging.SimplifiedLog for testing purposes

package org.apache.sshd.common.util.logging;

import java.util.logging.Level;

public interface SimplifiedLog
{
    boolean isEnabledLevel(Level p0);
    default boolean isDebugEnabled(){ return false; }
    default boolean isErrorEnabled(){ return false; }
    default boolean isInfoEnabled(){ return false; }
    default boolean isTraceEnabled(){ return false; }
    default boolean isWarnEnabled(){ return false; }
    default void debug(String p0){}
    default void debug(String p0, Throwable p1){}
    default void error(String p0){}
    default void error(String p0, Throwable p1){}
    default void info(String p0){}
    default void info(String p0, Throwable p1){}
    default void log(Level p0, Object p1){}
    default void trace(String p0){}
    default void trace(String p0, Throwable p1){}
    default void warn(String p0){}
    default void warn(String p0, Throwable p1){}
    static SimplifiedLog EMPTY = null;
    static boolean isDebugEnabled(Level p0){ return false; }
    static boolean isErrorEnabled(Level p0){ return false; }
    static boolean isInfoEnabled(Level p0){ return false; }
    static boolean isLoggable(Level p0, Level p1){ return false; }
    static boolean isTraceEnabled(Level p0){ return false; }
    static boolean isWarnEnabled(Level p0){ return false; }
    void log(Level p0, Object p1, Throwable p2);
}
