// Generated automatically from org.apache.hc.core5.util.TimeValue for testing purposes

package org.apache.hc.core5.util;

import java.time.Duration;
import java.util.concurrent.TimeUnit;
import org.apache.hc.core5.util.Timeout;

public class TimeValue implements Comparable<TimeValue>
{
    protected TimeValue() {}
    public Duration toDuration(){ return null; }
    public String toString(){ return null; }
    public TimeUnit getTimeUnit(){ return null; }
    public TimeValue divide(long p0){ return null; }
    public TimeValue divide(long p0, TimeUnit p1){ return null; }
    public TimeValue min(TimeValue p0){ return null; }
    public Timeout toTimeout(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int compareTo(TimeValue p0){ return 0; }
    public int hashCode(){ return 0; }
    public int toMillisecondsIntBound(){ return 0; }
    public int toSecondsIntBound(){ return 0; }
    public long convert(TimeUnit p0){ return 0; }
    public long getDuration(){ return 0; }
    public long toDays(){ return 0; }
    public long toHours(){ return 0; }
    public long toMicroseconds(){ return 0; }
    public long toMilliseconds(){ return 0; }
    public long toMinutes(){ return 0; }
    public long toNanoseconds(){ return 0; }
    public long toSeconds(){ return 0; }
    public static <T extends TimeValue> T defaultsTo(T p0, T p1){ return null; }
    public static TimeValue MAX_VALUE = null;
    public static TimeValue NEG_ONE_MILLISECOND = null;
    public static TimeValue NEG_ONE_SECOND = null;
    public static TimeValue ZERO_MILLISECONDS = null;
    public static TimeValue defaultsToNegativeOneMillisecond(TimeValue p0){ return null; }
    public static TimeValue defaultsToNegativeOneSecond(TimeValue p0){ return null; }
    public static TimeValue defaultsToZeroMilliseconds(TimeValue p0){ return null; }
    public static TimeValue of(Duration p0){ return null; }
    public static TimeValue of(long p0, TimeUnit p1){ return null; }
    public static TimeValue ofDays(long p0){ return null; }
    public static TimeValue ofHours(long p0){ return null; }
    public static TimeValue ofMicroseconds(long p0){ return null; }
    public static TimeValue ofMilliseconds(long p0){ return null; }
    public static TimeValue ofMinutes(long p0){ return null; }
    public static TimeValue ofNanoseconds(long p0){ return null; }
    public static TimeValue ofSeconds(long p0){ return null; }
    public static TimeValue parse(String p0){ return null; }
    public static boolean isNonNegative(TimeValue p0){ return false; }
    public static boolean isPositive(TimeValue p0){ return false; }
    public static int asBoundInt(long p0){ return 0; }
    public void sleep(){}
    public void timedJoin(Thread p0){}
    public void timedWait(Object p0){}
}
