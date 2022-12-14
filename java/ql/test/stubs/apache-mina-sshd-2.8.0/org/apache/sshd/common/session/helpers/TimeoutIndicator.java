// Generated automatically from org.apache.sshd.common.session.helpers.TimeoutIndicator for testing purposes

package org.apache.sshd.common.session.helpers;

import java.time.Duration;

public class TimeoutIndicator
{
    protected TimeoutIndicator() {}
    public Duration getExpiredValue(){ return null; }
    public Duration getThresholdValue(){ return null; }
    public String toString(){ return null; }
    public TimeoutIndicator(TimeoutIndicator.TimeoutStatus p0, Duration p1, Duration p2){}
    public TimeoutIndicator.TimeoutStatus getStatus(){ return null; }
    public static String toDisplayDurationValue(Duration p0){ return null; }
    public static TimeoutIndicator NONE = null;
    static public enum TimeoutStatus
    {
        AuthTimeout, IdleTimeout, NoTimeout;
        private TimeoutStatus() {}
    }
}
