// Generated automatically from org.apache.hc.core5.util.Timeout for testing purposes

package org.apache.hc.core5.util;

import java.time.Duration;
import java.util.concurrent.TimeUnit;
import org.apache.hc.core5.util.TimeValue;

public class Timeout extends TimeValue
{
    protected Timeout() {}
    public boolean isDisabled(){ return false; }
    public boolean isEnabled(){ return false; }
    public static Timeout DISABLED = null;
    public static Timeout ONE_MILLISECOND = null;
    public static Timeout ZERO_MILLISECONDS = null;
    public static Timeout defaultsToDisabled(Timeout p0){ return null; }
    public static Timeout of(Duration p0){ return null; }
    public static Timeout of(long p0, TimeUnit p1){ return null; }
    public static Timeout ofDays(long p0){ return null; }
    public static Timeout ofHours(long p0){ return null; }
    public static Timeout ofMicroseconds(long p0){ return null; }
    public static Timeout ofMilliseconds(long p0){ return null; }
    public static Timeout ofMinutes(long p0){ return null; }
    public static Timeout ofNanoseconds(long p0){ return null; }
    public static Timeout ofSeconds(long p0){ return null; }
    public static Timeout parse(String p0){ return null; }
}
