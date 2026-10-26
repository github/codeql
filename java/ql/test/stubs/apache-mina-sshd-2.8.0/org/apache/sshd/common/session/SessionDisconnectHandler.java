// Generated automatically from org.apache.sshd.common.session.SessionDisconnectHandler for testing purposes

package org.apache.sshd.common.session;

import java.util.Map;
import org.apache.sshd.common.Service;
import org.apache.sshd.common.kex.KexProposalOption;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.helpers.TimeoutIndicator;
import org.apache.sshd.common.util.buffer.Buffer;

public interface SessionDisconnectHandler
{
    default boolean handleAuthCountDisconnectReason(Session p0, Service p1, String p2, String p3, String p4, int p5, int p6){ return false; }
    default boolean handleAuthParamsDisconnectReason(Session p0, Service p1, String p2, String p3, String p4, String p5){ return false; }
    default boolean handleKexDisconnectReason(Session p0, Map<KexProposalOption, String> p1, Map<KexProposalOption, String> p2, Map<KexProposalOption, String> p3, KexProposalOption p4){ return false; }
    default boolean handleSessionsCountDisconnectReason(Session p0, Service p1, String p2, int p3, int p4){ return false; }
    default boolean handleTimeoutDisconnectReason(Session p0, TimeoutIndicator p1){ return false; }
    default boolean handleUnsupportedServiceDisconnectReason(Session p0, int p1, String p2, Buffer p3){ return false; }
}
