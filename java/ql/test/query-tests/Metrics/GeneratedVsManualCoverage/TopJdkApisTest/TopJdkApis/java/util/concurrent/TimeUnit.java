// Generated automatically from java.util.concurrent.TimeUnit for testing purposes

package java.util.concurrent;

import java.time.Duration;
import java.time.temporal.ChronoUnit;
import java.util.Objects;

public enum TimeUnit
{
    DAYS, HOURS, MICROSECONDS, MILLISECONDS, MINUTES, NANOSECONDS, SECONDS;
    private TimeUnit() {}
    public long toMillis(long p0){ return 0; } // manual neutral

    @Override
    public int compareTo(TimeUnit o) { return 1; }
}
