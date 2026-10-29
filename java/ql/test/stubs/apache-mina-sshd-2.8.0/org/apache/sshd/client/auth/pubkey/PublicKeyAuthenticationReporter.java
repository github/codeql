// Generated automatically from org.apache.sshd.client.auth.pubkey.PublicKeyAuthenticationReporter for testing purposes

package org.apache.sshd.client.auth.pubkey;

import java.security.KeyPair;
import java.util.List;
import org.apache.sshd.client.session.ClientSession;

public interface PublicKeyAuthenticationReporter
{
    default void signalAuthenticationAttempt(ClientSession p0, String p1, KeyPair p2, String p3){}
    default void signalAuthenticationExhausted(ClientSession p0, String p1){}
    default void signalAuthenticationFailure(ClientSession p0, String p1, KeyPair p2, boolean p3, List<String> p4){}
    default void signalAuthenticationSuccess(ClientSession p0, String p1, KeyPair p2){}
    default void signalSignatureAttempt(ClientSession p0, String p1, KeyPair p2, String p3, byte[] p4){}
}
