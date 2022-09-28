// Generated automatically from org.apache.sshd.common.session.SessionHeartbeatController for testing purposes

package org.apache.sshd.common.session;

import java.time.Duration;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import org.apache.sshd.common.PropertyResolver;

public interface SessionHeartbeatController extends PropertyResolver
{
    default Duration getSessionHeartbeatInterval(){ return null; }
    default SessionHeartbeatController.HeartbeatType getSessionHeartbeatType(){ return null; }
    default void disableSessionHeartbeat(){}
    default void setSessionHeartbeat(SessionHeartbeatController.HeartbeatType p0, Duration p1){}
    default void setSessionHeartbeat(SessionHeartbeatController.HeartbeatType p0, TimeUnit p1, long p2){}
    static public enum HeartbeatType
    {
        IGNORE, NONE, RESERVED;
        private HeartbeatType() {}
        public static SessionHeartbeatController.HeartbeatType fromName(String p0){ return null; }
        public static Set<SessionHeartbeatController.HeartbeatType> VALUES = null;
    }
}
