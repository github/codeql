// Generated automatically from org.apache.sshd.client.keyverifier.ServerKeyVerifier for testing purposes

package org.apache.sshd.client.keyverifier;

import java.net.SocketAddress;
import java.security.PublicKey;
import org.apache.sshd.client.session.ClientSession;

public interface ServerKeyVerifier
{
    boolean verifyServerKey(ClientSession p0, SocketAddress p1, PublicKey p2);
}
