// Generated automatically from org.springframework.web.socket.CloseStatus for testing purposes

package org.springframework.web.socket;

import java.io.Serializable;

public class CloseStatus implements Serializable
{
    protected CloseStatus() {}
    public CloseStatus withReason(String p0){ return null; }
    public CloseStatus(int p0){}
    public CloseStatus(int p0, String p1){}
    public String getReason(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean equalsCode(CloseStatus p0){ return false; }
    public int getCode(){ return 0; }
    public int hashCode(){ return 0; }
    public static CloseStatus BAD_DATA = null;
    public static CloseStatus GOING_AWAY = null;
    public static CloseStatus NORMAL = null;
    public static CloseStatus NOT_ACCEPTABLE = null;
    public static CloseStatus NO_CLOSE_FRAME = null;
    public static CloseStatus NO_STATUS_CODE = null;
    public static CloseStatus POLICY_VIOLATION = null;
    public static CloseStatus PROTOCOL_ERROR = null;
    public static CloseStatus REQUIRED_EXTENSION = null;
    public static CloseStatus SERVER_ERROR = null;
    public static CloseStatus SERVICE_OVERLOAD = null;
    public static CloseStatus SERVICE_RESTARTED = null;
    public static CloseStatus SESSION_NOT_RELIABLE = null;
    public static CloseStatus TLS_HANDSHAKE_FAILURE = null;
    public static CloseStatus TOO_BIG_TO_PROCESS = null;
}
