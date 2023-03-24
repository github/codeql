// Generated automatically from org.apache.sshd.client.auth.hostbased.HostBasedAuthenticationReporter for testing purposes

package org.apache.sshd.client.auth.hostbased;

import java.security.KeyPair;
import java.util.List;
import org.apache.sshd.client.session.ClientSession;

public interface HostBasedAuthenticationReporter
{
    default void signalAuthenticationAttempt(ClientSession p0, String p1, KeyPair p2, String p3, String p4, byte[] p5){}
    default void signalAuthenticationExhausted(ClientSession p0, String p1, String p2, String p3){}
    default void signalAuthenticationFailure(ClientSession p0, String p1, KeyPair p2, String p3, String p4, boolean p5, List<String> p6){}
    default void signalAuthenticationSuccess(ClientSession p0, String p1, KeyPair p2, String p3, String p4){}
}
