// Generated automatically from org.apache.hc.core5.util.Deadline for testing purposes

package org.apache.hc.core5.util;

import java.util.concurrent.TimeUnit;
import org.apache.hc.core5.util.TimeValue;

public class Deadline
{
    protected Deadline() {}
    public Deadline freeze(){ return null; }
    public Deadline min(Deadline p0){ return null; }
    public String format(TimeUnit p0){ return null; }
    public String formatTarget(){ return null; }
    public String toString(){ return null; }
    public TimeValue remainingTimeValue(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isBefore(long p0){ return false; }
    public boolean isExpired(){ return false; }
    public boolean isMax(){ return false; }
    public boolean isMin(){ return false; }
    public boolean isNotExpired(){ return false; }
    public int hashCode(){ return 0; }
    public long getValue(){ return 0; }
    public long remaining(){ return 0; }
    public static Deadline MAX_VALUE = null;
    public static Deadline MIN_VALUE = null;
    public static Deadline calculate(TimeValue p0){ return null; }
    public static Deadline calculate(long p0, TimeValue p1){ return null; }
    public static Deadline fromUnixMilliseconds(long p0){ return null; }
    public static Deadline parse(String p0){ return null; }
    public static String DATE_FORMAT = null;
}
