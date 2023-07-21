// Generated automatically from org.codehaus.cargo.util.log.Logger for testing purposes

package org.codehaus.cargo.util.log;

import org.codehaus.cargo.util.log.LogLevel;

public interface Logger
{
    LogLevel getLevel();
    void debug(String p0, String p1);
    void info(String p0, String p1);
    void setLevel(LogLevel p0);
    void warn(String p0, String p1);
}
