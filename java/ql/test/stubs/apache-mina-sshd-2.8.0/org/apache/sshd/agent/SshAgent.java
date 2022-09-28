// Generated automatically from org.apache.sshd.agent.SshAgent for testing purposes

package org.apache.sshd.agent;

import java.nio.channels.Channel;
import java.security.KeyPair;
import java.security.PublicKey;
import java.util.Map;
import org.apache.sshd.agent.SshAgentKeyConstraint;
import org.apache.sshd.common.session.SessionContext;

public interface SshAgent extends Channel
{
    Iterable<? extends Map.Entry<PublicKey, String>> getIdentities();
    Map.Entry<String, byte[]> sign(SessionContext p0, PublicKey p1, String p2, byte[] p3);
    default KeyPair resolveLocalIdentity(PublicKey p0){ return null; }
    static String SSH_AUTHSOCKET_ENV_NAME = null;
    void addIdentity(KeyPair p0, String p1, SshAgentKeyConstraint... p2);
    void removeAllIdentities();
    void removeIdentity(PublicKey p0);
}
