// Generated automatically from org.apache.commons.logging.Log for testing purposes

package org.apache.commons.logging;


public interface Log
{
    boolean isDebugEnabled();
    boolean isErrorEnabled();
    boolean isFatalEnabled();
    boolean isInfoEnabled();
    boolean isTraceEnabled();
    boolean isWarnEnabled();
    void debug(Object p0);
    void debug(Object p0, Throwable p1);
    void error(Object p0);
    void error(Object p0, Throwable p1);
    void fatal(Object p0);
    void fatal(Object p0, Throwable p1);
    void info(Object p0);
    void info(Object p0, Throwable p1);
    void trace(Object p0);
    void trace(Object p0, Throwable p1);
    void warn(Object p0);
    void warn(Object p0, Throwable p1);
}
