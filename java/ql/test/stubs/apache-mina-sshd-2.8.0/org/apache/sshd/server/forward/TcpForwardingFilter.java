// Generated automatically from org.apache.sshd.server.forward.TcpForwardingFilter for testing purposes

package org.apache.sshd.server.forward;

import java.util.Set;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.util.net.SshdSocketAddress;

public interface TcpForwardingFilter
{
    boolean canConnect(TcpForwardingFilter.Type p0, SshdSocketAddress p1, Session p2);
    boolean canListen(SshdSocketAddress p0, Session p1);
    static TcpForwardingFilter DEFAULT = null;
    static public enum Type
    {
        Direct, Forwarded;
        private Type() {}
        public final String getName(){ return null; }
        public static Set<TcpForwardingFilter.Type> VALUES = null;
        public static TcpForwardingFilter.Type fromEnumName(String p0){ return null; }
        public static TcpForwardingFilter.Type fromName(String p0){ return null; }
        public static TcpForwardingFilter.Type fromString(String p0){ return null; }
    }
}
