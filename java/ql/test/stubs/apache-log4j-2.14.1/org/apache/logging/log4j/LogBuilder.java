// Generated automatically from org.apache.logging.log4j.LogBuilder for testing purposes

package org.apache.logging.log4j;

import org.apache.logging.log4j.Marker;
import org.apache.logging.log4j.message.Message;
import org.apache.logging.log4j.util.Supplier;

public interface LogBuilder
{
    default LogBuilder withLocation(){ return null; }
    default LogBuilder withLocation(StackTraceElement p0){ return null; }
    default LogBuilder withMarker(Marker p0){ return null; }
    default LogBuilder withThrowable(Throwable p0){ return null; }
    default void log(){}
    default void log(CharSequence p0){}
    default void log(Message p0){}
    default void log(Object p0){}
    default void log(String p0){}
    default void log(String p0, Object p1){}
    default void log(String p0, Object p1, Object p2){}
    default void log(String p0, Object p1, Object p2, Object p3){}
    default void log(String p0, Object p1, Object p2, Object p3, Object p4){}
    default void log(String p0, Object p1, Object p2, Object p3, Object p4, Object p5){}
    default void log(String p0, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6){}
    default void log(String p0, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7){}
    default void log(String p0, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7, Object p8){}
    default void log(String p0, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7, Object p8, Object p9){}
    default void log(String p0, Object p1, Object p2, Object p3, Object p4, Object p5, Object p6, Object p7, Object p8, Object p9, Object p10){}
    default void log(String p0, Object... p1){}
    default void log(String p0, Supplier<? extends Object>... p1){}
    default void log(Supplier<Message> p0){}
    static LogBuilder NOOP = null;
}
