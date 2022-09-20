// Generated automatically from org.slf4j.spi.LoggingEventBuilder for testing purposes

package org.slf4j.spi;

import java.util.function.Supplier;
import org.slf4j.Marker;

public interface LoggingEventBuilder
{
    LoggingEventBuilder addArgument(Object p0);
    LoggingEventBuilder addArgument(Supplier<? extends Object> p0);
    LoggingEventBuilder addKeyValue(String p0, Object p1);
    LoggingEventBuilder addKeyValue(String p0, Supplier<Object> p1);
    LoggingEventBuilder addMarker(Marker p0);
    LoggingEventBuilder setCause(Throwable p0);
    void log(String p0);
    void log(String p0, Object p1);
    void log(String p0, Object p1, Object p2);
    void log(String p0, Object... p1);
    void log(Supplier<String> p0);
}
