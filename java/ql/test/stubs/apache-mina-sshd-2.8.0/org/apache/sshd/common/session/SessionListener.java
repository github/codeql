// Generated automatically from org.apache.sshd.common.session.SessionListener for testing purposes

package org.apache.sshd.common.session;

import java.util.List;
import java.util.Map;
import org.apache.sshd.common.kex.KexProposalOption;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.util.SshdEventListener;

public interface SessionListener extends SshdEventListener
{
    default void sessionClosed(Session p0){}
    default void sessionCreated(Session p0){}
    default void sessionDisconnect(Session p0, int p1, String p2, String p3, boolean p4){}
    default void sessionEstablished(Session p0){}
    default void sessionEvent(Session p0, SessionListener.Event p1){}
    default void sessionException(Session p0, Throwable p1){}
    default void sessionNegotiationEnd(Session p0, Map<KexProposalOption, String> p1, Map<KexProposalOption, String> p2, Map<KexProposalOption, String> p3, Throwable p4){}
    default void sessionNegotiationOptionsCreated(Session p0, Map<KexProposalOption, String> p1){}
    default void sessionNegotiationStart(Session p0, Map<KexProposalOption, String> p1, Map<KexProposalOption, String> p2){}
    default void sessionPeerIdentificationLine(Session p0, String p1, List<String> p2){}
    default void sessionPeerIdentificationReceived(Session p0, String p1, List<String> p2){}
    default void sessionPeerIdentificationSend(Session p0, String p1, List<String> p2){}
    static <L extends SessionListener> L validateListener(L p0){ return null; }
    static public enum Event
    {
        Authenticated, KexCompleted, KeyEstablished;
        private Event() {}
    }
}
